import 'package:hoteque_app/core/data/model/position.dart';

class PositionResponse {
  final List<Position> data;
  final bool error;
  final String message;

  PositionResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  factory PositionResponse.fromJson(Map<String, dynamic> json) =>
      PositionResponse(
        data: List<Position>.from(json["data"].map((x) => Position.fromJson(x))),
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "error": error,
    "message": message,
  };
}

