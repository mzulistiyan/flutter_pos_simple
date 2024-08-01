part of 'update_product_stok_bloc.dart';

abstract class UpdateProductStokEvent extends Equatable {
  const UpdateProductStokEvent();

  @override
  List<Object> get props => [];
}

// Event untuk mengupdate stok produk
class UpdateProductStok extends UpdateProductStokEvent {
  final int id;
  final int stok;

  UpdateProductStok({required this.id, required this.stok});

  @override
  List<Object> get props => [id, stok];
}
