import 'package:hive/hive.dart';

import '../../domain/entities/wishlist_item.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.productId,
    required super.title,
    required super.price,
    required super.image,
  });

  factory WishlistItemModel.fromEntity(WishlistItem item) {
    if (item is WishlistItemModel) return item;
    return WishlistItemModel(
      productId: item.productId,
      title: item.title,
      price: item.price,
      image: item.image,
    );
  }
}

class WishlistItemAdapter extends TypeAdapter<WishlistItemModel> {
  @override
  final int typeId = 2;

  @override
  WishlistItemModel read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    return WishlistItemModel(
      productId: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as double,
      image: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItemModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.image);
  }
}
