import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/image_upload/model/upload_state.dart';
import 'package:whats_clone/state/image_upload/provider/image_picker_provider.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/profile/widgets/form_content.dart';
import 'package:whats_clone/view/widgets/app_snake_bar.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  const CreateProfilePage({super.key});

  @override
  ConsumerState<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _phoneController;

  String _dialCode = '+20';

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
  }

  void _listenToProfileChanges() {
    ref.listen(
      profileNotifierProvider,
      (_, state) {
        if (state.status == ProfileStatus.created) {
          context.goNamed(RouteName.contacts);
        }
        if (state.status == ProfileStatus.error) {
          AppSnakeBar.showErrorSnakeBar(
              context: context, message: state.errorMessage!);
        }
      },
    );
    ref.listen(
      imagePickerProvider,
      (_, state) {
        if (state.status == UploadStatus.error) {
          AppSnakeBar.showErrorSnakeBar(
              context: context, message: state.errorMessage!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _listenToProfileChanges();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.createProfile,
          ),
          leadingWidth: 0,
          leading: const SizedBox(),
        ),
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
                onCreateProfile: _handleSave,
                dialCode: _dialCode,
                onPickImage: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final avatarUrl =
        await ref.read(imagePickerProvider.notifier).uploadImage();
    final phone = PhoneNumberUtil.instance.parse('$_dialCode${_phoneController.text}', _dialCode);

    final profileState = ref.read(imagePickerProvider);
    // if false, the image is  uploaded successfully or not selected
    if (!(profileState.file == null ||
        ref.read(imagePickerProvider).status == UploadStatus.success)) return;
    final user = ref.read(authProvider);
    final profile = Profile(
      userId: user.userId!,
      avatarUrl: avatarUrl,
      name: _nameController.text,
      email: user.email,
      phoneNumber: '${_dialCode.substring(1)}${phone.nationalNumber}',
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
