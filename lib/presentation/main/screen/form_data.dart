import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_pos/presentation/main/main.dart';
import 'package:flutter_application_pos/presentation/presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../common/common.dart';

class FormDataScreen extends StatefulWidget {
  final String? name;
  final int? price;
  final int? stock;
  final String? categoryID;
  final String? image;
  final String? id;

  const FormDataScreen({
    super.key,
    this.name,
    this.price,
    this.stock,
    this.categoryID,
    this.image,
    this.id,
  });

  @override
  State<FormDataScreen> createState() => _FormDataScreenState();
}

class _FormDataScreenState extends State<FormDataScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  int getPriceValue() {
    String text = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(text) ?? 0;
  }

  int getStockValue() {
    return int.tryParse(_stockController.text) ?? 0;
  }

  String formatCurrency(int value) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(value);
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Makanan"), value: "1"),
      DropdownMenuItem(child: Text("Minuman"), value: "2"),
      DropdownMenuItem(child: Text("Snack"), value: "3"),
      DropdownMenuItem(child: Text("Dessert"), value: "4"),
    ];
    return menuItems;
  }

//get value from dropdown
  String? dropdownValue;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with values from widget if available
    _nameController.text = widget.name ?? '';
    _priceController.text = widget.price != null ? formatCurrency(widget.price!) : 'Rp ';
    _stockController.text = widget.stock?.toString() ?? '';
    dropdownValue = widget.categoryID;

    // Initialize the price controller with a listener to format the input as Rupiah
    _priceController.addListener(() {
      final text = _priceController.text;
      if (text.isEmpty) return;
      final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
      if (numericString.isEmpty) {
        _priceController.value = TextEditingValue(
          text: 'Rp ',
          selection: TextSelection.collapsed(offset: 3),
        );
        return;
      }

      final value = int.parse(numericString);
      final formattedText = formatCurrency(value);
      _priceController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B1B1B),
      appBar: AppBar(
        backgroundColor: Color(0xff1B1B1B),
        title: Text(
          widget.id == null ? 'Tambah Produk' : 'Ubah Produk',
          style: FontsGlobal.mediumTextStyle16.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (widget.id != null) ...[
            BlocConsumer<DeleteProductBloc, BaseState>(
              listener: (context, state) {
                if (state is SuccessState) {
                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produk berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //Dialog confirmation
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Hapus Produk'),
                          content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<DeleteProductBloc>().add(
                                      DeleteProduct(
                                        id: int.parse(widget.id!),
                                      ),
                                    );
                                Navigator.pop(context);
                              },
                              child: Text('Hapus'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ]
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.image != null && _image == null) ...[
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: SizeConfig.safeBlockHorizontal * 50,
                      height: SizeConfig.safeBlockHorizontal * 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                        image: DecorationImage(
                          image: NetworkImage("${UrlConstant.baseUrl}/assets/${widget.image}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      //centered close icon
                      right: 10,
                      top: 10,

                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: InkWell(
                          onTap: () {
                            getImageFromGallery();
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              if (_image == null) ...[
                Center(
                  child: InkWell(
                    onTap: getImageFromGallery,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          const VerticalSeparator(height: 0.5),
                          Text(
                            'Tambah\nFoto',
                            textAlign: TextAlign.center,
                            style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: SizeConfig.safeBlockHorizontal * 50,
                        height: SizeConfig.safeBlockHorizontal * 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            width: 2,
                            color: Colors.white,
                          ),
                          image: DecorationImage(
                            image: FileImage(File(_image!.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            const VerticalSeparator(height: 2),
            Text('Nama Produk', style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white)),
            const VerticalSeparator(height: 2),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama produk',
                hintStyle: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Color(0xff141414),
                filled: true,
              ),
              style: TextStyle(color: Colors.white),
            ),
            const VerticalSeparator(height: 2),
            Text('Harga', style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white)),
            const VerticalSeparator(height: 2),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan harga produk',
                hintStyle: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Color(0xff141414),
                filled: true,
              ),
              style: TextStyle(color: Colors.white),
            ),
            const VerticalSeparator(height: 2),
            Text('Stok', style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white)),
            const VerticalSeparator(height: 2),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Masukkan stok produk',
                      hintStyle: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fillColor: Color(0xff141414),
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        int currentValue = getStockValue();
                        setState(() {
                          _stockController.text = (currentValue + 1).toString();
                        });
                      },
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        int currentValue = getStockValue();
                        if (currentValue > 0) {
                          setState(() {
                            _stockController.text = (currentValue - 1).toString();
                          });
                        }
                      },
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const VerticalSeparator(height: 2),
            Text('Kategori', style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white)),
            const VerticalSeparator(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Color(0xff141414),
                  items: dropdownItems,
                  value: dropdownValue,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value;
                    });
                  },
                  hint: Text(
                    'Pilih kategori',
                    style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
                  ),
                  style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MultiBlocListener(
        listeners: [
          BlocListener<UploadFileBloc, BaseState<String>>(
            listener: (context, state) {
              if (state is LoadedState) {
                // Do something with the uploaded file
                debugPrint('Image uploaded: ${state.data}');
                if (widget.id == null) {
                  final String name = _nameController.text;
                  final int price = getPriceValue();
                  final int stock = getStockValue();
                  context.read<PostProductBloc>().add(
                        PostProduct(
                          name: name,
                          stock: stock,
                          price: price,
                          categoryID: dropdownValue!,
                          image: state.data!,
                        ),
                      );
                } else {
                  final String name = _nameController.text;
                  final int price = getPriceValue();
                  final int stock = getStockValue();
                  context.read<UpdateProductBloc>().add(
                        UpdateProduct(
                          id: widget.id!,
                          name: name,
                          stock: stock,
                          price: price,
                          categoryID: dropdownValue!,
                          image: state.data!,
                        ),
                      );
                }
              }
            },
          ),
          BlocListener<PostProductBloc, BaseState>(
            listener: (context, state) {
              if (state is LoadedState) {
                // Handle success logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Produk berhasil ditambahkan'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context, true);
              } else if (state is ErrorState) {
                // Handle error logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<UpdateProductBloc, BaseState>(
            listener: (context, state) {
              if (state is LoadedState) {
                // Handle success logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Produk berhasil diubah'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context, true);
              } else if (state is ErrorState) {
                // Handle error logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Color(0xff141414),
          child: ElevatedButton(
            onPressed: () {
              // Do something with name, price, and stock
              if (widget.id == null) {
                if (_image != null) {
                  //Validation for empty field
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Nama produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (getPriceValue() == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Harga produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (_stockController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Stok produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (dropdownValue == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kategori produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    context.read<UploadFileBloc>().add(
                          UploadFile(
                            filePath: _image!.path,
                            fileName: 'image_${_nameController.text}.png',
                          ),
                        );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Silahkan pilih gambar terlebih dahulu'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                if (_image != null) {
                  //Validation for empty field
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Nama produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (getPriceValue() == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Harga produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (_stockController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Stok produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (dropdownValue == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kategori produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    context.read<UploadFileBloc>().add(
                          UploadFile(
                            filePath: _image!.path,
                            fileName: 'image_${_nameController.text}.png',
                          ),
                        );
                  }
                } else {
                  //validation for empty field
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Nama produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (getPriceValue() == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Harga produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (_stockController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Stok produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (dropdownValue == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kategori produk tidak boleh kosong'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    final String name = _nameController.text;
                    final int price = getPriceValue();
                    final int stock = getStockValue();
                    context.read<UpdateProductBloc>().add(
                          UpdateProduct(
                            id: widget.id!,
                            name: name,
                            stock: stock,
                            price: price,
                            categoryID: dropdownValue!,
                            image: widget.image!,
                          ),
                        );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.id == null ? 'Tambah Produk' : 'Ubah Produk',
              style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
