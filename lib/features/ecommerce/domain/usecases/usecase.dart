export 'usecase.dart';
export 'get_product_usecase.dart';
export 'insert_product_usecase.dart';
export 'update_product_usecase.dart';
export 'delete_product_usecase.dart';
export 'view_all_products_usecase.dart';// If you still have this

/// Base class for all use cases
/// [T] is the return type
/// [P] is the parameter type
abstract class UseCase<T, P> {
  Future<T> call(P params);
}

/// Use this when a use case doesn't need parameters
class NoParams {
  const NoParams();
}