class LoginResponse {
  bool error;
  LoginResult loginResult;
  String message;

  LoginResponse({
    required this.error,
    required this.loginResult,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    error: json["error"],
    loginResult: LoginResult.fromJson(json["loginResult"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "loginResult": loginResult.toJson(),
    "message": message,
  };
}

class LoginResult {
  int id;
  String name;
  String token;

  LoginResult({required this.id, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      LoginResult(id: json["id"], name: json["name"], token: json["token"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "token": token};
}
