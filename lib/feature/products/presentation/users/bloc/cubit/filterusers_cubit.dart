import 'package:bloc/bloc.dart';
import 'package:project_bloc/feature/products/presentation/users/bloc/cubit/filter_users_state.dart';

import 'package:project_bloc/feature/products/presentation/users/bloc/cubit/filterusers_state.dart';


class FilterusersCubit extends Cubit<FilterUser> {
  FilterusersCubit() : super(FilterUser());

  
  void updateLimit(int newLimit) {
  print("limit before ${state.limit}");
    emit(state.copyWith(limit: newLimit.toString()));
    print("limit after ${state.limit}");
    }
    
  void updateSkip(String skip) {
      print("limit before ${state.skip}");
        emit(state.copyWith(skip: skip.toString()));
        
  }
   void updateName(String name) {
      print("limit before ${state.skip}");
        emit(state.copyWith(name: name.toString()));
        
  }
  
}



