import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_providers.dart';
import '../../providers/user_profile_provider.dart';
import '../main_shell.dart';
import '../onboarding/onboarding_screen.dart';
import 'login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Check if the app-wide onboarding has been completed
    final onboardingAsync = ref.watch(onboardingCompleteProvider);

    return onboardingAsync.when(
      data: (complete) {
        if (!complete) {
          return const OnboardingScreen(key: ValueKey('onboarding'));
        }

        // 2. Onboarding complete — check user auth state
        final authState = ref.watch(authStateProvider);
        return authState.when(
          data: (user) {
            if (user == null) {
              return const LoginScreen(key: ValueKey('login'));
            }
            return const MainShell(key: ValueKey('shell'));
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            body: Center(child: Text('Auth error: $e')),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const LoginScreen(key: ValueKey('login')),
    );
  }
}
