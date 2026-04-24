import 'package:flutter/material.dart';

import '../../domain/entities/address.dart';

class AddressForm extends StatefulWidget {
  final Address? initial;
  final ValueChanged<Address> onSubmit;

  const AddressForm({super.key, this.initial, required this.onSubmit});

  @override
  State<AddressForm> createState() => AddressFormState();
}

class AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.fullName ?? '');
  late final _street = TextEditingController(text: widget.initial?.street ?? '');
  late final _city = TextEditingController(text: widget.initial?.city ?? '');
  late final _zip = TextEditingController(text: widget.initial?.zip ?? '');
  late final _country =
      TextEditingController(text: widget.initial?.country ?? '');
  late final _phone = TextEditingController(text: widget.initial?.phone ?? '');

  @override
  void dispose() {
    _name.dispose();
    _street.dispose();
    _city.dispose();
    _zip.dispose();
    _country.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      Address(
        fullName: _name.text.trim(),
        street: _street.text.trim(),
        city: _city.text.trim(),
        zip: _zip.text.trim(),
        country: _country.text.trim(),
        phone: _phone.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Full name',
              border: OutlineInputBorder(),
            ),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _street,
            decoration: const InputDecoration(
              labelText: 'Street address',
              border: OutlineInputBorder(),
            ),
            validator: _required,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _city,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  validator: _required,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _zip,
                  decoration: const InputDecoration(
                    labelText: 'ZIP',
                    border: OutlineInputBorder(),
                  ),
                  validator: _required,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _country,
            decoration: const InputDecoration(
              labelText: 'Country',
              border: OutlineInputBorder(),
            ),
            validator: _required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
            validator: _required,
          ),
        ],
      ),
    );
  }
}
