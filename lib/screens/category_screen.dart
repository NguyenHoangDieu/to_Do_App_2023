import 'package:flutter/material.dart';
import 'package:to_do_app_2023/services/category_service.dart';

import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final _categoryNameController = TextEditingController();
  final _categoryDescriptionController = TextEditingController();
  final _editCategoryNameController = TextEditingController();
  final _editCategoryDescriptionController = TextEditingController();
  final _category = Category();
  final _categoryService = CategoryService();
  var category;

  List<Category> _categoryList = <Category>[];

  @override
  void initState(){
    super.initState();
    getAllCategories();
}

  getAllCategories() async{
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async{
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name']??'No name';
      _editCategoryDescriptionController.text = category[0]['description']??'No description';
    });
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context){
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
              _category.name = _categoryNameController.text;
              _category.description = _categoryDescriptionController.text;

              var result = await _categoryService.saveCategories(_category);
              if(result > 0){
                Navigator.pop(context);
                getAllCategories();
                const snackBar = SnackBar(
                  content: Text('Added!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }
            },
            child: const Text("Save"),
          )
        ],
        title: const Text('Categories Form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  hintText: "Write a category",
                  labelText: "Category",
                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: const InputDecoration(
                  hintText: "Write a description",
                  labelText: "Description",
                ),
              )
            ],
          ),
        ),
      );
    });
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
              _category.id = category[0]['id'];
              _category.name = _editCategoryNameController.text;
              _category.description = _editCategoryDescriptionController.text;

              var result = await _categoryService.updateCategories(_category);
              if (result > 0){
                Navigator.pop(context);
                getAllCategories();
                const snackBar = SnackBar(
                  content: Text('Updated!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }
            },
            child: const Text("Update"),
          )
        ],
        title: const Text('Edit Categories Form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editCategoryNameController,
                decoration: const InputDecoration(
                  hintText: "Write a category",
                  labelText: "Category",
                ),
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: const InputDecoration(
                  hintText: "Write a description",
                  labelText: "Description",
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  _deleteFormDialog(BuildContext context, categoryId){
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
              var result = await _categoryService.deleteCategories(categoryId);
              if(result>0){
                Navigator.pop(context);
                getAllCategories();
                const snackBar = SnackBar(
                  content: Text('Deleted!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }
            },
            child: const Text("Delete"),
          )
        ],
        title: const Text('Do you want to delete this category? '),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(onPressed: ()=>Navigator.pop(context),
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: const Text("Categories"),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
          itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8.0,
              child: ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: (){
                      _editCategory(context, _categoryList[index].id);
                    },
                ),
                title: Row(
                  children: <Widget>[
                    Text(_categoryList[index].name),
                    IconButton(
                      icon: const Icon(Icons.delete,color: Colors.red,),
                      onPressed: (){
                        _deleteFormDialog(context, _categoryList[index].id);
                      },
                    )
                  ],
                ),
                subtitle: Text(_categoryList[index].description),
              ),
            ),
          );
          }
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showFormDialog(context);
      },
      child: const Icon(Icons.add),
      ),
    );
  }
}
