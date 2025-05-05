import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/onboarding/onboarding_provider.dart';
import 'package:whats_clone/view/constants/images.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/constants/uris.dart';
import 'package:whats_clone/view/widgets/app_fill_button.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingEvent = ref.read(onboardingProvider.notifier);
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 45,
                ),
                Image.asset(
                  Images.onboarding,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 42,
                ),
                Text(
                  Strings.onboardingTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 120,
                ),
                TextButton(
                    onPressed: () async => launchUrl(Uri.parse(Uris.privacy)),
                    child: Text(
                      Strings.termsAndPrivacyPolicy,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                const SizedBox(
                  height: 20,
                ),
                AppFillButton(
                    onPressed: () {
                      onboardingEvent.setOnboardingComplete();
                      context.goNamed(RouteName.login);
                    },
                    text: Strings.startMessaging),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
