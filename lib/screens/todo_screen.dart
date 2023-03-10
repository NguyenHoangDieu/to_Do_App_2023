import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_2023/models/todo.dart';
import 'package:to_do_app_2023/services/category_service.dart';
import 'package:to_do_app_2023/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _todoTitleController = TextEditingController();
  final _todoDescriptionController = TextEditingController();
  final _todoTodoDateController = TextEditingController();
  TodoService _todoService;
  List<Todo> _todoList = <Todo>[];
  var _selectedValue;

  final _categories = <DropdownMenuItem>[];
  @override
  void initState(){
    super.initState();
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
        todoModel.todoDate = todo['todo'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Write todo title'
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write todo description'
              ),
            ),
            TextField(
              controller: _todoTodoDateController,
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
                        _todoTodoDateController.text = formattedDate; //set formatted date to TextField value.
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async{
                  var todoObject = Todo();
                  todoObject.title = _todoTitleController.text;
                  todoObject.description = _todoDescriptionController.text;
                  todoObject.isFinished = 0;
                  todoObject.category = _selectedValue.toString();
                  todoObject.todoDate = _todoTodoDateController.text;
                  var todoService = TodoService();
                  var result = await todoService.saveTodos(todoObject);
                  if(result>0){
                    Navigator.pop(context);
                    getAllTodos();
                    const snackBar = SnackBar(
                      content: Text('Added!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)
                ),
                child: const Text("Save", style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      ),
    );
  }
}
