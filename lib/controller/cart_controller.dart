import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:dart_backend/model/cart_item.dart';

class CartController extends ResourceController {
  CartController(this.context);

  final ManagedContext context;

  // get  all items
  @Operation.get()
  Future<Response> getCartItems({@Bind.query("pages") int pages}) async {
    final query = Query<CartItem>(context);
    if (pages != null) {
      query.where((item) => item.pages).equalTo(pages);
    }
    final items = await query.fetch();
    return Response.ok(items);
  }

  // get item by index
  @Operation.get("id")
  Future<Response> getCartItemById(@Bind.path('id') int id) async {
    try {
      final query = Query<CartItem>(context)
        ..where((item) => item.id).equalTo(id);
      final item = await query.fetchOne();
      if (item == null) {
        return Response.notFound();
      }

      return Response.ok(item);
    } catch (_) {
      return Response.noContent();
    }
  }

  // create new item
  @Operation.post()
  Future<Response> createItem(@Bind.body(ignore: ['id']) CartItem item) async {
    final query = Query<CartItem>(context)..values = item;
    await query.insert();
    return Response.ok({"status": "ok"});
  }

  // update an item
  @Operation.put("id")
  Future<Response> updateItem(
      @Bind.path('id') int id, @Bind.body(ignore: ['id']) CartItem item) async {
    // update values where  id equal to  id from path
    final query = Query<CartItem>(context)
      ..where((item) => item.id).equalTo(id)
      ..values = item;
    if (await query.fetchOne() == null) {
      return Response.notFound();
    }
    // updateOne & update return the data
    // if you want it store it in a variable ,then send it in response
    await query.updateOne();

    return Response.ok({"status": "ok"});
  }

  //  delete an item
  @Operation.delete('id')
  Future<Response> deleteItem(@Bind.path('id') int id) async {
    final query = Query<CartItem>(context)
      ..where((item) => item.id).equalTo(id);
    final deleteStatus = await query.delete();
    if (deleteStatus == 0) {
      return Response.notFound(body: {"status": "error ,item not exist"});
    }

    return Response.ok({"status": "ok"});
  }
}
