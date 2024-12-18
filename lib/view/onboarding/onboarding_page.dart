import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/view/constants/assets.dart';
import 'package:whats_clone/view/constants/strings.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  Assets.onboarding,
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
                    onPressed: () {},
                    child: Text(
                      Strings.termsAndPrivacyPolicy,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: FilledButton(
                            onPressed: () => context.goNamed(RouteName.login),
                            child: const Text(
                              Strings.startMessaging,
                              // style: AppTextStyles.subHeadline2
                              //     .copyWith(color: AppColors.offWhite),
                            )))
                  ],
                ),
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
