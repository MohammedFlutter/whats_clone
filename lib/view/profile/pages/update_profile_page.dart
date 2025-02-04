import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/image_upload/model/upload_state.dart';
import 'package:whats_clone/state/image_upload/provider/image_picker_provider.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/profile/widgets/form_content.dart';
import 'package:whats_clone/view/widgets/app_snake_bar.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({required this.profile, super.key});

  final Profile profile;

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _phoneController;

  late String _dialCode;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController(text: widget.profile.name);
    _bioController = TextEditingController(text: widget.profile.bio);

    final phoneNumber =
        PhoneNumberUtil.instance.parse('+${widget.profile.phoneNumber}', null);
    _phoneController =
        TextEditingController(text: phoneNumber.nationalNumber.toString());

    _dialCode = '+${phoneNumber.countryCode.toString()}';
  }

  void _listenToProfileChanges() {
    ref.listen(
      profileNotifierProvider,
      (_, state) {
        if (state.status == ProfileStatus.updated) {
          context.pop();
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
            Strings.editProfile,
          ),
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
                onSave: _handleSave,
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

    final avatarUrl =
        await ref.read(imagePickerProvider.notifier).uploadImage() ??
            widget.profile.avatarUrl;

    final regionCode = PhoneNumberUtil.instance
        .getRegionCodeForCountryCode(int.parse(_dialCode));
    final phone =
        PhoneNumberUtil.instance.parse(_phoneController.text, regionCode);

    final profileState = ref.read(imagePickerProvider);
    // if false, the image is  uploaded successfully or not selected
    if (!(profileState.file == null ||
        ref.read(imagePickerProvider).status == UploadStatus.success)) return;
    final user = ref.read(authProvider);
    final profile = widget.profile.copyWith(
      avatarUrl: avatarUrl,
      name: _nameController.text,
      email: user.email,
      phoneNumber: '${_dialCode.substring(1)}${phone.nationalNumber}',
      bio: _bioController.text,
    );

    await ref.read(profileNotifierProvider.notifier).updateProfile(profile);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
