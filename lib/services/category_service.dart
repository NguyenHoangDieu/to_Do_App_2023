import 'package:to_do_app_2023/models/category.dart';
import 'package:to_do_app_2023/repositories/repository.dart';
class CategoryService{
  Repository _repository;

  CategoryService(){
    _repository = Repository();
  }

  //Create data
  saveCategories(Category category) async{
    return await _repository.insertData('categories', category.categoryMap());
  }

  //Read data
  readCategories() async{
    return await _repository.readData('categories');
  }

  //Read data by id
  readCategoryById(categoryId) async{
    return await _repository.readDataById('categories', categoryId);
  }

  //Update data
  updateCategories(Category category) async{
    return await _repository.updateData('categories', category.categoryMap());
  }

  //Delete data
  deleteCategories(categoryId) async{
    return await _repository.deleteData('categories', categoryId);
  }
}