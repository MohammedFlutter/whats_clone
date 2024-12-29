import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/profile/widgets/FormContent.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  const CreateProfilePage({super.key});

  @override
  ConsumerState<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  String _dialCode = '+20';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _listenToProfileChanges,
    );
  }

  void _listenToProfileChanges() {
    ref.listen(
      profileNotifierProvider,
      (previous, next) {
        if (next.status == ProfileStatus.created) {
          context.goNamed(RouteName.home);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text(Strings.createProfile)),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: FormContent(
                nameController: _nameController,
                bioController: _bioController,
                phoneController: _phoneController,
                onDialCodeChanged: (code) => _dialCode = code,
                onCreate: _handleSave,
                dialCode: _dialCode,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authProvider);
    final profile = Profile(
      userId: user.userId!,
      name: _nameController.text,
      email: user.email,
      phoneNumber: '$_dialCode${_phoneController.text}',
      bio: _bioController.text,
      createdAt: DateTime.now(),
    );

    await ref.read(profileNotifierProvider.notifier).createProfile(profile);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
