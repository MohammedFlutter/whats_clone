import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/state/splash/provider/splash_provider.dart';
import 'package:whats_clone/view/constants/images.dart';
import 'package:whats_clone/view/constants/strings.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Run initialization on first build
    Future(() async {
      final route = await ref.read(splashProvider.notifier).initialize();
      if (context.mounted) {
        context.goNamed(route);
      }
    });

    // Determine logo based on theme
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(isLight ? Images.logoLight : Images.logoDark),
                const SizedBox(width: 8.0),
                Text(
                  Strings.appTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            if (ref.watch(splashProvider).isLoading)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
