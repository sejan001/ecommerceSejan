import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';

abstract class ProductsEvents{}
class FetchProducts extends ProductsEvents{
FilterProductStateModel filterModel;

FetchProducts({required this.filterModel});

}



