import 'dart:convert';

import 'package:eduverse_app/pages/home.dart';
import 'package:eduverse_app/pages/homeworks.dart';
import 'package:eduverse_app/pages/marks.dart';
import 'package:eduverse_app/pages/notes.dart';
import 'package:eduverse_app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:http/http.dart' as http;

import 'pages/info.dart';
import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.deepPurple, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'EduVerse App',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          checkboxTheme: const CheckboxThemeData(
            shape: CircleBorder(),
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          checkboxTheme: const CheckboxThemeData(
            shape: CircleBorder(),
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'EduVerse App'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Map user = {};

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async{
    var url = Uri.http(
        origin, '/accounts/get', {'id': '1'});
    try {
      var data =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      final response = utf8.decode(data.bodyBytes);
      setState(() {
        user = jsonDecode(response);
      });
    } catch (e) {
      setState(() {
        user = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const HomePage(),
      const MarksPage(),
      const NotesPage(),
      HomeworksPage(user: user),
      const InfoPage(),
      SettingsPage(user: user)
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.secondary,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_rows),
              label: 'Оценки',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Конспекты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              label: 'Д/з',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Объявления',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Настройки',
            ),
          ]),
    );
  }
}
