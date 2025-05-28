import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/utils/extensions/localization_extension.dart';
import 'package:whats_clone/state/auth/models/auth_result.dart';
import 'package:whats_clone/state/auth/models/auth_state.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/login/widgets/login_header.dart';
import 'package:whats_clone/view/widgets/app_fill_button.dart';
import 'package:whats_clone/view/widgets/app_snake_bar.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(
      authProvider,
      (_, authState) {
        if (authState.authResult == AuthResult.success) {
          try {
            //todo should refactor
            ref.read(authProvider.notifier).handleSuccessfulLogin().then(
              (value) {
                if (context.mounted) context.goNamed(value);
              },
            );
          } catch (e) {
            AppSnakeBar.showErrorSnakeBar(
                context: context,
                message: context.l10n.errorLoadingProfile,
                onRetry: ref.read(authProvider.notifier).handleSuccessfulLogin);
          }
        } else if (authState.authResult == AuthResult.failed) {
          AppSnakeBar.showErrorSnakeBar(
              context: context, message: context.l10n.authenticationFailed);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.signIn),
      ),
      body: const LoginPageBody(),
    );
  }

// Future<void> _handleSuccessfulLogin(
//   BuildContext context,
//   WidgetRef ref,
//   AuthState authState,
// ) async {
//   final userId = authState.userId!;
//   await ref
//       .read(profileNotifierProvider.notifier)
//       .loadProfile(userId: userId);
//
//   if (!context.mounted) return;
//
//   final profileStatus = ref.read(profileNotifierProvider).status;
//
//   final String routeName;
//   if (profileStatus == ProfileStatus.loaded) {
//     routeName = RouteName.chats;
//     await ref.read(appInitializerProvider.notifier).initialize();
//   } else if (profileStatus == ProfileStatus.noProfile) {
//     routeName = RouteName.createProfile;
//   } else if (profileStatus == ProfileStatus.error) {
//     AppSnakeBar.showErrorSnakeBar(
//         context: context,
//         message: Strings.errorLoadingProfile,
//         onRetry: () => _handleSuccessfulLogin(context, ref, authState));
//     return;
//   } else {
//     log.e('Unknown profile status: $profileStatus');
//     return;
//   }
//
//   context.goNamed(routeName);
// }
}

class LoginPageBody extends ConsumerWidget {
  const LoginPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authEvent = ref.read(authProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const LoginHeader(),
          AppFillButton(
            text: context.l10n.signInWithGoogle,
            onPressed: authEvent.signInWithGoogle,
          ),
        ],
      ),
    );
  }
}
