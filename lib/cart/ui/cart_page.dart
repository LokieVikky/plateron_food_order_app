import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plateron_food_order_app/cart/cart.dart';
import 'package:plateron_food_order_app/cart/bloc/cart_bloc.dart';
import 'package:plateron_food_order_app/cart/bloc/cart_event.dart';
import 'package:plateron_food_order_app/quantity_button.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Summary',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<CartBloc, List<CartItem>>(
        builder: (context, state) {
          if (state.isEmpty) {
            return _buildNoItems();
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return _buildCartItem(context, state[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),
              _buildFooter(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.1,
              blurRadius: 0.1,
              offset: const Offset(0, -1), // This creates a top shadow.
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(color: Color(0xff464645), fontSize: 18, fontWeight: FontWeight.w500),
              ),
              BlocBuilder<CartBloc, List<CartItem>>(
                builder: (context, state) {
                  if (state.isNotEmpty) {
                    double totalAmount = 0;
                    for (CartItem cartItem in state) {
                      double price = double.parse(cartItem.food.price ?? '0');
                      totalAmount = totalAmount + (price * cartItem.quantity);
                    }
                    return Text('\$ $totalAmount',
                        style: const TextStyle(
                            color: Color(0xff464645), fontSize: 18, fontWeight: FontWeight.w500));
                  }
                  return const Text('\$ 0',
                      style: TextStyle(
                          color: Color(0xff464645), fontSize: 18, fontWeight: FontWeight.w500));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoItems() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          r'''Cart's lonely! Menu awaits – add items and let's party. 🛒🎉''',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem) {
    return SizedBox(
      height: 144,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cartItem.food.name ?? 'Hidden',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Color(0xff464645), fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 77,
                  height: 31,
                  child: QuantityButton(
                    quantity: cartItem.quantity,
                    onQuantityChanged: (count) {
                      context.read<CartBloc>().add(ModifyQuantity(cartItem.copyWith(count)));
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                '\$ ${cartItem.food.price??0}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Color(0xff464645), fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
