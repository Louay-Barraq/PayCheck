import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────

class UserProfile {
  final String uid;
  final String profession;
  final String ageRange;
  final String countryCode;
  final String countryName;
  final String countryFlag;
  final String currencyCode;
  final String currencySymbol;
  final bool onboardingComplete;

  const UserProfile({
    required this.uid,
    this.profession = '',
    this.ageRange = '',
    this.countryCode = 'TN',
    this.countryName = 'Tunisia',
    this.countryFlag = '🇹🇳',
    this.currencyCode = 'TND',
    this.currencySymbol = 'DT',
    this.onboardingComplete = false,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserProfile(
      uid: uid,
      profession: data['profession'] ?? '',
      ageRange: data['ageRange'] ?? '',
      countryCode: data['countryCode'] ?? 'TN',
      countryName: data['countryName'] ?? 'Tunisia',
      countryFlag: data['countryFlag'] ?? '🇹🇳',
      currencyCode: data['currencyCode'] ?? 'TND',
      currencySymbol: data['currencySymbol'] ?? 'DT',
      onboardingComplete: data['onboardingComplete'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'profession': profession,
        'ageRange': ageRange,
        'countryCode': countryCode,
        'countryName': countryName,
        'countryFlag': countryFlag,
        'currencyCode': currencyCode,
        'currencySymbol': currencySymbol,
        'onboardingComplete': onboardingComplete,
      };

  UserProfile copyWith({
    String? profession,
    String? ageRange,
    String? countryCode,
    String? countryName,
    String? countryFlag,
    String? currencyCode,
    String? currencySymbol,
    bool? onboardingComplete,
  }) {
    return UserProfile(
      uid: uid,
      profession: profession ?? this.profession,
      ageRange: ageRange ?? this.ageRange,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      countryFlag: countryFlag ?? this.countryFlag,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}

// ─────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  static const _onboardingKey = 'onboarding_complete';

  FirebaseFirestore get _db => FirebaseFirestore.instance;
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Future<UserProfile> build() async {
    final uid = _uid;
    if (uid == null) return const UserProfile(uid: '');

    try {
      final doc = await _db.collection('users').doc(uid).collection('profile').doc('data').get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromFirestore(doc.data()!, uid);
      }
    } catch (_) {}
    return UserProfile(uid: uid);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final uid = _uid;
    if (uid == null) return;
    state = AsyncData(profile);
    try {
      await _db.collection('users').doc(uid).collection('profile').doc('data').set(profile.toFirestore());
    } catch (_) {}
  }

  Future<void> completeOnboarding(UserProfile profile) async {
    final uid = _uid;
    if (uid == null) return;
    final completed = profile.copyWith(onboardingComplete: true);
    state = AsyncData(completed);

    // Persist locally first so user isn't stuck if network or Firestore rules fail
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('${_onboardingKey}_$uid', true);
    } catch (_) {}

    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('profile')
          .doc('data')
          .set(completed.toFirestore());
    } catch (_) {}
  }

  static Future<bool> isOnboardingComplete([String? uid]) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_onboardingKey) == true) return true;
    if (uid != null) {
      return prefs.getBool('${_onboardingKey}_$uid') ?? false;
    }
    return false;
  }
}

// ─────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(UserProfileNotifier.new);

/// Resolves to true once we've checked shared_prefs for onboarding completion.
final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  return UserProfileNotifier.isOnboardingComplete(uid);
});

/// Convenience provider — other screens just watch this for the currency symbol.
final currencySymbolProvider = Provider<String>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.value?.currencySymbol ?? 'DT';
});
