import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Define the different states
abstract class InternetState {}

class InternetInitial extends InternetState {}

class InternetLoading extends InternetState {}

class InternetSuccess extends InternetState {}

class InternetFailure extends InternetState {
  final String errorMessage;

  InternetFailure(this.errorMessage);
}

class InternetDisconnected extends InternetState {
  final String message;

  InternetDisconnected(this.message);
}

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();

  InternetCubit() : super(InternetInitial()) {
    _checkInitialConnection();
    _listenToConnectivityChanges();
  }


  Future<void> _checkInitialConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionState(connectivityResult);
  }


  void _listenToConnectivityChanges() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionState(result);
    });
  }

  void _updateConnectionState(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      emit(InternetDisconnected("No internet connection"));
    } else {
      emit(InternetSuccess());
    }
  }

  void fetchData() {
    emit(InternetLoading());


    Future.delayed(Duration(seconds: 2), () {
      var currentConnection = _connectivity.checkConnectivity();
      currentConnection.then((result) {
        if (result == ConnectivityResult.none) {
          emit(InternetDisconnected("No internet connection"));
        } else {
          emit(InternetSuccess());
        }
      });
    });
  }
}
