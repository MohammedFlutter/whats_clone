import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/auth/models/auth_result.dart';
import 'package:whats_clone/state/auth/models/auth_state.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';
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
          _handleSuccessfulLogin(context, ref, authState);
        } else if (authState.authResult == AuthResult.failed) {
          AppSnakeBar.showErrorSnakeBar(context, Strings.authenticationFailed);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.signIn),
      ),
      body: const LoginPageBody(),
    );
  }

  Future<void> _handleSuccessfulLogin(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
  ) async {
    final userId = authState.userId!;
    await ref
        .read(profileNotifierProvider.notifier)
        .loadProfile(userId: userId);

    if (!context.mounted) return;

    final profileStatus = ref.read(profileNotifierProvider).status;
    final routeName = profileStatus == ProfileStatus.noProfile
        ? RouteName.createProfile
        : RouteName.chats;

    context.goNamed(routeName);
  }
}

class LoginPageBody extends ConsumerWidget {
  const LoginPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authEvent = ref.read(authProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const LoginHeader(),
            AppFillButton(
                text: Strings.signInWithGoogle,
                onPressed: authEvent.signInWithGoogle),
          ],
        ),
      ),
    );
  }
}
