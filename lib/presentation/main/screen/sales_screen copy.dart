import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_pos/common/constant/constant.dart';
import 'package:flutter_application_pos/core/core.dart';
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
          context.read<GetCategoriesBloc>().add(FetchCategories());
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cart.clear();
                      loop = 1;
                      productsFood.clear();
                      productsDrink.clear();
                      productsSnack.clear();
                      productsDessert.clear();
                    });
                    context.read<GetProductBloc>().add(const FetchProduct());
                  },
                  child: Text('Update Stok', style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white)),
                )
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

            // BlocBuilder<GetProductBloc, BaseState<List<ProductEntity>>>(
            //   builder: (context, productState) {
            //     if (productState is LoadedState<List<ProductEntity>>) {
            //       // return ListView.builder(
            //       //   itemCount: productState.data!.length,
            //       //   itemBuilder: (context, index) {
            //       //     final product = productState.data![index];
            //       //     return ListTile(
            //       //       title: Text(product.name!, style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white)),
            //       //     );
            //       //   },
            //       // );
            //       return GridView.builder(
            //         shrinkWrap: true,
            //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 2,
            //           crossAxisSpacing: 8,
            //           mainAxisSpacing: 8,
            //           childAspectRatio: 0.85,
            //         ),
            //         itemCount: productState.data!.length,
            //         itemBuilder: (context, index) {
            //           final product = productState.data![index];
            //           return Container(
            //             padding: const EdgeInsets.all(8),
            //             margin: const EdgeInsets.all(8),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(12),
            //               color: const Color(0xff141414),
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 ClipRRect(
            //                   borderRadius: BorderRadius.circular(6),
            //                   child: Image.network(
            //                     "https://media.istockphoto.com/id/1263686908/vi/anh/h%E1%BB%97n-h%E1%BB%A3p-snack-m%E1%BA%B7n-ph%E1%BA%B3ng-n%E1%BA%B1m-c%E1%BA%A3nh-b%C3%A0n-tr%C3%AAn-n%E1%BB%81n-g%E1%BB%97.jpg?s=612x612&w=0&k=20&c=bHjK6GARzUfqngWFckjWHpuSdsbc_feTaSUVcoOjgZk=",
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //                 const VerticalSeparator(height: 2),
            //                 Text(
            //                   "${product.name!} (${product.stock})",
            //                   style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
            //                 ),
            //                 const VerticalSeparator(height: 2),
            //                 Row(
            //                   children: [
            //                     Text(
            //                       'Rp. ${product.price}',
            //                       style: FontsGlobal.semiBoldTextStyle14.copyWith(color: Colors.white),
            //                     ),
            //                     const Spacer(),
            //                     GestureDetector(
            //                       onTap: () {
            //                         setState(() {
            //                           cart.add(product);
            //                           debugPrint('Cart: $cart');
            //                         });
            //                       },
            //                       child: Icon(
            //                         Icons.add_circle_outline,
            //                         color: ColorConstant.primaryColor,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       );
            //     } else if (productState is ErrorState) {
            //       return Center(child: Text('Error', style: TextStyle(color: Colors.red)));
            //     } else {
            //       return Container();
            //     }
            //   },
            // ),
            // if (selectedIndex == 0) ...[
            //   Text('Index 0', style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white)),
            // ] else ...[
            //   Text('Index 2', style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white)),
            // ],
            // Container(
            //   child: Center(
            //     child: [
            //       // 'Semua' tab view
            //       BlocBuilder<GetProductBloc, BaseState<List<ProductEntity>>>(
            //         builder: (context, productState) {
            //           if (productState is LoadedState<List<ProductEntity>>) {
            //             // return ListView.builder(
            //             //   itemCount: productState.data!.length,
            //             //   itemBuilder: (context, index) {
            //             //     final product = productState.data![index];
            //             //     return ListTile(
            //             //       title: Text(product.name!, style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white)),
            //             //     );
            //             //   },
            //             // );
            //             return GridView.builder(
            //               shrinkWrap: true,
            //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //                 crossAxisCount: 2,
            //                 crossAxisSpacing: 8,
            //                 mainAxisSpacing: 8,
            //                 childAspectRatio: 0.85,
            //               ),
            //               itemCount: productState.data!.length,
            //               itemBuilder: (context, index) {
            //                 final product = productState.data![index];
            //                 return Container(
            //                   padding: const EdgeInsets.all(8),
            //                   margin: const EdgeInsets.all(8),
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(12),
            //                     color: const Color(0xff141414),
            //                   ),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       ClipRRect(
            //                         borderRadius: BorderRadius.circular(6),
            //                         child: Image.network(
            //                           "https://media.istockphoto.com/id/1263686908/vi/anh/h%E1%BB%97n-h%E1%BB%A3p-snack-m%E1%BA%B7n-ph%E1%BA%B3ng-n%E1%BA%B1m-c%E1%BA%A3nh-b%C3%A0n-tr%C3%AAn-n%E1%BB%81n-g%E1%BB%97.jpg?s=612x612&w=0&k=20&c=bHjK6GARzUfqngWFckjWHpuSdsbc_feTaSUVcoOjgZk=",
            //                           fit: BoxFit.cover,
            //                         ),
            //                       ),
            //                       const VerticalSeparator(height: 2),
            //                       Text(
            //                         "${product.name!} (${product.stock})",
            //                         style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
            //                       ),
            //                       const VerticalSeparator(height: 2),
            //                       Row(
            //                         children: [
            //                           Text(
            //                             'Rp. ${product.price?.formatRupiah}',
            //                             style: FontsGlobal.semiBoldTextStyle14.copyWith(color: Colors.white),
            //                           ),
            //                           const Spacer(),
            //                           GestureDetector(
            //                             onTap: () {
            //                               int stock = product.stock!;
            //                               if (stock > 0) {
            //                                 setState(() {
            //                                   cart.add(product);
            //                                   debugPrint('Cart: $cart');
            //                                 });
            //                                 stock -= 1;
            //                               } else {
            //                                 ScaffoldMessenger.of(context).showSnackBar(
            //                                   SnackBar(
            //                                     content: Text('Stok habis'),
            //                                   ),
            //                                 );
            //                               }
            //                             },
            //                             child: Icon(
            //                               Icons.add_circle_outline,
            //                               color: ColorConstant.primaryColor,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               },
            //             );
            //           } else if (productState is ErrorState) {
            //             return Center(child: Text('Error', style: TextStyle(color: Colors.red)));
            //           } else {
            //             return Container();
            //           }
            //         },
            //       ),
            //       // Category tabs view
            //       for (var i = 0; i < state.data!.length; i++)
            //         BlocBuilder<GetProductBloc, BaseState<List<ProductEntity>>>(
            //           builder: (context, productState) {
            //             if (productState is LoadedState<List<ProductEntity>>) {
            //               return GridView.builder(
            //                 shrinkWrap: true,
            //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //                   crossAxisCount: 2,
            //                   crossAxisSpacing: 8,
            //                   mainAxisSpacing: 8,
            //                   childAspectRatio: 0.85,
            //                 ),
            //                 itemCount: productState.data!.length,
            //                 itemBuilder: (context, index) {
            //                   final product = productState.data![index];
            //                   return Container(
            //                     padding: const EdgeInsets.all(8),
            //                     margin: const EdgeInsets.all(8),
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(12),
            //                       color: const Color(0xff141414),
            //                     ),
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         ClipRRect(
            //                           borderRadius: BorderRadius.circular(6),
            //                           child: Image.network(
            //                             "https://media.istockphoto.com/id/1263686908/vi/anh/h%E1%BB%97n-h%E1%BB%A3p-snack-m%E1%BA%B7n-ph%E1%BA%B3ng-n%E1%BA%B1m-c%E1%BA%A3nh-b%C3%A0n-tr%C3%AAn-n%E1%BB%81n-g%E1%BB%97.jpg?s=612x612&w=0&k=20&c=bHjK6GARzUfqngWFckjWHpuSdsbc_feTaSUVcoOjgZk=",
            //                             fit: BoxFit.cover,
            //                           ),
            //                         ),
            //                         const VerticalSeparator(height: 2),
            //                         Text(
            //                           "${product.name!} ${product.stock}",
            //                           style: FontsGlobal.mediumTextStyle10.copyWith(color: Colors.white),
            //                         ),
            //                         const VerticalSeparator(height: 2),
            //                         Row(
            //                           children: [
            //                             Text(
            //                               'Rp. ${product.price?.formatRupiah}',
            //                               style: FontsGlobal.semiBoldTextStyle14.copyWith(color: Colors.white),
            //                             ),
            //                             const Spacer(),
            //                             GestureDetector(
            //                               onTap: () {
            //                                 int stock = product.stock!;
            //                                 if (stock > 0) {
            //                                   setState(() {
            //                                     cart.add(product);
            //                                     product.stock = stock - 1;
            //                                     debugPrint('Cart: $cart');
            //                                   });
            //                                 } else {
            //                                   ScaffoldMessenger.of(context).showSnackBar(
            //                                     SnackBar(
            //                                       content: Text('Stok habis'),
            //                                     ),
            //                                   );
            //                                 }
            //                               },
            //                               child: Icon(
            //                                 Icons.add_circle_outline,
            //                                 color: ColorConstant.primaryColor,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ],
            //                     ),
            //                   );
            //                 },
            //               );
            //             } else if (productState is ErrorState) {
            //               return Center(child: Text('Error:', style: TextStyle(color: Colors.red)));
            //             } else {
            //               return Container();
            //             }
            //           },
            //         ),
            //     ][_tabController.index],
            //   ),
            // ),
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
                                          Text(
                                            'Rp. ${cart.map((e) => e.price!).reduce((value, element) => value + element).formatRupiah}',
                                            style: FontsGlobal.boldTextStyle18,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Clearing the cart
                                          setState(() {
                                            cart.clear();
                                            groupedCart.clear();
                                          });
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF1FA0C9),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: Text("Bayar", style: FontsGlobal.semiBoldTextStyle14.copyWith(color: Colors.white)),
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
                                                decreaseQuantity(entry.value['product']);
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
        childAspectRatio: 0.78,
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
