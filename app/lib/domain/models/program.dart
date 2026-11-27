enum RsvpAnswer { yes, no, maybe }

class WeddingEvent {
  const WeddingEvent({
    required this.id,
    required this.name,
    required this.startAt,
    required this.venueName,
    this.address,
    this.mapUrl,
  });

  final String id;
  final String name;
  final DateTime startAt;
  final String venueName;
  final String? address;
  final String? mapUrl;
}

class Announcement {
  const Announcement({required this.id, required this.text, required this.createdAt});
  final String id;
  final String text;
  final DateTime createdAt;
}

class Rsvp {
  const Rsvp({required this.answer, required this.headcount, this.note});
  final RsvpAnswer answer;
  final int headcount;
  final String? note;

  static RsvpAnswer? parse(Object? v) => switch (v) {
    'yes' => RsvpAnswer.yes,
    'no' => RsvpAnswer.no,
    'maybe' => RsvpAnswer.maybe,
    _ => null,
  };
}

/// Sahibin gördüğü davetli satırı.
class Guest {
  const Guest({
    required this.uid,
    required this.displayName,
    required this.isPending,
    required this.isOwner,
    this.rsvp,
  });
  final String uid;
  final String displayName;
  final bool isPending;
  final bool isOwner;
  final Rsvp? rsvp;
}

class RsvpSummary {
  const RsvpSummary({required this.yesPeople, required this.noCount, required this.maybeCount, required this.noAnswer});
  final int yesPeople;
  final int noCount;
  final int maybeCount;
  final int noAnswer;

  static RsvpSummary of(List<Guest> guests) {
    var yes = 0, no = 0, maybe = 0, none = 0;
    for (final g in guests.where((g) => !g.isPending)) {
      switch (g.rsvp?.answer) {
        case RsvpAnswer.yes:
          yes += g.rsvp!.headcount;
        case RsvpAnswer.no:
          no++;
        case RsvpAnswer.maybe:
          maybe++;
        case null:
          none++;
      }
    }
    return RsvpSummary(yesPeople: yes, noCount: no, maybeCount: maybe, noAnswer: none);
  }
}
