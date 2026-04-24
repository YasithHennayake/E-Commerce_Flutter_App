import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';

enum ProfileStatus { initial, loading, success, failure, saving }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final Failure? failure;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.failure,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, user, failure];
}
