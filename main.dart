import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
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
  List<String> contact = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Enter Name',
                        hintText: 'Enter Your Name'),
                    controller: nameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: insertIntoDatabase,
                        child: const Text('Create'),
                      ),
                      ElevatedButton(
                          onPressed: readDataFromDatabase, child: Text('Read')),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: contact.length,
                    itemBuilder: (_, int position) {
                      return Card(
                        child: ListTile(
                          leading: Text(contact.elementAt(position)),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: updateFromDatabase,
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: deleteFromDatabase,
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertIntoDatabase() async {
    displayText = nameController.text;
    await DatabaseHelper.instance
        .insert({DatabaseHelper.columnName: displayText});
    contact = displayText as List<String>;
  }

  void readDataFromDatabase() async {
    contact.clear();
    var dbquery = await DatabaseHelper.instance.queryDatabase();
    print(dbquery);
    for (int i = 0; i < dbquery.length; ++i) {
      contact.add(dbquery[i]["name"]);
    }
    setState(() {});
  }

  void updateFromDatabase() async {
    await DatabaseHelper.instance
        .update({DatabaseHelper.columnId: 2, DatabaseHelper.columnName: 'xyz'});
  }

  void deleteFromDatabase() async {
    await DatabaseHelper.instance.delete(contact.remove("id") as int);
    setState(() {});
  }
}
