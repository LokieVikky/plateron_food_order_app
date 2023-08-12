import 'package:equatable/equatable.dart';
import 'package:plateron_food_order_app/cart/cart.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class ModifyQuantity extends CartEvent {
  final CartItem cartItem;

  const ModifyQuantity(this.cartItem);

  @override
  List<Object> get props => [cartItem];
}
