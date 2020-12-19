import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resource_repository/repository_strategies/remote_only.dart';
import 'package:resource_repository/resource_source/remote/index.dart';
import 'package:resource_repository/resource_source/resource.dart';

class MockRemoteResourceSource extends Mock implements RemoteResourceSource {}

class MockResource extends Mock implements Resource {}

void main() {
  MockResource model;
  MockRemoteResourceSource remoteSource;
  RemoteOnlyRepositoryStrategy subject;

  setUp(() {
    model = MockResource();
    remoteSource = MockRemoteResourceSource();
    subject = RemoteOnlyRepositoryStrategy(
      remoteSource: remoteSource,
    );
  });

  test('.getAll', () async {
    when(remoteSource.findAll()).thenAnswer((_) => Future.value([model]));

    final result = await subject.getAll();

    expect(result, [model]);
    verify(remoteSource.findAll()).called(1);
  });

  test('.get', () async {
    when(remoteSource.findOne('fake-id'))
        .thenAnswer((_) => Future.value(model));

    final result = await subject.get('fake-id');

    expect(result, model);
    verify(remoteSource.findOne(any)).called(1);
  });

  test('.create', () async {
    await subject.create(model);

    verify(remoteSource.create(model)).called(1);
  });

  test('.update', () async {
    await subject.update('fake-id', model);

    verify(remoteSource.update('fake-id', model)).called(1);
  });

  test('.delete', () async {
    await subject.delete('fake-id', cascate: true);

    verify(remoteSource.delete('fake-id', cascate: true)).called(1);
  });
}
