import 'package:equatable/equatable.dart';
import '../../../domain/models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String?    errorMessage;

  const AuthState({this.status = AuthStatus.initial, this.user, this.errorMessage});

  bool get isLoading       => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError        => status == AuthStatus.error;

  AuthState get loading      => const AuthState(status: AuthStatus.loading);
  AuthState get unauthed     => const AuthState(status: AuthStatus.unauthenticated);

  AuthState copyWith({AuthStatus? status, UserModel? user, String? errorMessage}) =>
      AuthState(status: status ?? this.status, user: user ?? this.user, errorMessage: errorMessage);

  @override
  List<Object?> get props => [status, user, errorMessage];
}