import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_cached_token.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final GetCachedToken getCachedTokenUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCachedTokenUseCase,
  }) : super(const AuthState());

  Future<void> checkAuth() async {
    emit(const AuthState(status: AuthStatus.checking));
    final result = await getCachedTokenUseCase(const NoParams());
    result.fold(
      (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
      (token) => emit(
        token == null
            ? const AuthState(status: AuthStatus.unauthenticated)
            : AuthState(status: AuthStatus.authenticated, token: token),
      ),
    );
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(const AuthState(status: AuthStatus.loading));
    final result = await loginUseCase(
      LoginParams(username: username, password: password),
    );
    result.fold(
      (failure) =>
          emit(AuthState(status: AuthStatus.failure, failure: failure)),
      (token) =>
          emit(AuthState(status: AuthStatus.authenticated, token: token)),
    );
  }

  Future<void> logout() async {
    await logoutUseCase(const NoParams());
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
