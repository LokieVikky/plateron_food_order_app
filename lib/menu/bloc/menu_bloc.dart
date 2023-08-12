import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:plateron_food_order_app/menu/bloc/menu_event.dart';
import 'package:plateron_food_order_app/menu/bloc/menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository;

  MenuBloc({required MenuRepository menuRepository})
      : _menuRepository = menuRepository,
        super(const FetchMenuLoading()) {
    on<FetchMenu>(_fetchMenu);
  }

  void _fetchMenu(MenuEvent event, Emitter<MenuState> emit) async {
    try {
      emit(const FetchMenuLoading());
      List<Food> foods = await _menuRepository.fetchMenu();
      emit(FetchMenuSuccess(foods));
    } catch (e) {
      emit(FetchMenuError(e));
    }
  }

}
