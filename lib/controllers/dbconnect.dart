import 'package:mongo_dart/mongo_dart.dart';

class DbConnect {
  static late Db _db;
  late String uri;
  DbConnect(String u) {
    uri = u;
  }

  Future<void> open() async {
    _db = await Db.create(uri);
    await _db.open();
  }

  Future<void> close() async {
    await _db.close();
  }

  Future<DbCollection> getUsersCollection() async {
    return _db.collection('users');
  }

  Future<DbCollection> getPostsCollection() async {
    return _db.collection('categories');
  }
}
