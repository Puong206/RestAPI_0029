class HewanModel {
  final int id;
  final String nama;
  final String jenis;
  final String tanggalLahir;
  final int harga;
  final String status;

  HewanModel({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggalLahir,
    required this.harga,
    required this.status,
  });

  factory HewanModel.fromJson(Map<String, dynamic> json) {
    return HewanModel(
      id: json['id'] as int,
      nama: json['nama'] as String? ?? 'Tidak ada nama',
      jenis: json['jenis'] as String? ?? 'Tidak ada jenis',
      tanggalLahir: json['tanggalLahir'] as String? ?? '-',
      harga: json['harga'] as int? ?? 0,
      status: json['status'] as String? ?? 'Tidak ada status',
    );
  }
}