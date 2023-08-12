import 'package:equatable/equatable.dart';
import 'package:food_repository/food_repository.dart';

enum MenuStatus { loading, success, error }

class QuantityHelper<T> {
  T data;
  int quantity;

  QuantityHelper(this.data, this.quantity);
}

class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class FetchMenuLoading extends MenuState {
  const FetchMenuLoading();

  @override
  List<Object?> get props => [];
}

class FetchMenuSuccess extends MenuState {
  final List<Food> foods;

  const FetchMenuSuccess(this.foods);

  @override
  List<Object?> get props => [foods];
}

class FetchMenuError extends MenuState {
  final Object error;

  const FetchMenuError(this.error);

  @override
  List<Object?> get props => [error];
}
