import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/inputForm.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

bool isDarkMode = false;

class _UserListPageState extends State<UserListPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  late Box _darkMode;
  late Box<InputForm> _inputFormBox;

  @override
  void initState() {
    _darkMode = Hive.box('DarkModeBox');
    _inputFormBox = Hive.box('InputFormBox');
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            CupertinoSwitch(
              value: isDarkMode,
              onChanged: (val) {
                setState(() {
                  isDarkMode = val;
                  _darkMode.put('darkMode', val);
                });
              },
            )
          ],
        ),
        body: Column(
          children: [
            Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(label: Text('name')),
                ),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(label: Text('age')),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _inputFormBox.add(InputForm(
                        name: nameController.text,
                        age: int.parse(ageController.text)));
                  });
                },
                child: Text('Submit')),
            const Divider(),
            ValueListenableBuilder(
                valueListenable:
                    Hive.box<InputForm>('inputFormBox').listenable(),
                builder: (context, Box<InputForm> inputFormBox, widget) {
                  final users = inputFormBox.values.toList();
                  return Expanded(
                      child: _inputFormBox.isEmpty
                          ? Text('없습니다.')
                          : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, i) {
                                return ListTile(
                                    title: Text(users[i].name),
                                    subtitle: Text(users[i].age.toString()),
                                    trailing: ElevatedButton(
                                        onPressed: () {
                                          final key = users[i].key;
                                          inputFormBox.delete(key).then((_) =>
                                              log('${key} deleted from Database'));
                                        },
                                        child: Icon(Icons.delete)));
                              }));
                })
          ],
        ));
  }
}
