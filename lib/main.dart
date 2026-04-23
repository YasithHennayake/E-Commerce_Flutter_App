import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/storage_keys.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/cart/data/models/cart_item_model.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_event.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/products/domain/entities/product.dart';
import 'features/products/presentation/pages/product_detail_page.dart';
import 'features/products/presentation/pages/product_list_page.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItemModel>(StorageKeys.cartBox);
  await initDependencies();
  runApp(const ECommerceApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const _AuthGate()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final extra = state.extra;
        return ProductDetailPage(
          productId: id,
          initialProduct: extra is Product ? extra : null,
        );
      },
    ),
  ],
);

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()..checkAuth()),
        BlocProvider(create: (_) => sl<CartBloc>()..add(const LoadCart())),
      ],
      child: MaterialApp.router(
        title: 'E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            secondary: Colors.amber,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            secondary: Colors.amber,
            brightness: Brightness.dark,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.checking:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthStatus.authenticated:
            return const _AuthenticatedHome();
          case AuthStatus.unauthenticated:
          case AuthStatus.loading:
          case AuthStatus.failure:
            return const LoginPage();
        }
      },
    );
  }
}

class _AuthenticatedHome extends StatelessWidget {
  const _AuthenticatedHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('E-Commerce'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: const Text('Cart'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/cart');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AuthCubit>().logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: const ProductListPage(),
    );
  }
}
