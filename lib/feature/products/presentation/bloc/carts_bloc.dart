import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_bloc/feature/products/domain/model/cart_model.dart';
import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';

import 'package:project_bloc/feature/products/presentation/bloc/carts_event.dart';

part 'carts_state.dart';

class CartsBloc extends Bloc<CartsEvent, CartsState> {
  CartsBloc() : super(CartsInitial()) {
    on<fetchCarts>(_fetchCarts);
    on<AddProduct>(_addCarts);
  }

  Future<void> _fetchCarts(fetchCarts event, Emitter<CartsState> emit) async {
    emit(CartsLoading());
    try {
      final List<UserCartResponse> carts =
          await ProductsRepository().fetchCarts(event.userId);

      print("naya carts $carts");

      emit(cartsLoadedState(carts: carts));
    } catch (e) {
      emit(CartsError("carts loaded state error $e"));
    }
  }

  Future<void> _addCarts(AddProduct event, Emitter<CartsState> emit) async {
    emit(CartsLoading());
    try {
      final List<UserCartResponse> carts = await ProductsRepository().addCart(
        id: event.id,
        userId: event.userId,
        discountPercentage: event.discountPercentage,
        thumbnail: event.thumbnail,
        title: event.title,
        price: event.price,
        total: event.total,
      );

      emit(cartsLoadedState(carts: carts));

      final cartsJson = carts.map((cart) => cart.toJson()).toList();
    } catch (e) {
      emit(CartsError("carts loaded state error $e"));
    }
  }
}