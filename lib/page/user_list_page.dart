import 'package:flutter/material.dart';
import '/model/inputform.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  final users = <InputForm>[];

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
                    users.add(InputForm(
                        name: nameController.text,
                        age: int.parse(ageController.text)));
                  });
                },
                child: Text('Submit')),
            const Divider(),
            Expanded(
                child: users.isEmpty
                    ? Text('없습니다.')
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                              title: Text(users[i].name),
                              subtitle: Text(users[i].age.toString()));
                        }))
          ],
        ));
  }
}
