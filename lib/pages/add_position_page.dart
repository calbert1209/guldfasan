import 'package:flutter/material.dart';
import 'package:guldfasan/models/position_operation.dart';
import 'package:guldfasan/widgets/edit_position_form.dart';
import 'package:guldfasan/widgets/sub_page_scaffold.dart';

class AddPositionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SubPageScaffold(
      onCompleted: () => Navigator.pop(context),
      title: "Add Position",
      child: Column(
        children: [
          EditPositionForm(
            onUpdatedHandler: (position) {
              Navigator.pop(
                context,
                PositionOperation(
                  position: position,
                  type: OperationType.update,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
