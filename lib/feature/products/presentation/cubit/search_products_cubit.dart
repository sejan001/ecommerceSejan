
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_bloc/feature/products/domain/model/filter_product_state_model.dart';

part 'search_products_state.dart';

class FilterProductsCubit extends Cubit<FilterProductStateModel> {
  FilterProductsCubit()
      : super(
        FilterProductStateModel(
          
        ),
      
            );

  void updateLimit(int newLimit) {
  print("limit before ${state.limit}");
    emit(state.copyWith(limit: newLimit.toString()));
    print("limit after ${state.limit}");
    }
    
  void updateSkip(String skip) {
      print("limit before ${state.skip}");
        emit(state.copyWith(skip: skip.toString()));
        
  }
  void updateCategory(String category) {
        emit(state.copyWith(category: category.toString()));
  }
  }



  

