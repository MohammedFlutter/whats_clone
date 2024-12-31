import 'package:flutter/foundation.dart' show immutable;

@immutable
class Strings {
  const Strings._();

  static const appTitle = 'Chat Me';

  //Onboarding Page
  static const onboardingTitle =
      'Connect easily with your family and friends over countries';
  static const termsAndPrivacyPolicy = 'Terms & Privacy Policy';
  static const startMessaging = 'Start Messaging';

  //Login Page
  static const signIn = 'Sign In';
  static const signInWithGoogle = 'Sign In with Google';
  static const authenticationFailed = 'Authentication Failed';
  static const loginTitle = 'Welcome back to $appTitle';
  static const loginDescription =
      'Sign in with your Google account to access all features and enjoy a seamless experience.';

  //Profile Page
  static const createProfile = 'Create Profile';
  static const editProfile = 'Edit Profile';
  static const name = 'Name';
  static const bio = 'Bio';
  static const phone = 'Phone Number';
  static const save = 'Save';
  static const searchCountry = 'Search country';
  static const nameIsRequired = 'Name is required';
  static const phoneNumberIsRequired = 'Phone number is required';
  static const invalidPhoneNumber = 'Invalid phone number';
  static const profilePhoto = 'Profile photo';
  static const camera = 'Camera';
  static const gallery = 'Gallery';
}
