// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Murevet';

  @override
  String get gateTitle => 'Sadece davetlilere özel';

  @override
  String get gateBody =>
      'Murevet, her düğün için ayrı ve kapalı bir alan. İçeri girmek için düğün sahibinin size verdiği kod gerekir.';

  @override
  String get gateHaveCode => 'Kodum var';

  @override
  String get gateNoCode => 'Kodunuz yoksa düğün sahibinden isteyin.';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get terms => 'Kullanım koşulları';

  @override
  String get kvkkNotice => 'KVKK aydınlatma metni';

  @override
  String get codeTitle => 'Düğün kodunu girin';

  @override
  String get codeHint => 'Örn. ABC D234';

  @override
  String get codeInvalidFormat =>
      'Kod 7 veya 10 karakter olmalı ve sadece harf ve rakam içermeli.';

  @override
  String get nameLabel => 'Adınız soyadınız';

  @override
  String get nameHint => 'Diğer davetliler sizi bu adla görür';

  @override
  String get nameRequired => 'Lütfen adınızı yazın.';

  @override
  String get join => 'Katıl';

  @override
  String get signInRequired => 'Katılmak için Google hesabınızla giriş yapın.';

  @override
  String get signInWithGoogle => 'Google ile giriş yap';

  @override
  String get errorCodeNotFound => 'Bu kod geçersiz veya artık kullanılmıyor.';

  @override
  String get errorTooManyAttempts =>
      'Çok fazla hatalı deneme yaptınız. Lütfen bir saat sonra tekrar deneyin.';

  @override
  String get errorWeddingClosed => 'Bu düğün şu an erişime kapalı.';

  @override
  String get errorRemoved => 'Bu düğüne erişiminiz kaldırılmış.';

  @override
  String get errorGeneric => 'Bir sorun oluştu. Lütfen tekrar deneyin.';

  @override
  String get myWeddings => 'Düğünlerim';

  @override
  String get joinAnother => 'Başka bir düğüne katıl';

  @override
  String get pendingTitle => 'Onay bekleniyor';

  @override
  String get pendingBody =>
      'Düğün sahibi katılımınızı onayladığında içeri girebilirsiniz.';

  @override
  String get roleOwner => 'Sahip';

  @override
  String get roleGuest => 'Davetli';

  @override
  String get tabProgram => 'Program';

  @override
  String get tabMemories => 'Anılar';

  @override
  String get moduleClosed => 'Bu bölüm şu an kapalı.';

  @override
  String get comingSoon => 'Bu bölüm yakında burada.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get deleteAccount => 'Hesabımı sil';

  @override
  String get deleteAccountConfirm =>
      'Hesabınız, yüklediğiniz tüm fotoğraf ve videolar, yorumlarınız ve LCV yanıtlarınız kalıcı olarak silinecek. Bu işlem geri alınamaz.';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get delete => 'Sil';

  @override
  String get accountDeleted => 'Hesabınız silindi.';
}
