import 'package:dart_sdk/api/base/model/data_page.dart';
import 'package:flutter_template/base/storage/paged_resource_loader.dart';

/// Simple representation of [PagedResourceLoader]
///
/// [distinct] enables filter by distinct
/// based on [Object.equals] and [Object.hashCode] to avoid
/// duplicates on page-number-based pagination
class SimplePagedResourceLoader<T> extends PagedResourceLoader<T> {
  Future<DataPage<T>> Function(String? nextCursor) request;
  bool isDistinct;

  SimplePagedResourceLoader(this.request, {this.isDistinct = true})
      : super(isDistinct);

  @override
  Future<DataPage<T>> getPageRequest(String? nextCursor) {
    return request(nextCursor);
  }
}
