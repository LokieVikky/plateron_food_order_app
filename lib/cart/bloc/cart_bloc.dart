import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plateron_food_order_app/cart/cart.dart';
import 'package:plateron_food_order_app/cart/bloc/cart_event.dart';

class CartBloc extends Bloc<CartEvent, List<CartItem>> {
  CartBloc() : super([]) {
    on<ModifyQuantity>(_modifyQuantity);
  }

  void _modifyQuantity(CartEvent event, Emitter<List<CartItem>> emit) async {
    if (event is ModifyQuantity) {
      List<CartItem> foodToModify =
          state.where((element) => element.food.id == event.cartItem.food.id).toList();
      if (foodToModify.isEmpty && event.cartItem.quantity != 0) {
        emit(List.from(state)..add(CartItem(event.cartItem.food, event.cartItem.quantity)));
      } else if (foodToModify.isNotEmpty && event.cartItem.quantity == 0) {
        emit(List.from(state)..removeWhere((element) => element.food.id==event.cartItem.food.id));
      } else if (foodToModify.isNotEmpty && event.cartItem.quantity != 0) {
        int index = state.indexWhere((element) => element.food.id == event.cartItem.food.id);
        if (index == -1) {
          return;
        }
        emit(List.from(state)..[index] = state[index].copyWith(event.cartItem.quantity));
      }
    }
  }
}
