import 'package:guldfasan/models/position.dart';

enum OperationType { create, update, delete, none }

class PositionOperation {
  PositionOperation({required this.position, required this.type});

  final Position position;
  final OperationType type;
}
