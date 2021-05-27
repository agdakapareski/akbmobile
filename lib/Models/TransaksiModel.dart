class TransaksiModel {
  String nama_customer, nama_pegawai, nama_pemilik_kartu, kode_verifikasi, total_transaksi, status_transaksi;

  TransaksiModel({this.nama_customer, this.nama_pegawai, this.nama_pemilik_kartu, this.kode_verifikasi, this.total_transaksi, this.status_transaksi});

  factory TransaksiModel.fromJson(Map<String, dynamic> json) => TransaksiModel (
    nama_customer: json["nama_customer"],
    nama_pegawai: json["nama_pegawai"],
    nama_pemilik_kartu: json["nama_pemilik_kartu"],
    kode_verifikasi: json["kode_verivikasi"],
    total_transaksi: json["total_transaksi"],
    status_transaksi: json["status_transaksi"]
  );

  Map<String, dynamic> toJson() => {
    "nama_customer": nama_customer,
    "nama_pegawai": nama_pegawai,
    "nama_pemilik_kartu": nama_pemilik_kartu,
    "kode_verifikasi": kode_verifikasi,
    "total_transaksi": total_transaksi,
    "status_transaksi": status_transaksi
  };
}