import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/storage_keys.dart';
import 'core/network/dio_client.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_cached_token.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/models/cart_item_model.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/add_to_cart.dart';
import 'features/cart/domain/usecases/clear_cart.dart';
import 'features/cart/domain/usecases/get_cart.dart';
import 'features/cart/domain/usecases/remove_from_cart.dart';
import 'features/cart/domain/usecases/update_quantity.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_categories.dart';
import 'features/products/domain/usecases/get_product_by_id.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/cubit/product_detail_cubit.dart';
import 'features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'features/wishlist/data/models/wishlist_item_model.dart';
import 'features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'features/wishlist/domain/repositories/wishlist_repository.dart';
import 'features/wishlist/domain/usecases/add_to_wishlist.dart';
import 'features/wishlist/domain/usecases/get_wishlist.dart';
import 'features/wishlist/domain/usecases/remove_from_wishlist.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<DioClient>(() => DioClient.create(sl()));

  _registerAuth();
  _registerProducts();
  _registerCart();
  _registerWishlist();
}

void _registerAuth() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl()),
  );
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCachedToken(sl()));
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCachedTokenUseCase: sl(),
    ),
  );
}

void _registerProducts() {
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerFactory(
    () => ProductBloc(getProducts: sl(), getCategories: sl()),
  );
  sl.registerFactory(
    () => ProductDetailCubit(getProductById: sl(), getProducts: sl()),
  );
}

void _registerCart() {
  final box = Hive.box<CartItemModel>(StorageKeys.cartBox);
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(box),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => UpdateQuantity(sl()));
  sl.registerLazySingleton(() => ClearCart(sl()));
  sl.registerFactory(
    () => CartBloc(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      removeFromCartUseCase: sl(),
      updateQuantityUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );
}

void _registerWishlist() {
  final box = Hive.box<WishlistItemModel>(StorageKeys.wishlistBox);
  sl.registerLazySingleton<WishlistLocalDataSource>(
    () => WishlistLocalDataSourceImpl(box),
  );
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetWishlist(sl()));
  sl.registerLazySingleton(() => AddToWishlist(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlist(sl()));
  sl.registerFactory(
    () => WishlistCubit(
      getWishlistUseCase: sl(),
      addToWishlistUseCase: sl(),
      removeFromWishlistUseCase: sl(),
    ),
  );
}
