import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_token.dart';

enum AuthStatus {
  initial,
  checking,
  unauthenticated,
  loading,
  authenticated,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthToken? token;
  final Failure? failure;

  const AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.failure,
  });

  @override
  List<Object?> get props => [status, token, failure];
}
