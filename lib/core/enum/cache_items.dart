import '../init/cache/app_cache.dart';

enum CacheItems<T> {
  isFirst;

  String get name {
    switch (this) {
      case CacheItems.isFirst:
        return CacheItems.isFirst.name;
      default:
        throw Exception('Invalid enum value: $this');
    }
  }

  T? read() {
    if (T == String) {
      return AppCache.instance.sharedPreferences.getString(name) as T?;
    } else if (T == bool) {
      if (name == CacheItems.isFirst.name) {
        return AppCache.instance.sharedPreferences.getBool(name) as T?;
      } else {
        return (AppCache.instance.sharedPreferences.getBool(name) ?? false)
            as T?;
      }
    }
    return null;
  }

  Future<bool> write(T value) async {
    if (T == String) {
      return await AppCache.instance.sharedPreferences
          .setString(name, value as String);
    } else if (T == bool) {
      return await AppCache.instance.sharedPreferences
          .setBool(name, value as bool);
    }
    // Add additional types as needed
    return false;
  }
}
