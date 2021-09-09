import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration1 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable("_CartItem", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("bookName", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: true),
      SchemaColumn("author", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("pages", ManagedPropertyType.integer,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final items = [
      {"bookName": "vilian00", "author": "martin john ", "pages": 150},
      {"bookName": "vilian01", "author": "martin lye", "pages": 150},
      {"bookName": "vilian02", "author": "martin ke", "pages": 140},
    ];
    for (final item in items) {
      await database.store.execute(
          'insert into _CartItem(bookName,author,pages) values(@bookName,@author,@pages)',
          substitutionValues: {
            'bookName': item['bookName'],
            'author': item['author'],
            'pages': item['pages'],
          });
    }
  }
}
