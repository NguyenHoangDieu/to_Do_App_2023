import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_2023/helpers/drawer_navigation.dart';
import 'package:to_do_app_2023/models/todo.dart';
import 'package:to_do_app_2023/screens/todo_screen.dart';
import 'package:to_do_app_2023/services/todo_service.dart';

import '../services/category_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _editTodoTitleController = TextEditingController();
  final _editTodoDescriptionController = TextEditingController();
  final _editTodoTodoDateController = TextEditingController();
  TodoService _todoService;
  final _categories = <DropdownMenuItem>[];
  List<Todo> _todoList = <Todo>[];
  var todo;
  final _todo = Todo();
  var _selectedValue;
  @override
  initState(){
    super.initState();
    getAllTodos();
    _loadCategories();
  }

  getAllTodos() async{
    _todoService = TodoService();
    _todoList = <Todo>[];
    var todos = await _todoService.readTodos();
    todos.forEach((todo){
      setState(() {
        var todoModel = Todo();
        todoModel.id = todo['id'];
        todoModel.title = todo['title'];
        todoModel.description = todo['description'];
        todoModel.category = todo['category'];
        todoModel.todoDate = todo['todoDate'];
        todoModel.isFinished = todo['isFinished'];
        _todoList.add(todoModel);
      });
    });
  }

  _loadCategories() async{
    var categoriesService = CategoryService();
    var categories = await categoriesService.readCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(
          value: category['name'],
          child: Text(category['name']),
        ));
      });
    });
  }

  _editTodo(BuildContext context, todoId) async{
    todo = await _todoService.readTodoById(todoId);
    setState(() {
      _editTodoTitleController.text = todo[0]['title']??'No title';
      _editTodoDescriptionController.text = todo[0]['description']??'No description';
      _editTodoTodoDateController.text = todo[0]['todoDate']??'No date';

    });
    _editFormDialog(context);
  }

  _editFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          TextButton(
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.red)
            ),
            onPressed: ()=>Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.green)
            ),
            onPressed: () async{
              _todo.id = todo[0]['id'];
              _todo.title = _editTodoTitleController.text;
              _todo.description = _editTodoDescriptionController.text;
              _todo.todoDate = _editTodoTodoDateController.text;
              _todo.category = _selectedValue.toString();
              _todo.isFinished = 0;
              var result = await _todoService.updateTodos(_todo);
              if (result > 0){
                Navigator.pop(context);
                getAllTodos();
                const snackBar = SnackBar(
                  content: Text('Updated!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }
            },
            child: const Text("Update"),
          )
        ],
        title: const Text('Edit Todos Form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editTodoTitleController,
                decoration: const InputDecoration(
                  hintText: "Write a category",
                  labelText: "Category",
                ),
              ),
              TextField(
                controller: _editTodoDescriptionController,
                decoration: const InputDecoration(
                  hintText: "Write a description",
                  labelText: "Description",
                ),
              ),
              TextField(
                controller: _editTodoTodoDateController,
                decoration: InputDecoration(
                    labelText: 'Date',
                    hintText: 'Pick a date',
                    prefixIcon: InkWell(
                      onTap: () async{
                        DateTime pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), //get today's date
                          firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100),
                        );
                        if(pickedDate != null ){
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                          setState(() {
                            _editTodoTodoDateController.text = formattedDate; //set formatted date to TextField value.
                          });
                        }else{
                          print("Date is not selected");
                        }
                      },
                      child: const Icon(Icons.calendar_today),
                    )
                ),
              ),
              DropdownButtonFormField(
                  value: _selectedValue,
                  items: _categories,
                  hint: const Text('Category'),
                  onChanged: (value){
                    setState(() {
                      _selectedValue = value;
                    });
                  }
              ),
            ],
          ),
        ),
      );
    });
  }

  _deleteFormDialog(BuildContext context, todoId){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          TextButton(
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.green)
            ),
            onPressed: ()=>Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.red)
            ),
            onPressed: () async{
              var result = await _todoService.deleteTodos(todoId);
              if(result>0){
                Navigator.pop(context);
                getAllTodos();
                const snackBar = SnackBar(
                  content: Text('Deleted!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text("Delete"),
          )
        ],
        title: const Text('Do you want to delete this todo? '),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title:const Text('Todo List App'),
       ),
      drawer: const DrawerNavigation(),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child:  ListTile(
                    leading: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed:(){
                          _editTodo(context, _todoList[index].id);
                        }
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_todoList[index].title??'No Title'),
                        IconButton(
                            onPressed: (){
                              _deleteFormDialog(context, _todoList[index].id);
                            },
                            icon: const Icon(Icons.delete,color: Colors.red,))
                      ],
                    ),
                    subtitle: Text(_todoList[index].category ?? 'No category'),
                    trailing: Text(_todoList[index].todoDate ?? 'No date'),
                  ),
                ),
              );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const TodoScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
