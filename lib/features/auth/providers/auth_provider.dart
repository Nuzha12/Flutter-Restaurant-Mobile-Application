import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/mock_auth_datasource.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/models/user_model.dart';
import 'auth_state.dart';

final _authDs   = Provider((_) => MockAuthDataSource());
final _authRepo = Provider((ref) => AuthRepositoryImpl(ref.read(_authDs)));

// A plain ValueNotifier used as router refreshListenable
final authListenable = ValueNotifier<int>(0);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
        (ref) => AuthNotifier(ref.read(_authRepo)));

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl _repo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    _init();
  }

  void _notify() => authListenable.value++;

  Future<void> _init() async {
    final user = await _repo.getCurrentUser();
    state = user != null
        ? AuthState(status: AuthStatus.authenticated, user: user)
        : const AuthState(status: AuthStatus.unauthenticated);
    _notify();
  }

  Future<bool> login(String email, String password) async {
    state = state.loading;
    try {
      final user = await _repo.login(email, password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
      _notify();
      return true;
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.loading;
    try {
      final user = await _repo.register(name, email, password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
      _notify();
      return true;
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
    _notify();
  }

  Future<bool> sendPasswordReset(String email) async {
    state = state.loading;
    try {
      await _repo.sendPasswordReset(email);
      state = const AuthState(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> updateProfile(UserModel user) async {
    final updated = await _repo.updateProfile(user);
    state = AuthState(status: AuthStatus.authenticated, user: updated);
  }
}