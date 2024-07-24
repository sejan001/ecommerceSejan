import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';

abstract class ProductsEvents {}

class FetchProducts extends ProductsEvents {
  FilterProductStateModel filterModel;

  FetchProducts({required this.filterModel});
}

class AddProduct extends ProductsEvents {
  String? title;
  String? description;
  String? price;
  String? category;
  String? thumbnail;

  AddProduct({
    this.title,
    this.description,
    this.price,
    this.category,
    this.thumbnail,
  });
}

class DeleteProduct extends ProductsEvents {
  String? id;
  DeleteProduct({required this.id});
}
