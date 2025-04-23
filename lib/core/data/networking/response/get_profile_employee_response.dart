class GetProfileEmployeeResponse {
  final bool error;
  final String message;
  final Profile profile;

  GetProfileEmployeeResponse({
    required this.error,
    required this.message,
    required this.profile,
  });

  factory GetProfileEmployeeResponse.fromJson(Map<String, dynamic> json) =>
      GetProfileEmployeeResponse(
        error: json["error"],
        message: json["message"],
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "profile": profile.toJson(),
  };
}

class Profile {
  final String department;
  final String email;
  final int id;
  final String name;
  final String phone;
  final dynamic photo;
  final String position;

  Profile({
    required this.department,
    required this.email,
    required this.id,
    required this.name,
    required this.phone,
    required this.photo,
    required this.position,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    department: json["department"],
    email: json["email"],
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    photo: json["photo"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "department": department,
    "email": email,
    "id": id,
    "name": name,
    "phone": phone,
    "photo": photo,
    "position": position,
  };
}
