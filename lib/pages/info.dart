import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (context, i) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: Text(
                    'Внимание!!! Завтра ко второму уроку!',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ));
  }
}
