import 'package:xiao_cry/entity/joke_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "JokeEntity") {
      return JokeEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
