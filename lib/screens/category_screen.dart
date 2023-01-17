import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

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
            onPressed: (){},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(onPressed: (){},
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue)
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
        title: const Text("Categories"),
      ),
      body: const Center(child: Text("Welcome to Categories Screen")),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showFormDialog(context);
      },
      child: const Icon(Icons.add),
      ),
    );
  }
}
