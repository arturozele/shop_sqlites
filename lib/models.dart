import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String url;

  Product(this.id, this.name, this.description, this.price, this.url);
}

class CartItem {
  final int id;
  final String name;
  final int price;
  int quantity;
 

  CartItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity
      , });

   get totalPrice {
    return quantity * price; // Precio total sin IVA
  }

   get totalPriceWithIVA {
    return totalPrice * 0.15; // Precio total con el 15% de IVA
  }
  
   get totalAPagar {
    return totalPrice + totalPriceWithIVA; // Total a pagar: subtotal + IVA
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      //'url': url
    };
  }
}
