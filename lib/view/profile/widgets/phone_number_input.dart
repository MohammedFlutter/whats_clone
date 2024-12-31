import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/profile/widgets/country_code_picker.dart';

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    super.key,
    required this.phoneController,
    required this.onDialCodeChanged,
    this.phoneNumberValidator,
  });

  final TextEditingController phoneController;
  final Function(String) onDialCodeChanged;
  final String? Function(String?)? phoneNumberValidator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CountryCodePicker(onChanged: onDialCodeChanged),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(hintText: Strings.phone),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: phoneNumberValidator,
          ),
        ),
      ],
    );
  }
}
