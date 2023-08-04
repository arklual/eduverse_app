import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eduverse_app/config.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomeworksPage extends StatefulWidget {
  const HomeworksPage({super.key, required this.user});
  final user;

  @override
  State<HomeworksPage> createState() => _HomeworksPageState(user);
}

class _HomeworksPageState extends State<HomeworksPage> {
  var homeworks = [];
  var isError = false;
  var isLoaded = false;
  final user;

  _HomeworksPageState(this.user);

  @override
  void initState() {
    super.initState();
    getHomeworks();
  }

  Future<void> getHomeworks() async {
    final now = DateTime.now();
    var url = Uri.http(origin, '/homeworks/get', {
      'deadline':
          DateTime(now.year, now.month, now.day + 1).toString().split(' ')[0],
      'user_id': '1'
    });
    try {
      var data =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      final response = utf8.decode(data.bodyBytes);
      if (mounted) {
        setState(() {
          isLoaded = true;
          homeworks = jsonDecode(response);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          homeworks = [];
          isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var tomorrow = DateTime.now()
        .add(const Duration(days: 1))
        .toUtc()
        .toString()
        .split(' ')[0];
    if (homeworks.isEmpty && isError) {
      return const Text(
          'Ой, что-то пошло не так... У тебя точно есть интернет');
    } else if (homeworks.isEmpty && !isLoaded) {
      return const Text('Загрузка...');
    } else if (homeworks.isEmpty && isLoaded) {
      return Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: const Text('На завтра пока нет никаких заданий')),
          ],
        ),
        if (user['is_admin']) (
        Positioned(
          right: 10,
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddHomeworkPage()));
            },
            child: const Icon(Icons.add),
          ),
        ))
      ]);
    }
    return Stack(
      children: [
        ListView.builder(
            itemCount: homeworks.length,
            itemBuilder: (context, i) => SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(homeworks[i]['subject_name']),
                      Checkbox(
                        value: homeworks[i]['is_done'],
                        onChanged: (bool? a) async {
                          var url = Uri.http(origin, '/homeworks/change-done', {
                            'id': homeworks[i]['id'].toString(),
                          });
                          try {
                            var data = await http.get(url,
                                headers: {'Authorization': 'Bearer $token'});
                            final response = utf8.decode(data.bodyBytes);
                            setState(() {
                              homeworks[i]['is_done'] =
                                  jsonDecode(response)['is_done'];
                            });
                          } catch (e) {}
                        },
                        shape: Theme.of(context).checkboxTheme.shape,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeworkPage(
                        task: homeworks[i]['task'],
                        subject: homeworks[i]['subject_name'],
                      ),
                    ));
                  },
                  subtitle: Text('Срок: ' +
                      (homeworks[i]['deadline'] == tomorrow
                          ? 'завтра'
                          : homeworks[i]['deadline'])),
                ))),
        if (user['is_admin']) (
        Positioned(
          right: 10,
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddHomeworkPage()));
            },
            child: const Icon(Icons.add),
          ),
        ))
      ],
    );
  }
}

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key, required this.task, required this.subject});
  final String task;
  final String subject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(subject),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(task),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Сделано'))
              ]),
        ));
  }
}

class AddHomeworkPage extends StatefulWidget {
  const AddHomeworkPage({Key? key}) : super(key: key);

  @override
  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  DateTime? _deadline;
  String _task = '';
  String _subject = '';
  List _subjects = [];
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _getSubjects();
  }

  Future<void> _getSubjects() async {
    var url = Uri.http(origin, '/subjects/get');
    try {
      var data =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      final response = utf8.decode(data.bodyBytes);
      if (mounted) {
        setState(() {
          _subjects = jsonDecode(response);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _subjects = [];
          _isError = true;
        });
      }
    }
  }

  Future<void> _addHomework() async {
    var url = Uri.http(origin, '/homeworks/add/');
    try {
      await http.post(url, headers: {
        'Authorization': 'Bearer $token'
      }, body: {
        'task': _task,
        'deadline': _deadline.toString().split(' ')[0],
        'subject_id': _subject,
        'is_done': 'False'
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Добавление д/з')),
        body: const Center(
            child:
                Text('Ой, что-то пошло не так... У тебя точно есть интернет')),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Добавление д/з')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
              items: [
                for (int i = 0; i < _subjects.length; i++)
                  (DropdownMenuItem(
                      value: _subjects[i]['subject_id'],
                      child: Text(_subjects[i]['subject_name']))),
              ],
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _subject = value.toString();
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Предмет',
              )),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Задание',
            ),
            onChanged: (text) async {
              setState(() {
                _task = text;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              final DateTime? d = await showDatePicker(
                  context: context,
                  initialDate: _deadline ?? DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2025));
              setState(() {
                _deadline = d;
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Выбрать deadline'),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check_outlined),
        onPressed: () async {
          var nav = Navigator.of(context);
          await _addHomework();
          nav.pop();
        },
      ),
    );
  }
}
