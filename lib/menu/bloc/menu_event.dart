import 'package:equatable/equatable.dart';
import 'package:food_repository/food_repository.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

final class FetchMenu extends MenuEvent {
  @override
  List<Object> get props => [];
}

final class FoodQuantityModified extends MenuEvent {
  final Food food;
  final int quantity;

  const FoodQuantityModified(this.food, this.quantity);

  @override
  List<Object> get props => [];
}
