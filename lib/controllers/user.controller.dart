import 'package:blind_app/models/user.model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserController {
  final DbCollection users;

  UserController(this.users);

  Future<void> createUser(User user) async {
    await users.insertOne(user.toMap());
  }

  Future<User?> getUserById(String id) async {
    final result = await users.findOne(where.id(ObjectId.parse(id)));
    if (result != null) {
      return User.fromMap(result);
    }
    return null;
  }

  Future<void> updateUser(String id, User user) async {
    await users.replaceOne(where.id(ObjectId.parse(id)), user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await users.deleteOne(where.id(ObjectId.parse(id)));
  }

  Future<User?> login(String username, String password) async {
    final result = await users
        .findOne(where.eq('username', username).eq('password', password));
    if (result != null) {
      return User.fromMap(result);
    }
    return null;
  }
}
