import 'dart:convert';

class Order {
  int id_detail_transaksi;
  String nama_customer, nama_menu;
  int harga, jumlah_pesanan, subtotal;
  String status_pesanan;

  Order(this.id_detail_transaksi, this.nama_customer, this.nama_menu, this.jumlah_pesanan,this.harga, this.subtotal, this.status_pesanan);

  Order.fromJson(Map<String, dynamic> json) {
    id_detail_transaksi = json["id_detail_transaksi"];
    nama_customer = json["nama_customer"];
    nama_menu = json["nama_menu"];
    harga = json["harga"];
    jumlah_pesanan = json["jumlah_pesanan"];
    subtotal = json["subtotal"];
    status_pesanan = json["status_pesanan"];
  }
}

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));
String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String nama_customer, nama_menu;
  String harga, jumlah_pesanan, subtotal;
  String status_pesanan;

  OrderModel({this.nama_customer, this.nama_menu, this.jumlah_pesanan,this.harga, this.subtotal, this.status_pesanan});

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel (
      nama_customer: json["nama_customer"],
      nama_menu: json["nama_menu"],
      harga: json["harga"],
      jumlah_pesanan: json["jumlah_pesanan"],
      subtotal: json["subtotal"],
      status_pesanan: json["status_pesanan"]
  );

  Map<String, dynamic> toJson() => {
    "nama_customer": nama_customer,
    "nama_menu": nama_menu,
    "harga": harga,
    "jumlah_pesanan": jumlah_pesanan,
    "subtotal": subtotal,
    "status_pesanan": status_pesanan
  };
}