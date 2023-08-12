import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class QuantityEvent {}

class IncrementQuantity extends QuantityEvent {}

class DecrementQuantity extends QuantityEvent {}

class QuantityBloc extends Bloc<QuantityEvent, int> {
  int quantity;

  QuantityBloc(this.quantity) : super(quantity) {
    on<IncrementQuantity>(_onIncrement);
    on<DecrementQuantity>(_onDecrement);
  }

  void _onIncrement(QuantityEvent event, Emitter<int> emit) {
    emit(state + 1);
  }

  void _onDecrement(QuantityEvent event, Emitter<int> emit) {
    emit(state - 1);
  }
}

class QuantityButton extends StatelessWidget {
  final int quantity;
  final color = const Color(0xff79C176);
  final Function(int count) onQuantityChanged;

  const QuantityButton({
    required this.onQuantityChanged,
    this.quantity = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => QuantityBloc(quantity),
      child: BlocBuilder<QuantityBloc, int>(
        builder: (BuildContext context, int state) {
          return quantity == 0
              ? _buildAddButton(context, color)
              : _buildQuantityButton(context, quantity, color);
        },
      ),
    );
  }

  Widget _buildQuantityButton(BuildContext context, int state, Color color) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: state != 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    splashColor: Colors.transparent,
                    color: color,
                    onPressed: () {
                      context.read<QuantityBloc>().add(DecrementQuantity());
                      onQuantityChanged(state - 1);
                    },
                    icon: const Icon(
                      Icons.remove,
                      size: 16,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints()),
                Text(state.toString(), style: TextStyle(color: color)),
                IconButton(
                    splashColor: Colors.transparent,
                    color: color,
                    onPressed: () {
                      context.read<QuantityBloc>().add(IncrementQuantity());
                      onQuantityChanged(state + 1);
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 16,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints()),
              ],
            )
          : Center(
              child: Container(
              color: Colors.red,
              child: Text(
                'ADD',
                style: TextStyle(color: color),
              ),
            )),
    );
  }

  Widget _buildAddButton(BuildContext context, Color color) {
    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return color;
        }),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(
                color: Colors.black,
                style: BorderStyle.solid,
              )),
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: color, width: 1.0, style: BorderStyle.solid),
        ),
      ),
      onPressed: () {
        context.read<QuantityBloc>().add(IncrementQuantity());
        onQuantityChanged(1);
      },
      child: const Text('ADD'),
    );
  }
}
