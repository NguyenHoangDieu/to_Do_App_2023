class Category{
  int id;
  String name;
  String description;

  categoryMap(){
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;
    return mapping;
  }
}

