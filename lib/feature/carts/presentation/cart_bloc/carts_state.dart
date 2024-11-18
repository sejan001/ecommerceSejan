part of 'carts_bloc.dart';

sealed class CartsState extends Equatable {
  const CartsState();

  @override
  List<Object> get props => [];
}

final class CartsInitial extends CartsState {}

class cartsLoadedState extends CartsState {
  UserCartResponse carts;

  cartsLoadedState({required this.carts});
}

class CartsError extends CartsState {
  final String error;

  CartsError(this.error);
}

class CartsLoading extends CartsState {}
