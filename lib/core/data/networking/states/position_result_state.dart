
import 'package:hoteque_app/core/data/model/position.dart';

sealed class PositionResultState {}

class PositionInitialState extends PositionResultState {}

class PositionLoadingState extends PositionResultState {}

class PositionErrorState extends PositionResultState {
  final String message;
  
  PositionErrorState(this.message);
}

class PositionLoadedState extends PositionResultState {
  final List<Position> positions;
  
  PositionLoadedState(this.positions);
}

