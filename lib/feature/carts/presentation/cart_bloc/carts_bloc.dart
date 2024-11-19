import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_bloc/feature/carts/model/cart_model.dart';
import 'package:project_bloc/feature/products/domain/repo/product_repo.dart';
import 'package:project_bloc/feature/products/domain/services/shared_prefereneces_service.dart';

import 'package:project_bloc/feature/carts/presentation/cart_bloc/carts_event.dart';

part 'carts_state.dart';

class CartsBloc extends Bloc<CartsEvent, CartsState> {
  CartsBloc() : super(CartsInitial()) {
    on<fetchCarts>(_fetchCarts);
    on<AddProduct>(_addCarts);
  }

  Future<void> _fetchCarts(fetchCarts event, Emitter<CartsState> emit) async {
    emit(CartsLoading());
    try {
      final UserCartResponse carts =
          await RepoProvider().fetchCarts(event.userId);
print("aaaaaakoo carts ${carts.carts}");
        SharedPreferenecesService.setString(key: "userCarts",value: jsonEncode(carts));
        final cartList = SharedPreferenecesService.getString(key: "userCarts");
        print("save vako carts $cartList");

      print("naya carts ${carts.carts[0]}");

      emit(cartsLoadedState(carts: carts));
    } catch (e) {
      emit(CartsError("carts loaded state error $e"));
    }
  }

  Future<void> _addCarts(AddProduct event, Emitter<CartsState> emit) async {
    emit(CartsLoading());
    try {
      final UserCartResponse carts = await RepoProvider().addCart(
        id: event.id,
        userId: event.userId,
        discountPercentage: event.discountPercentage,
        thumbnail: event.thumbnail,
        title: event.title,
        price: event.price,
        total: event.total,
      );

      emit(cartsLoadedState(carts: carts));

   
    } catch (e) {
      emit(CartsError("carts loaded state error $e"));
    }
  }
   Future<void> _deleteCart(DeleteCart event, Emitter<CartsState> emit) async {
    emit(CartsLoading());
    try {
   
      await RepoProvider().deleteCart(event.cartId);
      emit(CartDeletedSuccessfully()); 
    } catch (e) {
      emit(CartsError("Error deleting cart: $e"));
    }
  }
}
