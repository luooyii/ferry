import "dart:async";
import "package:rxdart/rxdart.dart";
import "dart:convert";
import "package:http/http.dart" as http;

class FavoriteBloc {
  final _favoritesSubject = BehaviorSubject<int>();
  Stream<int> get favorites => _favoritesSubject.stream.distinct();
}
