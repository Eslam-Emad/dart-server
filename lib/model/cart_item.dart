import '../dart_backend.dart';

class CartItem extends ManagedObject<_CartItem> implements _CartItem {}

class _CartItem {
  // columns
  @primaryKey
  int id;
  @Column(unique: true)
  String bookName;
  String author;
  int pages;
}
