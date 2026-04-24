import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection_container.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../domain/entities/order_item.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';
import '../cubit/orders_cubit.dart';
import '../widgets/address_form.dart';
import '../widgets/order_review.dart';
import '../widgets/payment_form.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CheckoutCubit>(),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final _addressKey = GlobalKey<AddressFormState>();
  final _paymentKey = GlobalKey<PaymentFormState>();

  List<OrderItem> _toOrderItems(Cart cart) => cart.items
      .map((i) => OrderItem(
            productId: i.productId,
            title: i.title,
            price: i.price,
            image: i.image,
            quantity: i.quantity,
          ))
      .toList(growable: false);

  void _onPlaceOrder(BuildContext context, Cart cart) {
    context.read<CheckoutCubit>().placeOrder(
          items: _toOrderItems(cart),
          subtotal: cart.subtotal,
          tax: cart.tax,
          total: cart.total,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listenWhen: (p, c) =>
            p.status != c.status ||
            (p.failure != c.failure && c.failure != null),
        listener: (context, state) {
          if (state.status == CheckoutStatus.failure &&
              state.failure != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.failure!.message)),
              );
          }
          if (state.status == CheckoutStatus.success &&
              state.placedOrder != null) {
            context.read<CartBloc>().add(const ClearCart());
            context.read<OrdersCubit>().load();
            context.go('/checkout/success', extra: state.placedOrder!.id);
          }
        },
        builder: (context, state) {
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final cart = cartState.cart;
              final placing = state.status == CheckoutStatus.placing;
              return Stepper(
                currentStep: state.step,
                onStepTapped: (i) {
                  if (i < state.step) {
                    context.read<CheckoutCubit>().goToStep(i);
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        FilledButton(
                          onPressed: placing
                              ? null
                              : () => _onStepContinue(context, cart),
                          child: placing && state.step == 2
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(state.step == 2 ? 'Place order' : 'Next'),
                        ),
                        const SizedBox(width: 12),
                        if (state.step > 0)
                          TextButton(
                            onPressed: placing
                                ? null
                                : () => context
                                    .read<CheckoutCubit>()
                                    .goToStep(state.step - 1),
                            child: const Text('Back'),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('Shipping address'),
                    isActive: state.step >= 0,
                    content: AddressForm(
                      key: _addressKey,
                      initial: state.address,
                      onSubmit: context.read<CheckoutCubit>().setAddress,
                    ),
                  ),
                  Step(
                    title: const Text('Payment'),
                    isActive: state.step >= 1,
                    content: PaymentForm(
                      key: _paymentKey,
                      initial: state.payment,
                      onSubmit: context.read<CheckoutCubit>().setPayment,
                    ),
                  ),
                  Step(
                    title: const Text('Confirm'),
                    isActive: state.step >= 2,
                    content: state.canReview
                        ? OrderReview(
                            address: state.address!,
                            payment: state.payment!,
                            items: _toOrderItems(cart),
                            subtotal: cart.subtotal,
                            tax: cart.tax,
                            total: cart.total,
                          )
                        : const Text('Complete earlier steps first.'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _onStepContinue(BuildContext context, Cart cart) {
    final state = context.read<CheckoutCubit>().state;
    switch (state.step) {
      case 0:
        _addressKey.currentState?.submit();
        break;
      case 1:
        _paymentKey.currentState?.submit();
        break;
      case 2:
        if (cart.isEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Your cart is empty.')),
            );
          return;
        }
        _onPlaceOrder(context, cart);
        break;
    }
  }
}
