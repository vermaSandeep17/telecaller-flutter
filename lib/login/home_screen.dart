import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shopify_firebse/responce/get_model_orderList.dart';
import 'package:shopify_firebse/screens/listitemdetail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final Future<FirebaseApp> _future = Firebase.initializeApp();
  final databaseRef = FirebaseDatabase.instance.ref().child('orderlist');

  Query getOrderListQuery() {
    return databaseRef;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: FirebaseAnimatedList(
        query: getOrderListQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          // print(snapshot.value);
          final json = snapshot.value as Map<dynamic, dynamic>;
          final orders = Orders.fromJson(json);

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => ListItemDetailScreen(
                      orderData: orders,
                      orderKey: orders.orderId,
                    )),
              ));
            },
            child: SingleListItem(orders: orders),
          );
        },
      ),
    );
  }
}

class SingleListItem extends StatelessWidget {
  const SingleListItem({
    Key? key,
    required this.orders,
  }) : super(key: key);

  final Orders orders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order id: ${orders.orderId}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'State: ${orders.state}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Total Calls: ${orders.totalCall}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
