import 'package:flutter/material.dart';
import 'package:guldfasan/models/position.dart';
import 'package:guldfasan/widgets/data_view_card.dart';
import 'package:guldfasan/widgets/sub_page_scaffold.dart';

class PositionDataViewPage extends StatelessWidget {
  PositionDataViewPage({Key? key, required this.positions}) : super(key: key);

  final Future<Iterable<PositionCollection>> positions;

  @override
  Widget build(BuildContext context) {
    return SubPageScaffold(
        title: 'position data',
        child: FutureBuilder<Iterable<PositionCollection>>(
          future: positions,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              final sortedCollections = snapshot.data!.toList()
                ..sort((a, b) {
                  final cmp =
                      a.symbol.toLowerCase().compareTo(b.symbol.toLowerCase());
                  return cmp != 0 ? cmp : a.symbol.compareTo(b.symbol);
                });
              final positions = <Position>[];
              for (var collection in sortedCollections) {
                positions.addAll(collection.byDate());
              }
              return ListView(
                children: [
                  ...positions.map(
                    (position) => DataViewCard(position: position),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
