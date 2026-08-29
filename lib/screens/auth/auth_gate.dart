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
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        // ValueKey forces Flutter to fully unmount/remount the subtree
        // when the auth state flips — no stale navigator stack can survive.
        if (user == null) {
          return const LoginScreen(key: ValueKey('login'));
        }

        // User is authenticated — check if onboarding is done
        final onboardingAsync = ref.watch(onboardingCompleteProvider);
        return onboardingAsync.when(
          data: (complete) => complete
              ? const MainShell(key: ValueKey('shell'))
              : const OnboardingScreen(key: ValueKey('onboarding')),
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) =>
              const MainShell(key: ValueKey('shell')), // fail open → show app
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Auth error: $e')),
      ),
    );
  }
}
