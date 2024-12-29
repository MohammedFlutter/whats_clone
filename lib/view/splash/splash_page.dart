import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/onboarding/onboarding_provider.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';
import 'package:whats_clone/view/constants/assets.dart';
import 'package:whats_clone/view/constants/strings.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _initializeApp(),
    );
  }

  Future<void> _initializeApp() async {
    // Check onboarding status
    final isFirstTime = ref.read(onboardingProvider);
    if (isFirstTime) {
      context.goNamed(RouteName.onboarding);
      return;
    }

    // Check authentication status
    final authState = ref.read(authProvider);
    if (authState.userId == null) {
      context.goNamed(RouteName.login);
      return;
    }

    // Load user profile
    try {
      final userId = authState.userId!;

      await ref
          .read(profileNotifierProvider.notifier)
          .loadProfile(userId: userId);
      final profileStatus = ref.read(profileNotifierProvider).status;
      if (!mounted) return;
      if (profileStatus == ProfileStatus.noProfile) {
        context.goNamed(RouteName.createProfile);
      } else {
        context.goNamed(RouteName.home);
      }
    } catch (e) {
      // Handle potential errors during profile loading
      if (mounted) context.goNamed(RouteName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for profile state changes
    ref.listen<ProfileState>(
      profileNotifierProvider,
      (previous, current) {
        if (previous?.status == ProfileStatus.loading &&
            current.status == ProfileStatus.noProfile) {
          context.goNamed(RouteName.createProfile);
        }
      },
    );

    // Determine logo based on theme
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(isLight ? Assets.logoLight : Assets.logoDark),
            const SizedBox(width: 8.0),
            Text(
              Strings.appTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
      ),
    );
  }
}
