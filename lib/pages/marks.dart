import 'package:flutter/material.dart';

class MarksPage extends StatelessWidget {
  const MarksPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Информатика: '),
                        const Text('5 ', style: TextStyle(color: Colors.green),),
                        const Text('5 ', style: TextStyle(color: Colors.green),),
                        const Text('5 ', style: TextStyle(color: Colors.green),)
                      ],
                    ),
                    const Text('5.0', style: TextStyle(color:  Colors.green),)
                  ],
                ),
                onTap: () {},
              )
            ));
  }
}
