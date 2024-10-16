import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shop_sqlites/shop_database.dart';

import 'models.dart';

class ProductsList extends StatelessWidget {
  var products = [
    Product(1, "Joyita", "Licor suave y buen precio", 780,"https://tienda505.com/wp-content/uploads/2020/09/862NI2675L24.png"),
    Product(2, "Gran Reserva", "Ron Añejado", 1500, "https://walmartni.vtexassets.com/arquivos/ids/217541/Ron-Flor-De-Ca-a-Gran-Reserva-De-7-A-os-1750ml-1-599.jpg?v=637891230665830000"),
    Product(3, "Toña", "Como mi Toña ninguna", 235, "https://walmartni.vtexassets.com/arquivos/ids/355918/6-Pack-De-Cerveza-Tona-De-Botella-350ml-2-2825.jpg?v=638423664934300000"),
    Product(4, "Jonie Waker", "Ron de Calidad", 12600, "https://walmartni.vtexassets.com/arquivos/ids/412062/5047_01.jpg?v=638554560154900000")
  ];

  ProductsList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              color: Colors.blue[300],
              child: _ProductItem(products[index]),
            ),
            onTap: () async {
              await addToCart(products[index]);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Producto agregado al carrito!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
              height: 5,
            ),
        itemCount: products.length);
  }

  Future<void> addToCart(Product product) async {
    final item = CartItem(
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
    );
    await ShopDatabase.instance.insert(item);
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Image.network(
              product.url,
            width: 100,
          ),
          const Padding(padding: EdgeInsets.only(right: 3, left: 3)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name),
              Text(product.description),
              Text("\$${product.price}"),
            ],
          )
        ],
      ),
    );
  }
}
