import 'package:akb/HalamanUtama.dart';
import 'package:akb/Utils/Dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:akb/Models/OrderModel.dart';
import 'package:akb/Models/TransaksiModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';

class Transaksi extends StatefulWidget {
  final String nama;
  const Transaksi(this.nama);
  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  // ignore: deprecated_member_use
  List<Order> _order = List<Order>();
  TransaksiModel _transaksiModel;

  Future<dynamic> getTotal() async {
    final response = await http.get(Uri.parse('http://192.168.1.8:8000/api/totalMobile/' + widget.nama));
    final total = response.body;

    return total;
  }

  Future<List<Order>> fetchOrder() async {
    var url = 'http://192.168.1.8:8000/api/pesananMobile/' + widget.nama;
    var response = await http.get(Uri.parse(url));

    // ignore: deprecated_member_use
    var orders = List<Order>();

    if (response.statusCode == 200) {
      var ordersJson = json.decode(response.body);
      for (var orderJson in ordersJson) {
        orders.add(Order.fromJson(orderJson));
      }
    }

    return orders;
  }

  Future<TransaksiModel> createTransaksi(String nama_customer, String total_transaksi, String status_transaksi) async {
    var url = Uri.parse('http://192.168.1.8:8000/api/transaksiMobile');
    final response = await http.post(
        url,
        body: {
          "nama_customer": nama_customer,
          "total_transaksi": total_transaksi,
          "status_transaksi": status_transaksi
        }
    );
    return TransaksiModel.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    fetchOrder().then((value) {
      setState(() {
        _order.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        title: Text("Transaksi"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Card(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            "images/akb-logo-full.png",
                            height: 100,
                            width: 100,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("ATMA KOREAN BBQ", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                                Text("FUN PLACE TO GRILL", style: TextStyle(fontSize: 12),),
                                SizedBox(height: 10,),
                                Text("Jl. Babarsari No. 42, Yogyakarta", style: TextStyle(fontSize: 11),),
                                Text("552181", style: TextStyle(fontSize: 11),),
                                Text("Telp. (0274) 487711", style: TextStyle(fontSize: 11),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
              ),
              Divider(
                indent: 13,
                endIndent: 13,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Customer : "),
                    Text(widget.nama)
                  ],
                ),
              ),
              Divider(
                indent: 13,
                endIndent: 13,
                color: Colors.black,
              ),
              SizedBox(height: 5,),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _order.length,
                itemBuilder: (BuildContext context, int i) {
                  return _listOrder(i);
                },
              ),
              Divider(
                indent: 13,
                endIndent: 13,
                color: Colors.black,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    children: <Widget>[
                      FutureBuilder<dynamic>(
                        future: getTotal(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if(snapshot.hasData) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Total : ",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            "Rp. " + snapshot.data,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    ],
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(13, 10, 13, 20),
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    children: <Widget>[
                      FutureBuilder<dynamic>(
                        future: getTotal(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final String nama_customer = widget.nama;
                                        final String total_transaksi = snapshot.data.toString();
                                        final String status_transaksi = "Belum Lunas";
                                        setState(() async {
                                          if(_order.length == 0) {
                                            createAlertDialog(context, "Order terlebih dahulu");
                                          } else {
                                            final TransaksiModel transaksiModel = await createTransaksi(nama_customer, total_transaksi, status_transaksi);
                                            _transaksiModel = transaksiModel;
                                            Navigator.of(context).pushNamedAndRemoveUntil('halamanUtama', (route) => false);
                                          }
                                        });
                                      },
                                      child: Text("Check Out"),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      )
    );
  }

  _listOrder(i) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(_order[i].nama_menu,)
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(_order[i].jumlah_pesanan.toString() + " x " + "Rp. " + _order[i].harga.toString()),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Rp. " + _order[i].subtotal.toString())
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}