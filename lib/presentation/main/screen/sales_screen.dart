import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_pos/common/constant/constant.dart';
import 'package:flutter_application_pos/core/core.dart';
import 'package:flutter_application_pos/presentation/main/bloc/bloc.dart';
import 'package:flutter_application_pos/presentation/main/main.dart';
import 'package:flutter_application_pos/presentation/presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/common.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<SalesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late int lengthTab;
  int selectedIndex = 0;
  int loop = 1;
  List<Widget> tabs = [];
  List<ProductEntity> cart = [];
  // List<ProductEntity> productsAll = [];
  List<ProductEntity> productsFood = [];
  List<ProductEntity> productsDrink = [];
  List<ProductEntity> productsSnack = [];
  List<ProductEntity> productsDessert = [];

  @override
  void initState() {
    super.initState();
    context.read<GetCategoriesBloc>().add(FetchCategories());
    _tabController = TabController(length: 4, vsync: this);
    productsFood.clear();
    productsDrink.clear();
    productsSnack.clear();
    productsDessert.clear();
    context.read<GetProductBloc>().add(const FetchProduct());
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final selectedIndex = _tabController.index;
      if (selectedIndex == 0) {
        // Fetch all products
        context.read<GetProductBloc>().add(const FetchProduct());
      } else {
        // Fetch products by category ID
        final categoryId = context.read<GetCategoriesBloc>().state.data![selectedIndex - 1].id;
        context.read<GetProductBloc>().add(FetchProduct(categoryID: categoryId.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1B1B),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            loop = 1;
            productsFood.clear();
            productsDrink.clear();
            productsSnack.clear();
            productsDessert.clear();
            context.read<GetProductBloc>().add(const FetchProduct());
          });
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
          children: [
            Row(
              children: [
                Text(
                  'POS',
                  style: FontsGlobal.mediumTextStyle24.copyWith(color: Colors.white),
                ),
                const Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       cart.clear();
                //       loop = 1;
                //       productsFood.clear();
                //       productsDrink.clear();
                //       productsSnack.clear();
                //       productsDessert.clear();
                //     });
                //     context.read<GetProductBloc>().add(const FetchProduct());
                //   },
                //   child: Text('Update Stok', style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white)),
                // )
              ],
            ),
            const VerticalSeparator(height: 2),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xff141414),
              ),
              padding: const EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff1B1B1B),
                ),
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      child: Text('Makanan', style: FontsGlobal.mediumTextStyle10),
                    ),
                    Tab(
                      child: Text('Minuman', style: FontsGlobal.mediumTextStyle10),
                    ),
                    Tab(
                      child: Text('Snack', style: FontsGlobal.mediumTextStyle10),
                    ),
                    Tab(
                      child: Text('Dessert', style: FontsGlobal.mediumTextStyle10),
                    ),
                  ],
                ),
              ),
            ),
            BlocListener<GetProductBloc, BaseState<List<ProductEntity>>>(
              listener: (context, state) {
                if (state is LoadedState<List<ProductEntity>>) {
                  cart.clear();

                  if (loop == 1) {
                    // setState(() {
                    //   productsAll = state.data!;
                    // });
                    context.read<GetProductBloc>().add(FetchProduct(
                          categoryID: '1',
                        ));
                  } else if (loop == 2) {
                    setState(() {
                      productsFood = state.data!;
                    });
                    context.read<GetProductBloc>().add(FetchProduct(
                          categoryID: '2',
                        ));
                  } else if (loop == 3) {
                    setState(() {
                      productsDrink = state.data!;
                    });
                    context.read<GetProductBloc>().add(FetchProduct(
                          categoryID: '3',
                        ));
                  } else if (loop == 4) {
                    setState(() {
                      productsSnack = state.data!;
                    });
                    context.read<GetProductBloc>().add(FetchProduct(
                          categoryID: '4',
                        ));
                  } else if (loop == 5) {
                    setState(() {
                      productsDessert = state.data!;
                    });
                  }
                  loop++;
                }
              },
              child: Center(
                child: [
                  // widgetGridView(products: productsAll),
                  widgetGridView(products: productsFood),
                  widgetGridView(products: productsDrink),
                  widgetGridView(products: productsSnack),
                  widgetGridView(products: productsDessert),
                ][_tabController.index],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(bottom: 0, left: 16, right: 16),
              decoration: BoxDecoration(
                color: Color(0xFF1FA0C9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rp. ${cart.map((e) => e.price!).reduce((value, element) => value + element).formatRupiah}",
                        style: FontsGlobal.semiBoldTextStyle16.copyWith(color: Colors.white),
                      ),
                      Row(
                        children: [
                          Icon(Icons.shopping_cart, color: Colors.white, size: 16),
                          HorizontalSeparator(width: 1.5),
                          Text("${cart.length} Item", style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const HorizontalSeparator(width: 2),
                  ElevatedButton(
                    onPressed: () {
                      showBottomSheet(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) {
                            // Grouping cart items by id
                            Map<int, Map<String, dynamic>> groupedCart = {};
                            for (var item in cart) {
                              if (groupedCart.containsKey(item.id)) {
                                groupedCart[item.id]!['quantity'] += 1;
                              } else {
                                groupedCart[item.id!] = {'product': item, 'quantity': 1};
                              }
                            }

                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Detail Pesanan', style: FontsGlobal.mediumTextStyle24),
                                      const Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                  const VerticalSeparator(height: 2),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          if (cart.isNotEmpty) ...[
                                            Text(
                                              //Handle error
                                              "Rp. ${cart.map((e) => e.price!).reduce((value, element) => value + element).formatRupiah}",
                                              style: FontsGlobal.boldTextStyle18,
                                            ),
                                          ]
                                        ],
                                      ),
                                      const Spacer(),
                                      MultiBlocListener(
                                        listeners: [
                                          BlocListener<OrderProductBloc, BaseState<String>>(
                                            listener: (context, state) {
                                              if (state is LoadedState<String>) {
                                                int orderID = int.tryParse(state.data!)!;
                                                for (var entry in groupedCart.entries) {
                                                  context.read<OrderItemProductsBloc>().add(
                                                        PostOrderItemProducts(
                                                          productId: entry.value['product'].id!,
                                                          quantity: entry.value['quantity'],
                                                          price: entry.value['product'].price!,
                                                          orderID: orderID,
                                                        ),
                                                      );
                                                  String id = entry.value['product'].id.toString();
                                                  String name = entry.value['product'].name.toString();
                                                  int price = int.tryParse(entry.value['product'].price.toString())!;
                                                  String categoryID = entry.value['product'].categoryId.id.toString();
                                                  String image = entry.value['product'].image.toString();
                                                  int stock = int.tryParse(entry.value['product'].stock.toString())!;
                                                  debugPrint('ID: $id, Name: $name, Price: $price, CategoryID: $categoryID, Image: $image, Stock: $stock');
                                                  debugPrint('Stock sekarang: $stock');

                                                  context.read<UpdateProductStokBloc>().add(
                                                        UpdateProductStok(
                                                          id: int.tryParse(id)!,
                                                          stok: stock,
                                                        ),
                                                      );

                                                  // context.read<UpdateProductBloc>().add(
                                                  //       UpdateProduct(
                                                  //         id: entry.value['product'].id!,
                                                  //         name: entry.value['product'].name!,
                                                  //         price: entry.value['product'].price!,
                                                  //         categoryID: entry.value['product'].categoryID!,
                                                  //         image: entry.value['product'].image!,
                                                  //         stock: entry.value['product'].stock! - entry.value['quantity'],
                                                  //       ),
                                                  //     );
                                                }
                                              }
                                            },
                                          ),
                                          BlocListener<OrderItemProductsBloc, BaseState>(
                                            listener: (context, state) {
                                              if (state is LoadedState) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Pesanan berhasil'),
                                                  ),
                                                );
                                                // Clearing the cart
                                                setState(() {
                                                  Navigator.pop(context);

                                                  loop = 1;
                                                  productsFood.clear();
                                                  productsDrink.clear();
                                                  productsSnack.clear();
                                                  productsDessert.clear();

                                                  context.read<GetProductBloc>().add(const FetchProduct());
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                        child: ElevatedButton(
                                          onPressed: () {
                                            context.read<OrderProductBloc>().add(
                                                  PostOrderProduct(
                                                    amount: cart.map((e) => e.price!).reduce((value, element) => value + element),
                                                  ),
                                                );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF1FA0C9),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          child: Text("Bayar", style: FontsGlobal.semiBoldTextStyle14.copyWith(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Displaying grouped cart items
                                  for (var entry in groupedCart.entries)
                                    ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(entry.value['product'].name!, style: FontsGlobal.mediumTextStyle14),
                                      subtitle: Text('Rp. ${int.tryParse(entry.value['product'].price.toString())!.formatRupiah}', style: FontsGlobal.semiBoldTextStyle16),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove_circle),
                                            onPressed: () {
                                              setState(() {
                                                //Check if cart last item then remove the item and close the bottom sheet
                                                if (cart.length == 1) {
                                                  Navigator.pop(context);
                                                  decreaseQuantity(entry.value['product']);
                                                } else {
                                                  decreaseQuantity(entry.value['product']);
                                                }
                                              });
                                            },
                                          ),
                                          Text('${entry.value['quantity']}'),
                                          IconButton(
                                            icon: Icon(Icons.add_circle_outline),
                                            onPressed: () {
                                              setState(() {
                                                increaseQuantity(entry.value['product']);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Lanjut", style: FontsGlobal.semiBoldTextStyle14.copyWith(color: Color(0xFF1FA0C9))),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  GridView widgetGridView({
    required List<ProductEntity> products,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xff141414),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  "${UrlConstant.baseUrl}/assets/${product.image}",
                  height: SizeConfig.safeBlockVertical * 15,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const VerticalSeparator(height: 2),
              Text(
                "${product.name!} (${product.stock})",
                style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
              ),
              const VerticalSeparator(height: 2),
              Row(
                children: [
                  Text(
                    'Rp. ${product.price!.formatRupiah}',
                    style: FontsGlobal.semiBoldTextStyle14.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (product.stock! > 0) {
                          cart.add(product);
                          debugPrint('Cart: $cart');
                          product.stock = product.stock! - 1;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Stok habis'),
                            ),
                          );
                        }
                      });
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to group cart items
  Map<int, ProductEntity> groupedCartItems(List<ProductEntity> cart) {
    Map<int, ProductEntity> productMap = {};
    Map<int, int> quantityMap = {};

    for (var item in cart) {
      if (productMap.containsKey(item.id)) {
        quantityMap[item.id!] = (quantityMap[item.id] ?? 0) + 1;
      } else {
        productMap[item.id!] = item;
        quantityMap[item.id!] = 1;
      }
    }

    return Map.fromIterables(quantityMap.values, productMap.values);
  }

  // Functions to modify the quantity
// Functions to modify the quantity
  void decreaseQuantity(ProductEntity item) {
    // Removing one instance of the item from the cart
    var existingItemIndex = cart.indexWhere((element) => element.id == item.id);
    if (existingItemIndex != -1) {
      setState(() {
        cart.removeAt(existingItemIndex);
        //kembalikan stock
        item.stock = item.stock! + 1;
      });
    }
  }

  void increaseQuantity(ProductEntity item) {
    // Adding one instance of the item to the cart
    setState(() {
      if (item.stock! > 0) {
        cart.add(item);
        item.stock = item.stock! - 1;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok habis'),
          ),
        );
      }
    });
  }
}
