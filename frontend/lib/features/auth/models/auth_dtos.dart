class LoginRequest {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String email;
  final String password;
  RegisterRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class AuthResponse {
  final String token;
  AuthResponse({required this.token});
  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(token: json['token']);
}

class UserResponse {
  final int id;
  final String email;
  UserResponse({required this.id, required this.email});
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    final dynamic idValue = json['id'];
    return UserResponse(
      id: idValue is int ? idValue : int.parse(idValue.toString()),
      email: json['email'],
    );
  }
}