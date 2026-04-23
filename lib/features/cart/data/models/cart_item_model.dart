import 'package:hive/hive.dart';

import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.productId,
    required super.title,
    required super.price,
    required super.image,
    required super.quantity,
  });

  factory CartItemModel.fromEntity(CartItem item) {
    if (item is CartItemModel) return item;
    return CartItemModel(
      productId: item.productId,
      title: item.title,
      price: item.price,
      image: item.image,
      quantity: item.quantity,
    );
  }

  @override
  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      productId: productId,
      title: title,
      price: price,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartItemAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 1;

  @override
  CartItemModel read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      productId: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as double,
      image: fields[3] as String,
      quantity: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.quantity);
  }
}
