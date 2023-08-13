import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:plateron_food_order_app/cart/cart.dart';
import 'package:plateron_food_order_app/cart/bloc/cart_bloc.dart';
import 'package:plateron_food_order_app/cart/bloc/cart_event.dart';
import 'package:plateron_food_order_app/cart/ui/cart_page.dart';
import 'package:plateron_food_order_app/menu/bloc/menu_bloc.dart';
import 'package:plateron_food_order_app/menu/bloc/menu_event.dart';
import 'package:plateron_food_order_app/menu/bloc/menu_state.dart';
import 'package:plateron_food_order_app/quantity_button.dart';

class MenuListPage extends StatelessWidget {
  const MenuListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Salads & Soups',
          style: TextStyle(color: Colors.black),
        ),
        titleSpacing: 20,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MenuBloc, MenuState>(builder: (BuildContext context, state) {
              if (state is FetchMenuSuccess) {
                return Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildMenu(context, state.foods),
                    )),
                    _buildFooter(context),
                  ],
                );
              }
              if (state is FetchMenuLoading) {
                return _buildLoading();
              }
              if (state is FetchMenuError) {
                return _buildError(context, state.error);
              }
              return _buildError(context, 'Something went wrong');
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: InkWell(
        onTap: () => context.read<MenuBloc>().add(FetchMenu()),
        child: Text(
          '${error.toString()} \n Tap to retry',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, List<Food> menu) {
    return ListView.separated(
      itemBuilder: (context, index) => _buildFood(context, menu[index]),
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
      itemCount: menu.length,
    );
  }

  Widget _buildFood(BuildContext context, Food food) {
    return SizedBox(
      height: 144,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: 116,
                  imageUrl: food.thumbnail ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2RAmmS3yjdMkpGUh2S858rxj2HB4fzf-4CQ&usqp=CAU',
                  placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name ?? 'Hidden',
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Color(0xff464645), fontSize: 18,fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        food.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff5D5C5C),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$ ${food.price}',
                            style: const TextStyle(color: Color(0xff464645)),
                          ),
                          SizedBox(
                            width: 77,
                            height: 31,
                            child: BlocBuilder<CartBloc, List<CartItem>>(
                              builder: (context, state) {
                                return QuantityButton(
                                  quantity: () {
                                    List<CartItem> items = state
                                        .where((element) => element.food.id == food.id)
                                        .toList();
                                    if (items.isNotEmpty) {
                                      return items.first.quantity;
                                    }
                                    return 0;
                                  }(),
                                  onQuantityChanged: (count) => context
                                      .read<CartBloc>()
                                      .add(ModifyQuantity(CartItem(food, count))),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCartCount(),
              _buildPlaceOrderButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartCount() {
    return BlocBuilder<CartBloc, List<CartItem>>(
      builder: (BuildContext context, state) {
        return Row(
          children: [
            const Icon(Icons.shopping_cart_outlined),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Builder(builder: (context) {
                if(state.isEmpty){
                  return Container();
                }
                int count =
                    state.map((e) => e.quantity).reduce((value, element) => value + element);
                return Text(state.isEmpty
                    ? ''
                    : count == 1
                        ? '$count item'
                        : ' $count items',style: const TextStyle(fontWeight: FontWeight.w500),);
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    const color = Color(0xff79C176);
    return ElevatedButton(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(fontSize: 14)),
          padding: MaterialStateProperty.resolveWith(
              (states) => const EdgeInsets.symmetric(horizontal: 30)),
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return color;
          }),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CartPage(),
            )),
        child: const Text('Place Order'));
  }
}
