  import 'package:flutter_bloc/flutter_bloc.dart';

class RebuildState {}

class RebuildCubit extends Cubit<RebuildState> {
  RebuildCubit() : super(RebuildState());

 
  void triggerRebuild() {
    emit(RebuildState());
  }
}
