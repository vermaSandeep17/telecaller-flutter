import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopify_firebse/responce/get_model_orderList.dart';
import 'package:url_launcher/url_launcher.dart';

class ListItemDetailScreen extends StatefulWidget {
  ListItemDetailScreen({required this.orderData, required this.orderKey});
  static const routeName = '/order-details';

  final Orders orderData;
  final String orderKey;

  @override
  State<ListItemDetailScreen> createState() => _ListItemDetailScreenState();
}

class _ListItemDetailScreenState extends State<ListItemDetailScreen> {
  late Orders orders;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readDB(widget.orderKey);

    //   databaseRef.child(widget.orderKey).onValue.listen((event) {
    //     setState(() {
    //       databasejson = event.snapshot.value.toString();
    //     });
    //   });
  }

  final TextEditingController _employee1TEC = TextEditingController();

  final TextEditingController _employee2TEC = TextEditingController();

  final TextEditingController _employee3TEC = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref().child('orderlist');

  String databasejson = '';
  bool isShow = true;

  _readDB(String id) {
    FirebaseDatabase.instance.ref('orderlist').child(id).once().then((event) {
      final snapShot = event.snapshot;

      setState(() {
        // final databasejson = snapShot.value.toString();

        final json = event.snapshot.value as Map<dynamic, dynamic>;
        orders = Orders.fromJson(json);
        if (orders.totalCall == '') {
          numOfCalls = 0;
        } else {
          numOfCalls = int.parse(orders.totalCall);
        }
        isShow = false;
      });
    });
  }

  String employeeNote = '';

  String employeeName = 'Karan';

  _updateDB(
    String id,
    String keyName,
    String textValue,
    String keyEmployeeName,
    String keyDateTime,
    String callsCount,
  ) {
    setState(() {
      databaseRef.child(id).update({
        keyName: textValue,
        keyEmployeeName: employeeName,
        keyDateTime: DateTime.now().toString(),
        'totalcall': callsCount,
      });
    });
    setState(() {});
  }

  int numOfCalls = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8F1FF),
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: isShow
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardTextItem(
                                  title: 'Name: ${widget.orderData.name}'),
                              CardTextItem(
                                  title: (widget.orderData.totalCall != '')
                                      ? 'Total calls: ${orders.totalCall}'
                                      : 'Total calls: No data'),
                              Row(
                                children: [
                                  Text(
                                    'Phone no.: ${widget.orderData.phone}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      await launch(
                                          "tel: ${widget.orderData.phone}");
                                    },
                                    icon: Icon(
                                      Icons.phone,
                                      color: Theme.of(context).primaryColor,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              CardTextItem(
                                  title: (widget.orderData.email != '')
                                      ? 'Email: ${widget.orderData.email}'
                                      : 'Email: Email not filled'),
                              CardTextItem(
                                  title: 'State: ${widget.orderData.state}'),
                              CardTextItem(
                                  title:
                                      'Order Status: ${widget.orderData.orderStatus}'),
                              CardTextItem(
                                  title: (widget.orderData.confirmationStatus !=
                                          '')
                                      ? 'Order Confirmation: ${widget.orderData.confirmationStatus}'
                                      : 'Order Confirmation: No Status'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    EmployeeCard(
                      note: orders.call1Note,
                      name: orders.call1EmpName,
                      employeeTEC: _employee1TEC,
                      onTapHandler: () {
                        numOfCalls++;
                        _updateDB(
                          widget.orderData.orderId,
                          'call1note',
                          _employee1TEC.text,
                          'call1_empname',
                          'call1datetime',
                          numOfCalls.toString(),
                        );
                        _readDB(widget.orderKey);
                      },
                    ),
                    const Divider(),
                    EmployeeCard(
                      note: orders.call2Note,
                      name: orders.call2EmpName,
                      employeeTEC: _employee2TEC,
                      onTapHandler: () {
                        numOfCalls++;
                        _updateDB(
                          widget.orderData.orderId,
                          'call2note',
                          _employee2TEC.text,
                          'call2_empname',
                          'call2datetime',
                          numOfCalls.toString(),
                        );
                        _readDB(widget.orderKey);
                      },
                    ),
                    const Divider(),
                    EmployeeCard(
                      note: orders.call3Note,
                      name: orders.call3EmpName,
                      employeeTEC: _employee3TEC,
                      onTapHandler: () {
                        numOfCalls++;
                        _updateDB(
                          widget.orderData.orderId,
                          'call3note',
                          _employee3TEC.text,
                          'call3_empname',
                          'call3datetime',
                          numOfCalls.toString(),
                        );
                        _readDB(widget.orderKey);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    required this.name,
    required this.note,
    required this.employeeTEC,
    required this.onTapHandler,
  });

  final String name;
  final String note;
  final TextEditingController employeeTEC;
  final void Function() onTapHandler;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTextItem(title: 'Employee name: $name'),
              CardTextItem(title: 'Employee note: $note'),
              TextField(
                maxLines: 1,
                maxLength: 100,
                controller: employeeTEC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => employeeTEC.text = value,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: onTapHandler,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(10.0),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardTextItem extends StatelessWidget {
  const CardTextItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
