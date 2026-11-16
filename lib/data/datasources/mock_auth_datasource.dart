import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/models/user_model.dart';

class MockAuthDataSource {
  static final Map<String, Map<String, dynamic>> _users = {
    AppConstants.sampleEmail: {
      'id': 'usr_001', 'name': 'Alex Johnson',
      'email': AppConstants.sampleEmail,
      'password': AppConstants.samplePassword,
      'phone': '+1 555-0100',
      'avatarUrl': 'https://i.pravatar.cc/150?img=12',
      'loyaltyPoints': 1250,
      'createdAt': DateTime(2024, 1, 15),
    },
  };

  static UserModel? _current;

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final data = _users[email.toLowerCase().trim()];
    if (data == null || data['password'] != password) {
      throw const AuthException(message: 'Invalid email or password. Please try again.');
    }
    _current = _build(data);
    return _current!;
  }

  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final key = email.toLowerCase().trim();
    if (_users.containsKey(key)) {
      throw const AuthException(message: 'An account with this email already exists.');
    }
    final id = 'usr_${DateTime.now().millisecondsSinceEpoch}';
    final data = {
      'id': id, 'name': name.trim(), 'email': key, 'password': password,
      'phone': null,
      'avatarUrl': 'https://i.pravatar.cc/150?img=${(_users.length + 10) % 70}',
      'loyaltyPoints': 100,
      'createdAt': DateTime.now(),
    };
    _users[key] = data;
    _current = _build(data);
    return _current!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _current = null;
  }

  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!_users.containsKey(email.toLowerCase().trim())) {
      throw const AuthException(message: 'No account found with this email address.');
    }
  }

  Future<UserModel?> getCurrentUser() async => _current;

  Future<UserModel> updateProfile(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _current = user;
    return user;
  }

  UserModel _build(Map<String, dynamic> d) => UserModel(
    id: d['id'], name: d['name'], email: d['email'],
    phone: d['phone'], avatarUrl: d['avatarUrl'],
    loyaltyPoints: d['loyaltyPoints'] ?? 0,
    createdAt: d['createdAt'] ?? DateTime.now(),
  );
}