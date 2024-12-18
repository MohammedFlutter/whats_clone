import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';
import 'package:whats_clone/view/constants/strings.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  const CreateProfilePage({super.key});

  @override
  ConsumerState<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _boiController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(
      profileNotifierProvider,
      (previous, next) {
        if (next.status == ProfileStatus.created) {
          context.goNamed(RouteName.home);
        }
        // next.whenOrNull(success: );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.createProfile),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 46),
            const CircleAvatar(
              radius: 100,
              child: Icon(Icons.person_outline_rounded),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: Strings.name),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _boiController,
              decoration: const InputDecoration(hintText: Strings.bio),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(hintText: Strings.phone),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: FilledButton(
                      onPressed: () => _createProfile(ref),
                      child: const Text(Strings.save)))
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _createProfile(
    WidgetRef ref,
  ) async {
    final user = ref.watch(authProvider);
    final name = _nameController.text;
    final bio = _boiController.text;
    final phoneNumber = _phoneController.text;
    final profile = Profile(
        userId: user.userId!,
        name: name,
        email: user.email,
        phoneNumber: phoneNumber,
        bio: bio,
        createdAt: DateTime.now());
    await ref.read(profileNotifierProvider.notifier).createProfile(profile);
    final profileStatus = ref.read(profileNotifierProvider).status;
    if (mounted && profileStatus == ProfileStatus.created) {
      context.goNamed(RouteName.home);
    }
  }
}
