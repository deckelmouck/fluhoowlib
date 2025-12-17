import 'package:flutter/material.dart';
import 'package:hoowlib/models/appsettings_provider.dart';
import 'package:provider/provider.dart';

class DevPage extends StatelessWidget{
  const DevPage ({super.key, this.count});
  
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Row(
          children: [
            Spacer(),
            Text('count of books:'),
            Spacer(),
            Text(context.watch<AppsettingsProvider>().bookCount.toString()),
            Spacer(),            
          ],
        ),
        Spacer(), // Defaults to a flex of one.
        Text('Middle'),
        Spacer(),
        Text('down'),
        // Gives twice the space between Middle and End than Begin and Middle.
        Spacer(flex: 2),
        Text('End'),
        Spacer(),
      ],
    );
  }
}
