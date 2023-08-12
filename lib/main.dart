import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:plateron_food_order_app/cart/bloc/cart_bloc.dart';
import 'package:plateron_food_order_app/menu/bloc/menu_bloc.dart';
import 'package:plateron_food_order_app/menu/bloc/menu_event.dart';
import 'package:plateron_food_order_app/menu/ui/menu_list_page.dart';

void main() {
  final MenuRepository menuRepository = MenuRepository();
  runZonedGuarded(
      () => runApp(FoodApp(
            menuRepository: menuRepository,
          )),
      (error, stack) => log(error.toString(), stackTrace: stack));
}

class FoodApp extends StatelessWidget {
  final MenuRepository menuRepository;

  const FoodApp({required this.menuRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => MenuBloc(menuRepository: menuRepository)..add(FetchMenu())),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: const MaterialApp(
        home: MenuListPage(),
      ),
    );
  }
}
