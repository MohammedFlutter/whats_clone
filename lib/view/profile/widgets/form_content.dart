import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/material.dart';
import 'package:whats_clone/core/utils/extensions/localization_extension.dart';
import 'package:whats_clone/core/utils/extensions/phone_number_extension.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/profile/widgets/phone_number_input.dart';
import 'package:whats_clone/view/profile/widgets/profile_picture.dart';
import 'package:whats_clone/view/widgets/app_fill_button.dart';

class FormContent extends StatelessWidget {
  const FormContent({
    super.key,
    required this.nameController,
    required this.bioController,
    required this.phoneController,
    required this.onDialCodeChanged,
    required this.onSave,
    required this.dialCode,
  });

  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController phoneController;
  final void Function(String code) onDialCodeChanged;
  final String dialCode;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 46),
          const ProfilePicture(),
          const SizedBox(height: 30),
          _buildTextField(
            controller: nameController,
            hintText: context.l10n.name,
            validator: (value) => validateName(context, value),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: bioController,
            hintText: context.l10n.bio,
          ),
          const SizedBox(height: 12),
          PhoneNumberInput(
            phoneController: phoneController,
            onDialCodeChanged: onDialCodeChanged,
            phoneNumberValidator: (value) => phoneNumberValidator(context, value, dialCode),
          ),
          const SizedBox(height: 12),
          const Spacer(),
          AppFillButton(text: context.l10n.save, onPressed: onSave),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      textInputAction: TextInputAction.next,
      validator: validator,
    );
  }

  String? validateName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.nameIsRequired;
    }
    return null;
  }

  String? phoneNumberValidator(BuildContext context, String? phone, String dialCode) {
    if (phone == null || phone.isEmpty) {
      return context.l10n.phoneNumberIsRequired;
    }

    final phoneNumberUtil = PhoneNumberUtil.instance;
    final regionCode =
    phoneNumberUtil.getRegionCodeForCountryCode(int.parse(dialCode));

    final phoneNumber = phoneNumberUtil.tryParsePhoneNumber(
      numberToParse: phone,
      defaultRegion: regionCode,
    );

    if (phoneNumber == null || !phoneNumberUtil.isValidNumber(phoneNumber)) {
      return context.l10n.invalidPhoneNumber;
    }

    return null;
  }
}
