class EmployeeInDepartmentResponse {
  final List<EmployeeSearch> employees;
  final bool error;
  final String message;

  EmployeeInDepartmentResponse({
    required this.employees,
    required this.error,
    required this.message,
  });

  factory EmployeeInDepartmentResponse.fromJson(Map<String, dynamic> json) =>
      EmployeeInDepartmentResponse(
        employees: List<EmployeeSearch>.from(
          json["employees"].map((x) => EmployeeSearch.fromJson(x)),
        ),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "employees": List<dynamic>.from(employees.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class EmployeeSearch {
  final int employeeId;
  final String name;

  EmployeeSearch({required this.employeeId, required this.name});

  factory EmployeeSearch.fromJson(Map<String, dynamic> json) =>
      EmployeeSearch(employeeId: json["employee_id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"employee_id": employeeId, "name": name};
}
