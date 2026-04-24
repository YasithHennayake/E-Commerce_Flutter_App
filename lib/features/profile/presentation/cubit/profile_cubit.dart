import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearFailure: true));
    final result = await getProfileUseCase(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: ProfileStatus.failure, failure: f)),
      (user) => emit(state.copyWith(
        status: ProfileStatus.success,
        user: user,
        clearFailure: true,
      )),
    );
  }

  Future<void> update(User user) async {
    emit(state.copyWith(status: ProfileStatus.saving, clearFailure: true));
    final result = await updateProfileUseCase(user);
    result.fold(
      (f) => emit(state.copyWith(status: ProfileStatus.failure, failure: f)),
      (updated) => emit(state.copyWith(
        status: ProfileStatus.success,
        user: updated,
        clearFailure: true,
      )),
    );
  }
}
