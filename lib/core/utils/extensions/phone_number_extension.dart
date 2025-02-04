import 'package:dlibphonenumber/dlibphonenumber.dart';

extension PhoneNumberExtension on PhoneNumber{
  String get formattedPhoneNumber {
    return '$countryCode$nationalNumber';
  }
}

extension PhoneNumberUtilExtension on PhoneNumberUtil{
  PhoneNumber? tryParsePhoneNumber(
      {String? numberToParse, String? defaultRegion}) {
    try {
      return parse(numberToParse, defaultRegion);
    } catch (e) {
      return null;
    }
  }

}