import 'dart:async';

import 'package:hive/hive.dart';
import 'package:resource_repository/resource_source/resource.dart';
import 'package:uuid/uuid.dart';

import 'index.dart';

abstract class HiveResourceSource<T extends Resource>
    extends CacheResourceSource<T> {
  LazyBox<T> _box;
  Uuid _uuid;

  String get boxName;

  Future<void> initialize([LazyBox<T> box, Uuid uuid]) async {
    _box = box ?? await Hive.openLazyBox<T>(boxName);
    _uuid = uuid ?? Uuid();
  }

  Future<List<T>> findAll() async {
    final list = List<T>();

    _box.keys.forEach((key) async {
      list.add(await _box.get(key));
    });

    return list;
  }

  Future<T> findOne(String key) async {
    return await _box.get(key);
  }

  Future<T> update(String key, T model) async {
    await _box.put(key, model);

    return model;
  }

  Future<T> create(T model) async {
    await _box.put(_uuid.v4(), model);

    return model;
  }

  Future<void> delete(String key, {bool cascate = true}) async {
    await _box.delete(key);
  }

  Future<void> clear() async {
    await _box.deleteFromDisk();
  }
}
