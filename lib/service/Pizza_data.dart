import 'package:deliveryapp/model/pizza_model.dart';
import 'package:flutter/material.dart';

List<PizzaModel> getpizza(){
  List<PizzaModel> pizza=[];
  PizzaModel pizzaModel=  PizzaModel();

  pizzaModel.name="name";
  pizzaModel.image="";
  pizzaModel.price="";
  pizza.add(pizzaModel);
  pizzaModel =PizzaModel();

  pizzaModel.name="name";
  pizzaModel.image="";
  pizzaModel.price="";
  pizza.add(pizzaModel);
  pizzaModel =PizzaModel();

  pizzaModel.name="name";
  pizzaModel.image="";
  pizzaModel.price="";
  pizza.add(pizzaModel);
  pizzaModel =PizzaModel();

  pizzaModel.name="name";
  pizzaModel.image="";
  pizzaModel.price="";
  pizza.add(pizzaModel);
  pizzaModel =PizzaModel();

  return pizza;
}