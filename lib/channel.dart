import 'controller/cart_controller.dart';
import 'dart_backend.dart';

class DartBackendChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final dbConfig = CartConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      dbConfig.database.username,
      dbConfig.database.password,
      dbConfig.database.host,
      dbConfig.database.port,
      dbConfig.database.databaseName,
    );
    context = ManagedContext(dataModel, persistentStore);
  }

  @override
  Controller get entryPoint {
    final router = Router();

//    router.route("/").link(() => CartController(context));

    router.route("cart/[:id]").link(() => CartController(context));
    router.route("books").link(() => CartController(context));

    return router;
  }
}

class CartConfig extends Configuration {
  CartConfig(String path) : super.fromFile(File(path));
  DatabaseConfiguration database;
}
