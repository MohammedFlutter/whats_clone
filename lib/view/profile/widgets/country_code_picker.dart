import 'package:country_code_picker_plus/country_code_picker_plus.dart'
    as package;
import 'package:flutter/material.dart';
import 'package:whats_clone/core/utils/extensions/localization_extension.dart';
import 'package:whats_clone/view/constants/strings.dart';

class CountryCodePicker extends StatelessWidget {
  const CountryCodePicker({
    super.key,
    required this.onChanged,
    this.initialSelection,
  });

  final void Function(String) onChanged;
  final String? initialSelection;

  @override
  Widget build(BuildContext context) {
    return package.CountryCodePicker(
      initialSelection: initialSelection ?? 'EG',
      onChanged: (country) => onChanged(country.dialCode),
      barrierColor: Colors.grey.withOpacity(.1),
      dialogBackgroundColor: Theme.of(context).colorScheme.surface,
      shadowColor: Colors.transparent,
      elevation: 0,
      padding: const EdgeInsets.all(8),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      builder: (country) => _CountryCodeButton(country: country),
      showDropDownButton: false,
      showOnlyCountryWhenClosed: false,
      searchDecoration:  InputDecoration(hintText: context.l10n.searchCountry),
    );
  }
}

class _CountryCodeButton extends StatelessWidget {
  final package.Country? country;

  const _CountryCodeButton({required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          _CountryFlag(flagUri: country?.flagUri ?? ''),
          const SizedBox(width: 8),
          Text(
            country?.dialCode ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}

class _CountryFlag extends StatelessWidget {
  final String flagUri;

  const _CountryFlag({required this.flagUri});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          flagUri,
          package: 'country_code_picker_plus',
          width: 18,
          height: 18,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
