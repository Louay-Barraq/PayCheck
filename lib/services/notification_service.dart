import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paycheck/models/client.dart';
import 'package:paycheck/models/payment.dart';
import 'package:paycheck/utils/payment_utils.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

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
  Future<bool> requestPermissions() async {
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
      await showWelcomeNotification();
    }
    return granted;
  }

  /// Triggered right after granting permission in onboarding/settings
  Future<void> showWelcomeNotification() async {
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
      title: 'Notifications Enabled ✓',
      body: 'PayCheck will alert you when client payments are due or overdue.',
      notificationDetails: details,
    );
  }

  /// Analyzes clients and payments to trigger alerts for overdue and due-soon clients
  Future<void> checkAndSendPaymentAlerts({
    required List<Client> clients,
    required Map<String, List<Payment>> paymentsByClient,
    required String currencySymbol,
  }) async {
    await initialize();

    int notificationId = 100;

    for (final client in clients) {
      if (!client.isActive) continue;

      final payments = paymentsByClient[client.id] ?? [];
      final isClientOverdue = isOverdue(client, payments);
      final nextDue = computeNextDue(client, payments);
      final daysUntilDue = nextDue.difference(DateTime.now()).inDays;

      if (isClientOverdue) {
        final androidDetails = AndroidNotificationDetails(
          'payment_reminders',
          'Payment Reminders',
          channelDescription: 'Reminders for client payment due dates and overdue payments',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );
        final details = NotificationDetails(android: androidDetails, iOS: const DarwinNotificationDetails());

        await _notificationsPlugin.show(
          id: notificationId++,
          title: '⚠️ Overdue Payment Alert',
          body: '${client.fullName} owes ${client.amountDue.toStringAsFixed(0)} $currencySymbol (Contract N° ${client.contractNumber})',
          notificationDetails: details,
        );
      } else if (daysUntilDue >= 0 && daysUntilDue <= 3) {
        final androidDetails = AndroidNotificationDetails(
          'payment_reminders',
          'Payment Reminders',
          channelDescription: 'Reminders for client payment due dates and overdue payments',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        );
        final details = NotificationDetails(android: androidDetails, iOS: const DarwinNotificationDetails());

        final dueMsg = daysUntilDue == 0
            ? 'Payment due today!'
            : 'Payment due in $daysUntilDue day(s)';

        await _notificationsPlugin.show(
          id: notificationId++,
          title: '📅 Payment Due Soon',
          body: '${client.fullName} — $dueMsg (${client.amountDue.toStringAsFixed(0)} $currencySymbol)',
          notificationDetails: details,
        );
      }
    }
  }
}
