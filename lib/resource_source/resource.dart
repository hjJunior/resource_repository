abstract class Resource {
  String id;
  String externalId;

  /// This method will be used by [IncrementalCacheUpdateStrategy] (or by any [CacheUpdateStrategy])
  /// to handle the cache updation (See: [onGetAll])
  /// This method should copy only the properties returned by [RemoteResourceSource]
  /// IMPORTANT: null properties may be considered non returned property from [findAll]
  Resource shallowCopy(Resource obj);

  /// This method will be used by [IncrementalCacheUpdateStrategy] (or by any [CacheUpdateStrategy])
  /// to handle the cache updation (See: [onCreate], [onGet] and [onUpdate])
  /// You must consider doing a full copy of your resource
  /// IMPORTANT: null properties should be considered as new change
  Resource copy(Resource obj);
}
