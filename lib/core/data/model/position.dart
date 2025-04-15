class Position {
  final int id;
  final int departmentId;
  final String departmentName;
  final String positionName;
  final bool isCompleted;

  Position({
    required this.id,
    required this.departmentId,
    required this.departmentName,
    required this.positionName,
    required this.isCompleted,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    id: json["id"],
    departmentId: json["department_id"],
    departmentName: json["department_name"],
    positionName: json["position_name"],
    isCompleted: json["is_completed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "department_id": departmentId,
    "department_name": departmentName,
    "position_name": positionName,
    "is_completed": isCompleted,
  };
}
