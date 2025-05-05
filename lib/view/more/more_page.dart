import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/state/providers/theme_provider.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/constants/uris.dart';
import 'package:whats_clone/view/more/widgets/more_card.dart';
import 'package:whats_clone/view/widgets/app_alert_dialog.dart';
import 'package:whats_clone/view/widgets/app_list_tile.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider).profile;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.more)),
      body: profile == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppListTile(
                      onPressed: () {
                        context.pushNamed(
                          RouteName.updateProfile,
                          extra: profile,
                        );
                      },
                      title: profile.name,
                      subtitle: profile.phoneNumber,
                      avatarUrl: profile.avatarUrl,
                      trailing: const Icon(
                        Icons.edit,
                        size: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    buildSystemModeCard(ref),
                    buildLightDarkCard(ref),
                    buildPrivacyCard(),
                    buildLogoutCard(context, ref),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildSystemModeCard(WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MoreCard(
      icon: Icons.settings_brightness,
      title: themeMode == ThemeMode.system
          ? 'System Mode: ON'
          : 'System Mode: OFF',
      onPressed: () => ref.read(themeProvider.notifier).toggleSystemMode(),
    );
  }

  Widget buildPrivacyCard() {
    return MoreCard(
      icon: Icons.privacy_tip_outlined,
      title: Strings.privacy,
      onPressed: () async => launchUrl(Uri.parse(Uris.privacy)),
    );
  }

  Widget buildLightDarkCard(WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MoreCard(
      icon:
          themeMode == ThemeMode.dark ? Icons.nightlight_round : Icons.wb_sunny,
      title: themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
      onPressed: themeMode == ThemeMode.system
          ? null
          : () => ref.read(themeProvider.notifier).toggleLightDarkMode(),
    );
  }

  MoreCard buildLogoutCard(BuildContext context, WidgetRef ref) {
    return MoreCard(
        icon: Icons.logout,
        title: Strings.logout,
        onPressed: () async {
          AppAlertDialog.showDialog(
              context: context,
              title: Strings.logout,
              content: Strings.logoutDescription,
              confirmText: 'Logout',
              onConfirm: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.goNamed(RouteName.login);
                }
              },
              onCancel: context.pop);
        });
  }
}
