class ShiftResponse {
  final List<ShiftforSchedule> data;
  final String error;
  final String message;

  ShiftResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  factory ShiftResponse.fromJson(Map<String, dynamic> json) => ShiftResponse(
    data: List<ShiftforSchedule>.from(json["data"].map((x) => ShiftforSchedule.fromJson(x))),
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

class ShiftforSchedule {
  final int id;
  final String type;
  final String startTime;
  final String endTime;

  ShiftforSchedule({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
  });

  factory ShiftforSchedule.fromJson(Map<String, dynamic> json) => ShiftforSchedule(
    id: json["id"],
    type: json["type"],
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "start_time": startTime,
    "end_time": endTime,
  };
}
