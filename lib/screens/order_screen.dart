import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Order>(context).fetchAndSetOreders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text("An Error"),
                );
              } else {
                return Consumer<Order>(builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) => OrderItem(
                      orderItems: orderData.orders[index],
                    ),
                    itemCount: orderData.orders.length,
                  );
                });
              }
            }
          }),
    );
  }
}
