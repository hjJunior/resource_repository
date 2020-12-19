import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/resource_source/cache/hive_data_source.dart';
import 'package:resource_repository/resource_source/resource.dart';
import 'package:uuid/uuid.dart';

class MockResource extends Mock implements Resource {}

class MockLazyBox extends Mock implements LazyBox<MockResource> {}

class MockUuid extends Mock implements Uuid {}

class HiveResourceSourceImpl extends HiveResourceSource {
  @override
  String get boxName => 'fake-box-name';
}

void main() {
  MockLazyBox box;
  MockResource model;
  MockResource model2;
  MockUuid uuid;
  HiveResourceSourceImpl subject;

  setUp(() async {
    box = MockLazyBox();
    model = MockResource();
    model2 = MockResource();
    uuid = MockUuid();
    subject = HiveResourceSourceImpl();

    await subject.initialize(box, uuid);
  });

  test('.findAll', () async {
    when(box.keys).thenReturn(['key-1', 'key-2']);
    when(box.get('key-1')).thenAnswer((_) => Future.value(model));
    when(box.get('key-2')).thenAnswer((_) => Future.value(model2));

    final result = await subject.findAll();

    expect(result, [model, model2]);

    verifyInOrder([
      box.keys,
      box.get('key-1', defaultValue: null),
      box.get('key-2', defaultValue: null),
    ]);
  });

  test('.findOne', () async {
    when(box.get('key-1')).thenAnswer((_) => Future.value(model));

    final result = await subject.findOne('key-1');

    expect(result, model);

    verify(box.get('key-1', defaultValue: null)).called(1);
  });

  test('.update', () async {
    final result = await subject.update('key-1', model);

    expect(result, model);

    verify(box.put('key-1', model)).called(1);
  });

  test('.create', () async {
    when(uuid.v4()).thenReturn('fake-uuid');
    final result = await subject.create(model);

    expect(result, model);

    verify(box.put('fake-uuid', model)).called(1);
    verify(uuid.v4()).called(1);
  });

  test('.delete', () async {
    await subject.delete('key-1');

    verify(box.delete('key-1')).called(1);
  });

  test('.clear', () async {
    await subject.clear();

    verify(box.deleteFromDisk()).called(1);
  });
}
