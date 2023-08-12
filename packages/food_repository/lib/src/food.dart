import 'package:equatable/equatable.dart';

class Food extends Equatable {
  Food(this.id, this.name, this.description, this.thumbnail, this.price);

  final String? id;
  final String? name;
  final String? description;
  final String? thumbnail;
  final String? price;

  @override
  List<Object?> get props => [id, name, description, thumbnail, price];
}
