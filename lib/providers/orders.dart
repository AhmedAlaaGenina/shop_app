import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/widgets/cart_item.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime dateTime;

  OrderItems({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOreders() async {
    final url = Uri.https(
        'flutter-shop-app-1fd41-default-rtdb.firebaseio.com', '/orders.json');
    final List<OrderItems> loadedOrders = [];
    final response = await http.get(url);
    final extarctData = json.decode(response.body) as Map<String, dynamic>;
    if (extarctData == null) {
      return;
    }
    extarctData.forEach((key, value) {
      loadedOrders.add(
        OrderItems(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map((e) => CartItems(
                    id: e['id'],
                    quantity: e['quantity'],
                    price: e['price'],
                    title: e['title'],
                  ))
              .toList(),
          dateTime: DateTime.parse(value['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItems> cartProducts, double total) async {
    final url = Uri.https(
        'flutter-shop-app-1fd41-default-rtdb.firebaseio.com', '/orders.json');
    final timesTamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timesTamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItems(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
