// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Murevet';

  @override
  String get gateTitle => 'For invited guests only';

  @override
  String get gateBody =>
      'Murevet is a separate, private space for each wedding. You need the code the hosts gave you to enter.';

  @override
  String get gateHaveCode => 'I have a code';

  @override
  String get gateNoCode => 'No code? Ask the hosts.';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get terms => 'Terms of use';

  @override
  String get kvkkNotice => 'Personal data notice';

  @override
  String get codeTitle => 'Enter the wedding code';

  @override
  String get codeHint => 'e.g. ABC D234';

  @override
  String get codeInvalidFormat =>
      'The code must be 7 or 10 letters and digits.';

  @override
  String get nameLabel => 'Your full name';

  @override
  String get nameHint => 'Other guests will see you by this name';

  @override
  String get nameRequired => 'Please enter your name.';

  @override
  String get join => 'Join';

  @override
  String get signInRequired => 'Sign in with your Google account to join.';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get errorCodeNotFound => 'This code is invalid or no longer in use.';

  @override
  String get errorTooManyAttempts =>
      'Too many wrong attempts. Please try again in an hour.';

  @override
  String get errorWeddingClosed => 'This wedding is currently closed.';

  @override
  String get errorRemoved => 'Your access to this wedding was removed.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get myWeddings => 'My weddings';

  @override
  String get joinAnother => 'Join another wedding';

  @override
  String get pendingTitle => 'Waiting for approval';

  @override
  String get pendingBody => 'You can enter once the hosts approve you.';

  @override
  String get roleOwner => 'Host';

  @override
  String get roleGuest => 'Guest';

  @override
  String get tabProgram => 'Program';

  @override
  String get tabMemories => 'Memories';

  @override
  String get moduleClosed => 'This section is currently closed.';

  @override
  String get comingSoon => 'This section is coming soon.';

  @override
  String get settings => 'Settings';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountConfirm =>
      'Your account, all photos and videos you uploaded, your comments and RSVPs will be permanently deleted. This cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get accountDeleted => 'Your account was deleted.';
}
