
import 'package:deliveryapp/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel= CategoryModel(name: '', image: '');

  // Category 1: Pizza
  categoryModel.name = "Pizza";
  categoryModel.image = "assets/pizzaicon.png";
  category.add(categoryModel);
  categoryModel =CategoryModel(name: '', image: '');

  // Category 2: Burger
  categoryModel =CategoryModel(name: '', image: '');
  categoryModel.name = "Burger";
  categoryModel.image = "assets/burgericon.png";
  category.add(categoryModel);


  categoryModel =CategoryModel(name: '', image: '');
  categoryModel.name = "Desserts";
  categoryModel.image = "assets/cakeicon.png";
  category.add(categoryModel);

  //
  categoryModel =CategoryModel(name: '', image: '');
  categoryModel.name = "Biryani";
  categoryModel.image = "assets/biryani.png";
  category.add(categoryModel);

  //
  return category;
}
