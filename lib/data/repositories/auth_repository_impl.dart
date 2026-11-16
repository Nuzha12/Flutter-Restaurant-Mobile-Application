import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockAuthDataSource _ds;
  AuthRepositoryImpl(this._ds);

  @override Future<UserModel>  login(String e, String p)              => _ds.login(e, p);
  @override Future<UserModel>  register(String n, String e, String p) => _ds.register(n, e, p);
  @override Future<void>       logout()                               => _ds.logout();
  @override Future<void>       sendPasswordReset(String e)            => _ds.sendPasswordReset(e);
  @override Future<UserModel?> getCurrentUser()                       => _ds.getCurrentUser();
  @override Future<UserModel>  updateProfile(UserModel u)             => _ds.updateProfile(u);
}