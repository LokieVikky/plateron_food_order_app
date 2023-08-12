import 'package:equatable/equatable.dart';
import 'package:food_repository/food_repository.dart';

class CartItem extends Equatable {
  final Food food;
  final int quantity;

  const CartItem(this.food, this.quantity);

  CartItem copyWith(int quantity) {
    return CartItem(food, quantity);
  }

  @override
  List<Object?> get props => [food, quantity];
}
