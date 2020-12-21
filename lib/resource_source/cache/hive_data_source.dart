import 'dart:async';

import 'package:hive/hive.dart';
import 'package:resource_repository/resource_source/resource.dart';

import 'index.dart';

abstract class HiveResourceSource<T extends Resource>
    extends CacheResourceSource<T> {
  Box<T> _box;

  String get boxName;

  Future<void> initialize([Box<T> box]) async {
    _box = box ?? await Hive.openBox<T>(boxName);
  }

  Future<List<T>> findAll() async {
    final list = List<T>();

    _box.keys.forEach((key) async {
      list.add(_box.get(int.parse(key.toString())));
    });

    return list;
  }

  Future<T> findOne(String key) async {
    return _box.get(int.parse(key.toString()));
  }

  Future<T> update(String key, T model) async {
    await _box.put(int.parse(key), model);

    return model;
  }

  Future<T> create(T model) async {
    final key = await _box.add(model);

    model.id = key.toString();
    await _box.put(key, model);

    return model;
  }

  Future<void> delete(String key, {bool cascate = true}) async {
    await _box.delete(int.tryParse(key));
  }

  Future<void> clear() async {
    await _box.deleteFromDisk();
  }

  Future<T> findOneByExternalId(String externalId) async {
    final registers = await findAll();

    T data;

    try {
      data =
          registers.firstWhere((register) => register.externalId == externalId);
    } on StateError catch (_) {}

    return data;
  }
}
