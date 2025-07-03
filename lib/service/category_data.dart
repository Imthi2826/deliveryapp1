
import 'package:deliveryapp/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel= CategoryModel(name: '', image: '');

  // Category 1: Pizza
  categoryModel.name = "Pizza";
  categoryModel.image = "assets/pizza.jpg";
  category.add(categoryModel);
  categoryModel =CategoryModel(name: '', image: '');

  // Category 2: Burger
  categoryModel =CategoryModel(name: '', image: '');
  categoryModel.name = "Burger";
  categoryModel.image = "assets/burger.jpg";
  category.add(categoryModel);


  categoryModel =CategoryModel(name: '', image: '');
  categoryModel.name = "Desserts";
  categoryModel.image = "assets/dessert.jpg";
  category.add(categoryModel);

  //
  categoryModel =CategoryModel(name: '', image: '');
  categoryModel.name = "Desserts";
  categoryModel.image = "assets/dessert.jpg";
  category.add(categoryModel);

  //
  categoryModel =CategoryModel(name: '', image: '');
  categoryModel.name = "Desserts";
  categoryModel.image = "assets/dessert.jpg";
  category.add(categoryModel);
  return category;
}
