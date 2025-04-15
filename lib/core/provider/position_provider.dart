import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/position.dart';
import 'package:hoteque_app/core/data/networking/response/position_response.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';
import 'package:hoteque_app/core/data/repository/position_repository.dart';

class PositionProvider extends ChangeNotifier {
  final PositionRepository positionRepository;

  PositionProvider(this.positionRepository);

  bool isLoading = false;
  List<Position> positions = [];
  String errorMessage = '';

  Future<void> getAllPositions() async {
    isLoading = true;
    positions = [];
    notifyListeners();

    final ApiResponse<PositionResponse> response = await positionRepository.getAllPositions();

    if (response.data != null && !response.data!.error) {
      positions = response.data!.data;
    } else {
      errorMessage = response.message ?? "Gagal memuat data jabatan";
    }

    isLoading = false;
    notifyListeners();
  }

  // Metode untuk mencari posisi berdasarkan kata kunci
  List<Position> searchPositions(String keyword) {
    if (keyword.isEmpty) {
      return positions;
    }
    
    return positions.where((position) => 
      position.positionName.toLowerCase().contains(keyword.toLowerCase()) ||
      position.departmentName.toLowerCase().contains(keyword.toLowerCase())
    ).toList();
  }
}