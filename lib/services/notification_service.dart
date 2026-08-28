import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paycheck/models/client.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Localized strings/templates needed to build notification content.
/// Built by the caller (which has a BuildContext) from AppLocalizations,
/// since NotificationService itself has no access to context.
class NotificationTexts {
  final String enabledTitle;
  final String enabledBody;
  final String overdueTitle;
  final String Function(String clientName, String amount, String currency, String contractNumber) overdueBody;
  final String dueSoonTitle;
  final String dueTodayMsg;
  final String Function(int days) dueInDaysMsg;
  final String Function(String clientName, String dueMsg, String amount, String currency) dueSoonBody;

  const NotificationTexts({
    required this.enabledTitle,
    required this.enabledBody,
    required this.overdueTitle,
    required this.overdueBody,
    required this.dueSoonTitle,
    required this.dueTodayMsg,
    required this.dueInDaysMsg,
    required this.dueSoonBody,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const _dateKey = 'notif_check_date';
  static const _sentKeysKey = 'notif_sent_keys';

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(settings: initSettings);
    _initialized = true;

    // Create high importance Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'payment_reminders',
      'Payment Reminders',
      description: 'Reminders for client payment due dates and overdue payments',
      importance: Importance.high,
    );

    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(androidChannel);
    }
  }

  /// Request runtime notification permissions (Android 13+ and iOS)
  Future<bool> requestPermissions({required NotificationTexts texts}) async {
    await initialize();

    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    bool? androidGranted;
    if (androidPlugin != null) {
      androidGranted = await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    bool? iosGranted;
    if (iosPlugin != null) {
      iosGranted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    final granted = (androidGranted ?? false) || (iosGranted ?? false);
    if (granted) {
      await showWelcomeNotification(texts: texts);
    }
    return granted;
  }

  /// Triggered right after granting permission in onboarding/settings
  Future<void> showWelcomeNotification({required NotificationTexts texts}) async {
    await initialize();
    const androidDetails = AndroidNotificationDetails(
      'payment_reminders',
      'Payment Reminders',
      channelDescription: 'Reminders for client payment due dates and overdue payments',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

    await _notificationsPlugin.show(
      id: 0,
      title: texts.enabledTitle,
      body: texts.enabledBody,
      notificationDetails: details,
    );
  }

  /// Returns true (and records the key) only the first time a given alert
  /// key is seen on a given calendar day. Prevents re-alerting the same
  /// client/state combination every time the dashboard rebuilds — without
  /// this, a Firestore stream re-emission (very common) would re-fire the
  /// exact same notification with sound/vibration repeatedly in one sitting.
  Future<bool> _shouldNotify(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    final storedDate = prefs.getString(_dateKey);

    List<String> sentKeys;
    if (storedDate != today) {
      // New day — reset the dedup set so today's alerts can fire again.
      sentKeys = [];
      await prefs.setString(_dateKey, today);
    } else {
      sentKeys = prefs.getStringList(_sentKeysKey) ?? [];
    }

    if (sentKeys.contains(key)) return false;

    sentKeys.add(key);
    await prefs.setStringList(_sentKeysKey, sentKeys);
    return true;
  }

  /// Sends at most one notification per client/state per day for overdue
  /// and soon-to-be-due clients. [nextDueDates] maps clientId -> next due
  /// date, as already computed by the dashboard.
  Future<void> checkAndSendPaymentAlerts({
    required List<Client> overdueClients,
    required List<Client> dueSoonClients,
    required Map<String, DateTime> nextDueDates,
    required String currencySymbol,
    required NotificationTexts texts,
  }) async {
    await initialize();

    int notificationId = 100;

    for (final client in overdueClients) {
      final key = 'overdue_${client.id}';
      if (!await _shouldNotify(key)) continue;

      const androidDetails = AndroidNotificationDetails(
        'payment_reminders',
        'Payment Reminders',
        channelDescription: 'Reminders for client payment due dates and overdue payments',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      const details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

      await _notificationsPlugin.show(
        id: notificationId++,
        title: texts.overdueTitle,
        body: texts.overdueBody(
          client.fullName,
          client.amountDue.toStringAsFixed(0),
          currencySymbol,
          client.contractNumber,
        ),
        notificationDetails: details,
      );
    }

    for (final client in dueSoonClients) {
      final nextDue = nextDueDates[client.id];
      if (nextDue == null) continue;
      final daysUntilDue = nextDue.difference(DateTime.now()).inDays;
      if (daysUntilDue < 0 || daysUntilDue > 7) continue;

      final key = 'duesoon_${client.id}_$daysUntilDue';
      if (!await _shouldNotify(key)) continue;

      const androidDetails = AndroidNotificationDetails(
        'payment_reminders',
        'Payment Reminders',
        channelDescription: 'Reminders for client payment due dates and overdue payments',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
      );
      const details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

      final dueMsg = daysUntilDue == 0 ? texts.dueTodayMsg : texts.dueInDaysMsg(daysUntilDue);

      await _notificationsPlugin.show(
        id: notificationId++,
        title: texts.dueSoonTitle,
        body: texts.dueSoonBody(
          client.fullName,
          dueMsg,
          client.amountDue.toStringAsFixed(0),
          currencySymbol,
        ),
        notificationDetails: details,
      );
    }
  }
}
