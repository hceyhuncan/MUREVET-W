/// Kullanıcının bir düğündeki üyeliği ("Düğünlerim" listesi için).
enum MemberRole { owner, guest }

enum MemberStatus { active, pending, removed }

class Membership {
  const Membership({
    required this.weddingId,
    required this.title,
    required this.role,
    required this.status,
  });

  final String weddingId;
  final String title;
  final MemberRole role;
  final MemberStatus status;

  bool get isOwner => role == MemberRole.owner;
  bool get canEnter => status == MemberStatus.active;

  static MemberRole parseRole(Object? v) => v == 'owner' ? MemberRole.owner : MemberRole.guest;

  static MemberStatus parseStatus(Object? v) => switch (v) {
        'active' => MemberStatus.active,
        'removed' => MemberStatus.removed,
        _ => MemberStatus.pending,
      };
}
