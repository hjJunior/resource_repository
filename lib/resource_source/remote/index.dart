import 'package:resource_repository/resource_source/resource.dart';
import 'package:resource_repository/resource_source/resource_source.dart';

abstract class RemoteResourceSource<T extends Resource>
    implements ResourceSource<T> {}
