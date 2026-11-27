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
  String get codeInvalidFormat => 'Kod 7 veya 10 karakter olmalı ve sadece harf ve rakam içermeli.';

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
  String get errorTooManyAttempts => 'Çok fazla hatalı deneme yaptınız. Lütfen bir saat sonra tekrar deneyin.';

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
  String get pendingBody => 'Düğün sahibi katılımınızı onayladığında içeri girebilirsiniz.';

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

  @override
  String get announcements => 'Duyurular';

  @override
  String get noAnnouncements => 'Henüz duyuru yok.';

  @override
  String get writeAnnouncement => 'Duyuru yaz';

  @override
  String get announcementHint => 'Davetlilere iletmek istediğiniz mesaj';

  @override
  String get send => 'Gönder';

  @override
  String get program => 'Program';

  @override
  String get noEvents => 'Henüz etkinlik eklenmedi.';

  @override
  String get addEvent => 'Etkinlik ekle';

  @override
  String get editEvent => 'Etkinliği düzenle';

  @override
  String get eventName => 'Etkinlik adı';

  @override
  String get eventNameHint => 'Örn. Kına, Nikâh, Düğün';

  @override
  String get venueName => 'Mekân';

  @override
  String get address => 'Adres (isteğe bağlı)';

  @override
  String get mapUrl => 'Harita bağlantısı (isteğe bağlı)';

  @override
  String get mapUrlInvalid => 'Bağlantı https:// ile başlamalı.';

  @override
  String get pickDate => 'Tarih';

  @override
  String get pickTime => 'Saat';

  @override
  String get save => 'Kaydet';

  @override
  String get openMap => 'Haritada aç';

  @override
  String get fieldRequired => 'Bu alan gerekli.';

  @override
  String get rsvpTitle => 'Katılım durumunuz';

  @override
  String get rsvpYes => 'Katılıyorum';

  @override
  String get rsvpNo => 'Katılamıyorum';

  @override
  String get rsvpMaybe => 'Belki';

  @override
  String get rsvpHeadcount => 'Kaç kişi geleceksiniz?';

  @override
  String get rsvpNote => 'Not (isteğe bağlı)';

  @override
  String get rsvpSaved => 'Yanıtınız kaydedildi.';

  @override
  String get guests => 'Davetliler';

  @override
  String get pendingApprovals => 'Onay bekleyenler';

  @override
  String get approve => 'Onayla';

  @override
  String get reject => 'Reddet';

  @override
  String get removeGuest => 'Düğünden çıkar';

  @override
  String removeGuestConfirm(String name) {
    return '$name düğünden çıkarılsın mı? Bu kişi düğünün içeriğini artık göremeyecek.';
  }

  @override
  String get guestCode => 'Davetli kodu';

  @override
  String get rotateCode => 'Kodu yenile';

  @override
  String get rotateCodeConfirm => 'Yeni kod oluşturulunca eski kod çalışmaz. Daha önce katılanlar etkilenmez.';

  @override
  String get shareCodeHint => 'Bu kodu davetiye ve masalara koyun. Davetliler uygulamada \"Kodum var\" ile girer.';

  @override
  String rsvpSummary(int yes, int no, int maybe, int none) {
    return '$yes kişi geliyor · $no gelemiyor · $maybe belki · $none yanıtsız';
  }

  @override
  String get moduleClosedEdit => 'Bu bölümün düzenleme süresi doldu.';

  @override
  String get saveFailed => 'Kaydedilemedi. Bölüm kapanmış olabilir.';
}
