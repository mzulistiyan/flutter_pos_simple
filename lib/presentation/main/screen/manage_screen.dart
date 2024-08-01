import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_pos/common/constant/constant.dart';
import 'package:flutter_application_pos/core/core.dart';
import 'package:flutter_application_pos/presentation/main/screen/form_data.dart';
import 'package:flutter_application_pos/presentation/presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/common.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _PenjualanScreenState();
}

class _PenjualanScreenState extends State<ManageScreen> with TickerProviderStateMixin {
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
                  'Manage',
                  style: FontsGlobal.mediumTextStyle24.copyWith(color: Colors.white),
                ),
                const Spacer(),
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormDataScreen(),
              ),
            );

            if (result != null && result) {
              context.read<GetProductBloc>().add(const FetchProduct());
              setState(() {
                loop = 1;
              });
            }
          },
          child: Icon(Icons.add),
        ),
      ),
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
                    onTap: () async {
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormDataScreen(
                            name: product.name,
                            price: product.price,
                            stock: product.stock,
                            id: product.id.toString(),
                            categoryID: product.categoryId!.id.toString(),
                            image: product.image,
                          ),
                        ),
                      );

                      if (result != null && result) {
                        context.read<GetProductBloc>().add(const FetchProduct());
                        setState(() {
                          loop = 1;
                        });
                      }
                    },
                    child: Icon(
                      Icons.edit,
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
