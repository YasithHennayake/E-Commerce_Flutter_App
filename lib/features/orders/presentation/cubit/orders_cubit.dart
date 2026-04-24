import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_orders.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders getOrdersUseCase;

  OrdersCubit({required this.getOrdersUseCase}) : super(const OrdersState());

  Future<void> load() async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final result = await getOrdersUseCase(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: OrdersStatus.failure, failure: f)),
      (orders) => emit(state.copyWith(
        status: OrdersStatus.success,
        orders: orders,
        clearFailure: true,
      )),
    );
  }
}
