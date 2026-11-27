import 'membership.dart';

enum JoinError { notFound, tooManyAttempts, weddingClosed, removed, notSignedIn, generic }

class JoinException implements Exception {
  const JoinException(this.error);
  final JoinError error;
}

class JoinResult {
  const JoinResult({required this.weddingId, required this.role, required this.status});
  final String weddingId;
  final MemberRole role;
  final MemberStatus status;
}
