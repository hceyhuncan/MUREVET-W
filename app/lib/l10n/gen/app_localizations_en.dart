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
  String get codeInvalidFormat => 'The code must be 7 or 10 letters and digits.';

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
  String get errorTooManyAttempts => 'Too many wrong attempts. Please try again in an hour.';

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

  @override
  String get announcements => 'Announcements';

  @override
  String get noAnnouncements => 'No announcements yet.';

  @override
  String get writeAnnouncement => 'Write an announcement';

  @override
  String get announcementHint => 'Message for your guests';

  @override
  String get send => 'Send';

  @override
  String get program => 'Program';

  @override
  String get noEvents => 'No events yet.';

  @override
  String get addEvent => 'Add event';

  @override
  String get editEvent => 'Edit event';

  @override
  String get eventName => 'Event name';

  @override
  String get eventNameHint => 'e.g. Henna night, Ceremony';

  @override
  String get venueName => 'Venue';

  @override
  String get address => 'Address (optional)';

  @override
  String get mapUrl => 'Map link (optional)';

  @override
  String get mapUrlInvalid => 'The link must start with https://.';

  @override
  String get pickDate => 'Date';

  @override
  String get pickTime => 'Time';

  @override
  String get save => 'Save';

  @override
  String get openMap => 'Open map';

  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get rsvpTitle => 'Your RSVP';

  @override
  String get rsvpYes => 'Attending';

  @override
  String get rsvpNo => 'Can\'t attend';

  @override
  String get rsvpMaybe => 'Maybe';

  @override
  String get rsvpHeadcount => 'How many people?';

  @override
  String get rsvpNote => 'Note (optional)';

  @override
  String get rsvpSaved => 'Your answer was saved.';

  @override
  String get guests => 'Guests';

  @override
  String get pendingApprovals => 'Waiting for approval';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get removeGuest => 'Remove from wedding';

  @override
  String removeGuestConfirm(String name) {
    return 'Remove $name from the wedding? They will no longer see its content.';
  }

  @override
  String get guestCode => 'Guest code';

  @override
  String get rotateCode => 'New code';

  @override
  String get rotateCodeConfirm =>
      'After a new code is created the old one stops working. Guests who already joined are not affected.';

  @override
  String get shareCodeHint => 'Put this code on invitations and tables. Guests enter it via \"I have a code\".';

  @override
  String rsvpSummary(int yes, int no, int maybe, int none) {
    return '$yes attending · $no not attending · $maybe maybe · $none no answer';
  }

  @override
  String get moduleClosedEdit => 'The editing period for this section has ended.';

  @override
  String get saveFailed => 'Could not save. The section may be closed.';
}
