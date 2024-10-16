import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sqlites/notifier.dart';
import 'package:shop_sqlites/shop_database.dart';
import 'package:shop_sqlites/models.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifier>(
      builder: (context, cart, child) {
        return FutureBuilder(
            future: ShopDatabase.instance.getAllItems(),
            builder:
                (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
              if (snapshot.hasData) {
                List<CartItem> cartItems = snapshot.data!;
                return cartItems.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay productos en tu carrito",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              color: const Color.fromARGB(255, 33, 149, 226),
                              child: _CartItem(cartItems[index]));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              height: 10,
                            ),
                        itemCount: cartItems.length);
              } else {
                return const Center(
                  child: Text(
                    "No hay productos en tu carrito",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            });
      },
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItem cartItem;

  const _CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 248, 248, 248)),
        child: Row(
          children: [
            Image.network(
              'https://walmartni.vtexassets.com/arquivos/ids/412062/5047_01.jpg?v=638554560154900000',
              width: 100,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(cartItem.name),
                  Text("\$${cartItem.price}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("${cartItem.quantity} unidades"),
                      ElevatedButton(
                        onPressed: () async {
                          cartItem.quantity++;
                          await ShopDatabase.instance.update(cartItem);
                          Provider.of<CartNotifier>(context, listen: false)
                              .shouldRefresh();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          backgroundColor: Colors.green[300],
                          minimumSize: Size.zero,
                        ),
                        child: const Text("+"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          cartItem.quantity--;
                          if (cartItem.quantity == 0) {
                            await ShopDatabase.instance.delete(cartItem.id);
                          } else {
                            await ShopDatabase.instance.update(cartItem);
                          }
                          // ignore: use_build_context_synchronously
                          Provider.of<CartNotifier>(context, listen: false)
                              .shouldRefresh();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(9),
                          backgroundColor: Colors.green[300],
                          minimumSize: Size.zero,
                        ),
                        child: const Text("-"),
                      )
                    ],
                  ),
                  Text("SubTotal: \$${cartItem.totalPrice}"),// Precio total sin IVA
                  Text("IVA: \$${cartItem.totalPriceWithIVA}"),// Precio total con el 15% de IVA
                  Text("Total: \$${cartItem.totalAPagar}"),// Total a pagar: subtotal + IVA
                  ElevatedButton(
                    onPressed: () async {
                      await ShopDatabase.instance.delete(cartItem.id);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Producto eliminado!"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      // ignore: use_build_context_synchronously
                      Provider.of<CartNotifier>(context, listen: false)
                          .shouldRefresh();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 236, 60, 60)),
                    child: const Text("Eliminar"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
