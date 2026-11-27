import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('tr')];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Murevet'**
  String get appName;

  /// No description provided for @gateTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sadece davetlilere özel'**
  String get gateTitle;

  /// No description provided for @gateBody.
  ///
  /// In tr, this message translates to:
  /// **'Murevet, her düğün için ayrı ve kapalı bir alan. İçeri girmek için düğün sahibinin size verdiği kod gerekir.'**
  String get gateBody;

  /// No description provided for @gateHaveCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodum var'**
  String get gateHaveCode;

  /// No description provided for @gateNoCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodunuz yoksa düğün sahibinden isteyin.'**
  String get gateNoCode;

  /// No description provided for @privacyPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik politikası'**
  String get privacyPolicy;

  /// No description provided for @terms.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım koşulları'**
  String get terms;

  /// No description provided for @kvkkNotice.
  ///
  /// In tr, this message translates to:
  /// **'KVKK aydınlatma metni'**
  String get kvkkNotice;

  /// No description provided for @codeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Düğün kodunu girin'**
  String get codeTitle;

  /// No description provided for @codeHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn. ABC D234'**
  String get codeHint;

  /// No description provided for @codeInvalidFormat.
  ///
  /// In tr, this message translates to:
  /// **'Kod 7 veya 10 karakter olmalı ve sadece harf ve rakam içermeli.'**
  String get codeInvalidFormat;

  /// No description provided for @nameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Adınız soyadınız'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In tr, this message translates to:
  /// **'Diğer davetliler sizi bu adla görür'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen adınızı yazın.'**
  String get nameRequired;

  /// No description provided for @join.
  ///
  /// In tr, this message translates to:
  /// **'Katıl'**
  String get join;

  /// No description provided for @signInRequired.
  ///
  /// In tr, this message translates to:
  /// **'Katılmak için Google hesabınızla giriş yapın.'**
  String get signInRequired;

  /// No description provided for @signInWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş yap'**
  String get signInWithGoogle;

  /// No description provided for @errorCodeNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu kod geçersiz veya artık kullanılmıyor.'**
  String get errorCodeNotFound;

  /// No description provided for @errorTooManyAttempts.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla hatalı deneme yaptınız. Lütfen bir saat sonra tekrar deneyin.'**
  String get errorTooManyAttempts;

  /// No description provided for @errorWeddingClosed.
  ///
  /// In tr, this message translates to:
  /// **'Bu düğün şu an erişime kapalı.'**
  String get errorWeddingClosed;

  /// No description provided for @errorRemoved.
  ///
  /// In tr, this message translates to:
  /// **'Bu düğüne erişiminiz kaldırılmış.'**
  String get errorRemoved;

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun oluştu. Lütfen tekrar deneyin.'**
  String get errorGeneric;

  /// No description provided for @myWeddings.
  ///
  /// In tr, this message translates to:
  /// **'Düğünlerim'**
  String get myWeddings;

  /// No description provided for @joinAnother.
  ///
  /// In tr, this message translates to:
  /// **'Başka bir düğüne katıl'**
  String get joinAnother;

  /// No description provided for @pendingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekleniyor'**
  String get pendingTitle;

  /// No description provided for @pendingBody.
  ///
  /// In tr, this message translates to:
  /// **'Düğün sahibi katılımınızı onayladığında içeri girebilirsiniz.'**
  String get pendingBody;

  /// No description provided for @roleOwner.
  ///
  /// In tr, this message translates to:
  /// **'Sahip'**
  String get roleOwner;

  /// No description provided for @roleGuest.
  ///
  /// In tr, this message translates to:
  /// **'Davetli'**
  String get roleGuest;

  /// No description provided for @tabProgram.
  ///
  /// In tr, this message translates to:
  /// **'Program'**
  String get tabProgram;

  /// No description provided for @tabMemories.
  ///
  /// In tr, this message translates to:
  /// **'Anılar'**
  String get tabMemories;

  /// No description provided for @moduleClosed.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölüm şu an kapalı.'**
  String get moduleClosed;

  /// No description provided for @comingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölüm yakında burada.'**
  String get comingSoon;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @signOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabımı sil'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız, yüklediğiniz tüm fotoğraf ve videolar, yorumlarınız ve LCV yanıtlarınız kalıcı olarak silinecek. Bu işlem geri alınamaz.'**
  String get deleteAccountConfirm;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @accountDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız silindi.'**
  String get accountDeleted;

  /// No description provided for @announcements.
  ///
  /// In tr, this message translates to:
  /// **'Duyurular'**
  String get announcements;

  /// No description provided for @noAnnouncements.
  ///
  /// In tr, this message translates to:
  /// **'Henüz duyuru yok.'**
  String get noAnnouncements;

  /// No description provided for @writeAnnouncement.
  ///
  /// In tr, this message translates to:
  /// **'Duyuru yaz'**
  String get writeAnnouncement;

  /// No description provided for @announcementHint.
  ///
  /// In tr, this message translates to:
  /// **'Davetlilere iletmek istediğiniz mesaj'**
  String get announcementHint;

  /// No description provided for @send.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get send;

  /// No description provided for @program.
  ///
  /// In tr, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @noEvents.
  ///
  /// In tr, this message translates to:
  /// **'Henüz etkinlik eklenmedi.'**
  String get noEvents;

  /// No description provided for @addEvent.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik ekle'**
  String get addEvent;

  /// No description provided for @editEvent.
  ///
  /// In tr, this message translates to:
  /// **'Etkinliği düzenle'**
  String get editEvent;

  /// No description provided for @eventName.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik adı'**
  String get eventName;

  /// No description provided for @eventNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Kına, Nikâh, Düğün'**
  String get eventNameHint;

  /// No description provided for @venueName.
  ///
  /// In tr, this message translates to:
  /// **'Mekân'**
  String get venueName;

  /// No description provided for @address.
  ///
  /// In tr, this message translates to:
  /// **'Adres (isteğe bağlı)'**
  String get address;

  /// No description provided for @mapUrl.
  ///
  /// In tr, this message translates to:
  /// **'Harita bağlantısı (isteğe bağlı)'**
  String get mapUrl;

  /// No description provided for @mapUrlInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı https:// ile başlamalı.'**
  String get mapUrlInvalid;

  /// No description provided for @pickDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get pickDate;

  /// No description provided for @pickTime.
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get pickTime;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @openMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritada aç'**
  String get openMap;

  /// No description provided for @fieldRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan gerekli.'**
  String get fieldRequired;

  /// No description provided for @rsvpTitle.
  ///
  /// In tr, this message translates to:
  /// **'Katılım durumunuz'**
  String get rsvpTitle;

  /// No description provided for @rsvpYes.
  ///
  /// In tr, this message translates to:
  /// **'Katılıyorum'**
  String get rsvpYes;

  /// No description provided for @rsvpNo.
  ///
  /// In tr, this message translates to:
  /// **'Katılamıyorum'**
  String get rsvpNo;

  /// No description provided for @rsvpMaybe.
  ///
  /// In tr, this message translates to:
  /// **'Belki'**
  String get rsvpMaybe;

  /// No description provided for @rsvpHeadcount.
  ///
  /// In tr, this message translates to:
  /// **'Kaç kişi geleceksiniz?'**
  String get rsvpHeadcount;

  /// No description provided for @rsvpNote.
  ///
  /// In tr, this message translates to:
  /// **'Not (isteğe bağlı)'**
  String get rsvpNote;

  /// No description provided for @rsvpSaved.
  ///
  /// In tr, this message translates to:
  /// **'Yanıtınız kaydedildi.'**
  String get rsvpSaved;

  /// No description provided for @guests.
  ///
  /// In tr, this message translates to:
  /// **'Davetliler'**
  String get guests;

  /// No description provided for @pendingApprovals.
  ///
  /// In tr, this message translates to:
  /// **'Onay bekleyenler'**
  String get pendingApprovals;

  /// No description provided for @approve.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In tr, this message translates to:
  /// **'Reddet'**
  String get reject;

  /// No description provided for @removeGuest.
  ///
  /// In tr, this message translates to:
  /// **'Düğünden çıkar'**
  String get removeGuest;

  /// No description provided for @removeGuestConfirm.
  ///
  /// In tr, this message translates to:
  /// **'{name} düğünden çıkarılsın mı? Bu kişi düğünün içeriğini artık göremeyecek.'**
  String removeGuestConfirm(String name);

  /// No description provided for @guestCode.
  ///
  /// In tr, this message translates to:
  /// **'Davetli kodu'**
  String get guestCode;

  /// No description provided for @rotateCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodu yenile'**
  String get rotateCode;

  /// No description provided for @rotateCodeConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kod oluşturulunca eski kod çalışmaz. Daha önce katılanlar etkilenmez.'**
  String get rotateCodeConfirm;

  /// No description provided for @shareCodeHint.
  ///
  /// In tr, this message translates to:
  /// **'Bu kodu davetiye ve masalara koyun. Davetliler uygulamada \"Kodum var\" ile girer.'**
  String get shareCodeHint;

  /// No description provided for @rsvpSummary.
  ///
  /// In tr, this message translates to:
  /// **'{yes} kişi geliyor · {no} gelemiyor · {maybe} belki · {none} yanıtsız'**
  String rsvpSummary(int yes, int no, int maybe, int none);

  /// No description provided for @moduleClosedEdit.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölümün düzenleme süresi doldu.'**
  String get moduleClosedEdit;

  /// No description provided for @saveFailed.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilemedi. Bölüm kapanmış olabilir.'**
  String get saveFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
