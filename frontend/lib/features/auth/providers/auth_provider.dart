import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamster_pos_frontend/core/providers.dart';
import 'package:hamster_pos_frontend/features/auth/models/auth_dtos.dart';
import 'package:hamster_pos_frontend/features/auth/repository/auth_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Represents the state for both login and register flows
class AuthState {
  final bool isLoading;
  final String? error;
  AuthState({this.isLoading = false, this.error});
}

// The StateNotifier that will manage the AuthState
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  AuthController(this._authRepository) : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      await _authRepository.login(LoginRequest(email: email, password: password));
      state = AuthState(isLoading: false);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, error: "Login Failed: ${e.toString()}");
      return false;
    }
  }
  
  Future<bool> register(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      await _authRepository.register(RegisterRequest(email: email, password: password));
      state = AuthState(isLoading: false);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, error: "Registration Failed: ${e.toString()}");
      return false;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});


final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

final isAdminProvider = FutureProvider.autoDispose<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    return false;
  }
  try {
  final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  if (decodedToken.containsKey('roles')) {
    final roles = decodedToken['roles'] as List;
    // Check if the list of roles contains the 'ROLE_ADMIN' string
    return roles.contains('ROLE_ADMIN');
  }
  return false;
} catch (e) {
  return false;
}
});