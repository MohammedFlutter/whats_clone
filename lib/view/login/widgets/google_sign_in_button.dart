import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/view/constants/strings.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  void _handleSignIn(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Center(
      child: authState.isLoading
          ? const CircularProgressIndicator()
          : Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => _handleSignIn(context, ref),
                    child: const Text(Strings.signInWithGoogle),
                  ),
                ),
              ],
            ),
    );
  }
}
