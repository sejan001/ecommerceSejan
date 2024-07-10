import 'package:equatable/equatable.dart';

sealed class CartsEvent extends Equatable {
  const CartsEvent();

  @override
  List<Object> get props => [];
}

class fetchCarts extends CartsEvent {
  final int? userId;

  fetchCarts({required this.userId});

  @override
  List<Object> get props => [userId!];
}

class AddProduct extends CartsEvent {
  final int? userId;
  final int? id;
  final String? title;
  final double? price;
  final int? quantity;
  final double? total;
  final double? discountPercentage;
  final double? discountedTotal;
  final String? thumbnail;

  const AddProduct(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity,
      this.total,
      required this.discountPercentage,
      this.discountedTotal,
      required this.thumbnail,
      required this.userId});
}
