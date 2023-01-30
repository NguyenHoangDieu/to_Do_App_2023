import 'package:to_do_app_2023/models/todo.dart';
import 'package:to_do_app_2023/repositories/repository.dart';
class TodoService{
  Repository _repository;

  TodoService(){
    _repository = Repository();
  }

  //Create data
  saveTodos(Todo todo) async{
    return await _repository.insertData('todos', todo.todoMap());
  }

  //Read data
  readTodos() async{
    return await _repository.readData('todos');
  }

  //Read data by id
  readTodoById(todoId) async{
    return await _repository.readDataById('todos', todoId);
  }

  //Update data
  updateTodos(Todo todo) async{
    return await _repository.updateData('todos', todo.todoMap());
  }

  //Delete data
  deleteTodos(todoId) async{
    return await _repository.deleteData('todos', todoId);
  }
}