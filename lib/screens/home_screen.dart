import 'package:flutter/material.dart';
import 'package:to_do_app_2023/helpers/drawer_navigation.dart';
import 'package:to_do_app_2023/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title:const Text('Todo List App'),
       ),
      drawer: const DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const TodoScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
