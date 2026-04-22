class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://fakestoreapi.com';

  // Products
  static const String products = '/products';
  static const String categories = '/products/categories';
  static String productById(int id) => '/products/$id';
  static String productsByCategory(String category) =>
      '/products/category/$category';

  // Auth
  static const String login = '/auth/login';

  // Users
  static const String users = '/users';
  static String userById(int id) => '/users/$id';

  // Carts (used for order simulation)
  static const String carts = '/carts';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
