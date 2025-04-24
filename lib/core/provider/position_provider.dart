import 'package:flutter/material.dart';
import 'package:hoteque_app/core/data/model/position.dart';
import 'package:hoteque_app/core/data/networking/response/position_response.dart';
import 'package:hoteque_app/core/data/networking/states/position_result_state.dart';
import 'package:hoteque_app/core/data/networking/util/api_response.dart';
import 'package:hoteque_app/core/data/repository/position_repository.dart';

class PositionProvider extends ChangeNotifier {
  final PositionRepository positionRepository;

  PositionProvider(this.positionRepository);

  // State management dengan ResultState pattern
  PositionResultState _state = PositionInitialState();
  PositionResultState get state => _state;
  
  List<Position> _positions = [];
  List<Position> get positions => _positions;

  Future<void> getAllPositions() async {
    try {
      // Update state ke loading
      _state = PositionLoadingState();
      notifyListeners();

      // Ambil data dari repository
      final ApiResponse<PositionResponse> response = await positionRepository.getAllPositions();

      // Handle hasil response
      if (response.data != null && !response.data!.error) {
        _positions = response.data!.data;
        _state = PositionLoadedState(_positions);
      } else {
        _state = PositionErrorState(response.message ?? "Gagal memuat data jabatan");
      }
    } catch (e) {
      _state = PositionErrorState("Terjadi kesalahan: ${e.toString()}");
    } finally {
      notifyListeners();
    }
  }

  // Metode untuk mencari posisi berdasarkan kata kunci
  List<Position> searchPositions(String keyword) {
    if (keyword.isEmpty) {
      return _positions;
    }
    
    return _positions.where((position) => 
      position.positionName.toLowerCase().contains(keyword.toLowerCase()) ||
      position.departmentName.toLowerCase().contains(keyword.toLowerCase())
    ).toList();
  }
  
  // Reset state ke initial
  void resetState() {
    _state = PositionInitialState();
    _positions = [];
    notifyListeners();
  }
}