import 'package:flutter/material.dart';
import 'package:sqlite_tutorial/database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class Contacts {
  String name = '';
  Contacts({required name});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  String displayText = '';
  List<Contacts> contact = List.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Enter Name',
                      hintText: 'Enter Your Name'),
                  controller: nameController,
                ),
                ElevatedButton(
                  onPressed: () async {
                    displayText = nameController.text;
                    await DatabaseHelper.instance
                        .insert({DatabaseHelper.columnName: displayText});
                    setState(() {
                      contact.add(Contacts(name: displayText));
                    });
                  },
                  child: const Text('Create'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      var dbquery =
                          await DatabaseHelper.instance.queryDatabase();
                      print(dbquery);
                    },
                    child: const Text('Read')),
                ElevatedButton(onPressed: () {}, child: const Text('Update')),
                ElevatedButton(onPressed: () {}, child: const Text('Delete')),
                Expanded(
                  child: ListView.builder(
                    itemCount: contact.length,
                    itemBuilder: (context, index) => getRow(index),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getRow(int index) {
    return ListTile(
      title: Column(
        children: [Text(contact[index].name)],
      ),
    );
  }
}
