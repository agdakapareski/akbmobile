import 'package:akb/Models/OrderModel.dart';
import 'package:akb/Transaksi.dart';
import 'package:flutter/material.dart';
import 'Models/MenuModels.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:akb/Utils/Dialogs.dart';

class PesanMenu extends StatefulWidget {
  @override
  _PesanMenuState createState() => _PesanMenuState();
}

class _PesanMenuState extends State<PesanMenu> {
  TextEditingController _jumlahController = TextEditingController();
  int _jumlah = 0;
  // ignore: deprecated_member_use
  List<Data> _datas = List<Data>();
  // ignore: deprecated_member_use
  List<Data> _datasForDisplay = List<Data>();
  List<Order> _order = List<Order>();
  OrderModel _orderModel;
  String qrCode = '';
  int status = 0;

  //fungsi scan QR
  Future<void> scanQr() async {
    try {
      final status = 1;
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff0000', 'Kembali', true, ScanMode.QR);

      if (!mounted) return this.status = 0;

      setState(() {
        this.status = status;
        this.qrCode = qrCode;
        // Route route = MaterialPageRoute(builder: (context) => PesanMenu());
        // Navigator.push(context, route);
      });
    } on PlatformException {
      this.status = 0;
      Navigator.pop(context);
    }
  }

  //fungsi get menu dari API
  Future<List<Data>> fetchData() async {
    var url = 'http://192.168.1.6:8000/api/menuMobile1';
    var response = await http.get(Uri.parse(url));

    // ignore: deprecated_member_use
    var datas = List<Data>();

    if (response.statusCode == 200) {
      var datasJson = json.decode(response.body);
      for (var dataJson in datasJson) {
        datas.add(Data.fromJson(dataJson));
      }
    }

    return datas;
  }

  //fungsi post order(pesanan) ke API
  Future<OrderModel> createOrder(
      String nama_customer,
      String nama_menu,
      String harga,
      String jumlah_pesanan,
      String subtotal,
      String status_pesanan) async {
    var url = Uri.parse('http://192.168.1.6:8000/api/pesananMobile');
    final response = await http.post(url, body: {
      "nama_customer": nama_customer,
      "nama_menu": nama_menu,
      "harga": harga,
      "jumlah_pesanan": jumlah_pesanan,
      "subtotal": subtotal,
      "status_pesanan": status_pesanan
    });
    return OrderModel.fromJson(json.decode(response.body));
  }

  //fungsi init data dari API
  @override
  void initState() {
    fetchData().then((value) {
      setState(() {
        _datas.addAll(value);
        _datasForDisplay = _datas;
      });
    });

    _jumlahController.text = "1";
    super.initState();
  }

  //halaman menu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text("Daftar Menu"),
        leading: IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () => status == 0
                ? scanQr()
                : createAlertDialog(context, "Sudah scan :)")),
        actions: [
          IconButton(
              icon: Icon(Icons.assignment),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => Transaksi(qrCode));
                status == 1
                    ? Navigator.push(context, route)
                    : createAlertDialog(context, "Scan Qr terlebih dahulu");
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (context, i) {
            return i == 0 ? _searchBar() : _listItem(i - 1);
          },
          itemCount: _datasForDisplay.length + 1,
        ),
      ),
    );
  }

  //fungsi & tampilan search
  _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _datasForDisplay = _datas.where((data) {
              var dataTitle = data.nama_menu.toLowerCase();
              return dataTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  //list item dari halaman menu
  _listItem(i) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _datasForDisplay[i].nama_menu,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _datasForDisplay[i].kategori_menu,
                          style: TextStyle(color: Colors.orange),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _datasForDisplay[i].deskripsi_menu,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      "images/akb-logo-full.png",
                      height: 85,
                      width: 85,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Rp. " + _datasForDisplay[i].harga.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () {
                                if (status == 0) {
                                  createAlertDialog(
                                      context, "Scan Qr terlebih dahulu");
                                } else if (status == 1) {
                                  createDialogOrder(context, i);
                                }
                              },
                              child: Text("Order"),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orange),
                              )),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ],
          )),
    );
  }

  //dialog order
  createDialogOrder(BuildContext context, i) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("customer: $qrCode"),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Nama menu : " + _datasForDisplay[i].nama_menu)
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Harga            : " +
                          _datasForDisplay[i].harga.toString())
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _jumlahController,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: false, signed: false),
                        inputFormatters: <TextInputFormatter>[
                          // ignore: deprecated_member_use
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 3.0,
                          child: Icon(Icons.remove_circle),
                          onPressed: () {
                            int currentValue =
                                int.parse(_jumlahController.text);
                            setState(() {
                              if (_jumlahController.text != "1") {
                                currentValue--;
                              }
                              _jumlahController.text = (currentValue)
                                  .toString(); // incrementing value
                            });
                          },
                        ),
                        MaterialButton(
                          minWidth: 3.0,
                          child: Icon(Icons.add_circle),
                          onPressed: () {
                            int currentValue =
                                int.parse(_jumlahController.text);
                            setState(() {
                              print("Setting state");
                              currentValue++;
                              _jumlahController.text = (currentValue)
                                  .toString(); // decrementing value
                            });
                          },
                        ),
                      ],
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                        child: Text(
                          "Batal",
                          style: TextStyle(color: Colors.orange),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: ElevatedButton(
                        child: Text("Pesan"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.orange)),
                        onPressed: () async {
                          final String nama_customer = qrCode;
                          final String nama_menu =
                              _datasForDisplay[i].nama_menu;
                          final String harga =
                              _datasForDisplay[i].harga.toString();
                          final String jumlah_pesanan = _jumlahController.text;
                          int subtotal = int.parse(_jumlahController.text) *
                              _datasForDisplay[i].harga;
                          final String totalPesanan = subtotal.toString();
                          final String status_pesanan = "Sedang Disiapkan";
                          final OrderModel orderModel = await createOrder(
                              nama_customer,
                              nama_menu,
                              harga,
                              jumlah_pesanan,
                              totalPesanan,
                              status_pesanan);
                          setState(() {
                            _orderModel = orderModel;
                            _jumlahController.text = "1";
                          });
                          Navigator.pop(context);
                        },
                      )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
