import "package:rxdart/rxdart.dart";
import "dart:async";

class ShipConsoleBloc {
  ShipConsoleBloc._();
  static final ShipConsoleBloc _instance = ShipConsoleBloc._();
  static ShipConsoleBloc getInstance() => _instance;

  BehaviorSubject<String> _snackMsgSubject = BehaviorSubject<String>();

  Stream<String> get snackMsgStream => _snackMsgSubject.stream;
  
  void showSnackBar(snackMsg) => _snackMsgSubject.add(snackMsg);

  void dispose() {
    _snackMsgSubject.close();
  }
}
