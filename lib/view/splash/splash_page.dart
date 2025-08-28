import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/utils/extensions/localization_extension.dart';
import 'package:whats_clone/state/splash/provider/splash_provider.dart';
import 'package:whats_clone/view/constants/images.dart';

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
      (timeStamp) async {
        final route = await ref.read(splashProvider.notifier).initialize();
        if (mounted) {
          context.goNamed(route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Run initialization on first build
    // Future(() async {
    //   final route = await ref.read(splashProvider.notifier).initialize();
    //   if (context.mounted) {
    //     context.goNamed(route);
    //   }
    // });

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
                  context.l10n.appTitle,
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
