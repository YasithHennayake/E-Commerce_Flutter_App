import 'package:flutter/material.dart';

import '../../domain/entities/payment_info.dart';

class PaymentForm extends StatefulWidget {
  final PaymentInfo? initial;
  final ValueChanged<PaymentInfo> onSubmit;

  const PaymentForm({super.key, this.initial, required this.onSubmit});

  @override
  State<PaymentForm> createState() => PaymentFormState();
}

class PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  late PaymentMethod _method = widget.initial?.method ?? PaymentMethod.creditCard;
  late final _card = TextEditingController(
    text: widget.initial?.cardLast4 != null
        ? '•••• •••• •••• ${widget.initial!.cardLast4}'
        : '',
  );

  @override
  void dispose() {
    _card.dispose();
    super.dispose();
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    String? last4;
    if (_method == PaymentMethod.creditCard) {
      final digits = _card.text.replaceAll(RegExp(r'\D'), '');
      last4 = digits.substring(digits.length - 4);
    }
    widget.onSubmit(PaymentInfo(method: _method, cardLast4: last4));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          RadioGroup<PaymentMethod>(
            groupValue: _method,
            onChanged: (v) {
              if (v != null) setState(() => _method = v);
            },
            child: const Column(
              children: [
                RadioListTile<PaymentMethod>(
                  value: PaymentMethod.creditCard,
                  title: Text('Credit card'),
                ),
                RadioListTile<PaymentMethod>(
                  value: PaymentMethod.cashOnDelivery,
                  title: Text('Cash on delivery'),
                ),
              ],
            ),
          ),
          if (_method == PaymentMethod.creditCard) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _card,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null) return 'Required';
                final digits = v.replaceAll(RegExp(r'\D'), '');
                if (digits.length < 13) return 'Card number is too short';
                return null;
              },
            ),
          ],
        ],
      ),
    );
  }
}
