import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/profile/widgets/phone_number_input.dart';
import 'package:whats_clone/view/profile/widgets/profile_picture.dart';
import 'package:whats_clone/view/widgets/app_fill_button.dart';

class FormContent extends StatelessWidget {
  const FormContent(
      {super.key,
      required this.nameController,
      required this.bioController,
      required this.phoneController,
      required this.onDialCodeChanged,
      required this.onCreateProfile,
      required this.dialCode,
      required this.onPickImage});

  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController phoneController;
  final void Function(String code) onDialCodeChanged;
  final String dialCode;
  final VoidCallback onCreateProfile;
  final VoidCallback onPickImage;

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
            hintText: Strings.name,
            validator: _validateName,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: bioController,
            hintText: Strings.bio,
          ),
          const SizedBox(height: 12),
          PhoneNumberInput(
            phoneController: phoneController,
            onDialCodeChanged: onDialCodeChanged,
            phoneNumberValidator: _phoneNumberValidator,
          ),
          const SizedBox(height: 12),
          const Spacer(),
          AppFillButton(text: Strings.save, onPressed: onCreateProfile),
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.nameIsRequired;
    }
    return null;
  }

  String? _phoneNumberValidator(String? phone) {
    if (phone == null || phone.isEmpty) {
      return Strings.phoneNumberIsRequired;
    }
    String modifyDialCode;

    // convert +#### to +#-###
    if (dialCode.length == 5) {
      modifyDialCode = '${dialCode.substring(0, 2)}-${dialCode.substring(2)}';
    } else {
      modifyDialCode = dialCode;
    }
    final country = CountryUtils.getCountryByDialCode(modifyDialCode);

    /// country ==null,that's mean [CountryUtils] Package dont
    /// support this country validation
    if (country == null && (phone.length < 8 || phone.length > 15)) {
      return Strings.invalidPhoneNumber;
    }
    if (country != null &&
        !CountryUtils.validatePhoneNumber(phone, modifyDialCode)) {
      return Strings.invalidPhoneNumber;
    }

    return null;
  }
}
