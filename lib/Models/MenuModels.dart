class Data {
  String nama_menu, kategori_menu, deskripsi_menu;
  int harga;

  Data(this.nama_menu, this.kategori_menu, this.deskripsi_menu, this.harga);

  Data.fromJson(Map<String, dynamic> json) {
    nama_menu = json['nama_menu'];
    kategori_menu = json['kategori_menu'];
    deskripsi_menu = json['deskripsi_menu'];
    harga = json['harga'];
  }
}
