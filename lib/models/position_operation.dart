import 'package:guldfasan/models/position.dart';

enum OperationType { update, delete }

class PositionOperation {
  PositionOperation({required this.position, required this.type});

  final Position position;
  final OperationType type;
}
