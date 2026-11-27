import '../../domain/models/program.dart';

/// Modül A: Katılımcı Organizasyonu. Yazma yetkisi ve süreler sunucu kurallarında kontrol edilir.
abstract class ProgramRepository {
  Stream<List<WeddingEvent>> watchEvents(String weddingId);
  Future<void> saveEvent(String weddingId, WeddingEvent event, {bool isNew = false});
  Future<void> deleteEvent(String weddingId, String eventId);

  Stream<List<Announcement>> watchAnnouncements(String weddingId);
  Future<void> postAnnouncement(String weddingId, String authorUid, String text);
  Future<void> deleteAnnouncement(String weddingId, String id);

  Stream<Rsvp?> watchMyRsvp(String weddingId, String uid);
  Future<void> saveRsvp(String weddingId, String uid, Rsvp rsvp);

  // Sahip
  Stream<List<Guest>> watchGuests(String weddingId);
  Future<void> setGuestStatus(String weddingId, String uid, {required bool active});
  Stream<String?> watchGuestCode(String weddingId);
  Future<String> rotateGuestCode(String weddingId);
}
