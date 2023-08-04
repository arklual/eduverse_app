import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.user});
  final Map user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0),
          child: Column(
            children: [
              Icon(Icons.person_2_rounded, size: 300,),
              Text(user['username']),
              Text('Telegram ID: '+ user['telegram_id']),
              Text(user['class'] +' класс')
            ],
          ),
        ),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Уведомления'),
              Switch(value: false, onChanged: (value) {},),
            ],
          ),
          onTap: (){},
        ),
        ListTile(
          title: const Text('Выбрать стиль уведомлений'),
          enabled: false,
          onTap: (){},
        ),
        ListTile(
          title: const Text('Настроить приоритеты на этот триместр'),
          onTap: (){},
        ),
        ListTile(
          title: const Text('О разработчиках'),
          onTap: (){},
        ),
        ListTile(
          title: const Text('Удалить аккаунт', style: TextStyle(color: Colors.red),),
          onTap: (){},
        ),
      ],
    );
  }
}
