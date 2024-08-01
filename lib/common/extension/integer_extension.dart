extension IntegerExtension on int {
  // Metode untuk mengubah integer ke format Rupiah
  String get formatRupiah {
    return '${toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.')}';
  }

  int get calculateInterval {
    if (this <= 25) return 5;
    if (this <= 50) return 10;
    if (this <= 100) return 20;
    return ((this / 25).ceil()) * 5;
  }

  int get roundUpMax {
    int remainder = this % calculateInterval;
    if (remainder == 0) {
      return this;
    }
    return this + calculateInterval - remainder;
  }
}
