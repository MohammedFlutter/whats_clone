import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/auth/models/auth_result.dart';
import 'package:whats_clone/state/auth/models/auth_state.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/login/widgets/login_header.dart';
import 'package:whats_clone/view/login/widgets/google_sign_in_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.authResult == AuthResult.success) {
        context.goNamed(RouteName.home);
      } else if (next.authResult == AuthResult.failed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication Failed: ')),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.signIn),
      ),
      body: const LoginPageBody(),
    );
  }
}

class LoginPageBody extends ConsumerWidget {
  const LoginPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LoginHeader(),
          GoogleSignInButton(),
        ],
      ),
    );
  }
}
