import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_pos/presentation/main/main.dart';
import 'package:flutter_application_pos/presentation/main/screen/custom_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/common.dart';
import '../../../core/core.dart';
import '../../auth/screens/screens.dart';
import 'bar_graph_card.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  SharedPrefClient? _sharedPrefClient;
  SecureStorageClient storageClient = SecureStorageClient.instance;
  List<FlSpot> dataBulanIni = [];
  List<String> bottomTitleHarian = [];

  //function to logout
  void _logout() {
    _sharedPrefClient?.clear();
    storageClient.clear();
  }

  void _getToken() async {
    String? token = await storageClient.getByKey(SharedPrefKey.accessToken);
    debugPrint('Token: $token');
  }

  @override
  initState() {
    super.initState();
    context.read<GetOrderByMonthBloc>().add(FetchOrderByMonth());
    context.read<GetOrderItemByDateBloc>().add(FetchOrderItemByDate());
    context.read<GetOrderByDateBloc>().add(FetchOrderByDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222222),
      appBar: AppBar(
        backgroundColor: Color(0xff1B1B1B),
        title: Text(
          'REPORTS',
          style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GestureDetector(
              onTap: () {
                _logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen()), (route) => false);
              },
              child: Icon(Icons.logout, color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<GetOrderByDateBloc, BaseState<List<OrderEntity>>>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is LoadedState) {
                  int totalAmount = state.data!.map((e) => e.totalAmount!).fold(0, (prev, amount) => prev + amount);
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Color(0xff1B1B1B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.money_outlined,
                                    color: ColorConstant.primaryColor,
                                    size: 14,
                                  ),
                                  HorizontalSeparator(width: 2),
                                  Text(
                                    'Total Pendapatan',
                                    style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              Divider(
                                color: ColorConstant.blackColor,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Rp. ${totalAmount.formatRupiah}',
                                    style: FontsGlobal.boldTextStyle14.copyWith(color: Colors.white),
                                  ),
                                  Spacer(),
                                  Text(
                                    '  Hari ini',
                                    style: FontsGlobal.lightTextStyle10.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      HorizontalSeparator(width: 2),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Color(0xff1B1B1B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 14,
                                    color: ColorConstant.primaryColor,
                                  ),
                                  HorizontalSeparator(width: 2),
                                  Text(
                                    'Total Pesanan',
                                    style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              Divider(
                                color: ColorConstant.blackColor,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${state.data!.length}',
                                    style: FontsGlobal.boldTextStyle16.copyWith(color: Colors.white),
                                  ),
                                  Spacer(),
                                  Text(
                                    '  Hari ini',
                                    style: FontsGlobal.lightTextStyle10.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox();
              },
            ),
            // BarGraphCard(),
            VerticalSeparator(height: 2),
            BlocConsumer<GetOrderByMonthBloc, BaseState<List<OrderEntity>>>(
              listener: (context, state) {
                debugPrint('state: $state');

                if (state is LoadedState) {
                  setState(() {
                    dataBulanIni = state.data!.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.totalAmount!.toDouble())).toList();
                    bottomTitleHarian = state.data!.map((e) => DateFormat('dd').format(e.dateCreated!)).toList();
                  });
                }
              },
              builder: (context, state) {
                if (state is LoadedState) {
                  return CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Text(
                            'Pendapatan Bulan Ini',
                            style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white),
                          ),
                        ),
                        VerticalSeparator(height: 4),
                        AspectRatio(
                          aspectRatio: 9 / 7,
                          child: LineChart(
                            curve: Curves.easeInOut,
                            LineChartData(
                              lineTouchData: const LineTouchData(
                                handleBuiltInTouches: true,
                              ),
                              gridData: const FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    interval: 1,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      int index = value.toInt();
                                      if (index >= 0 && index < bottomTitleHarian.length) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          space: 10,
                                          child: Text(
                                            bottomTitleHarian[index],
                                            style: FontsGlobal.mediumTextStyle12.copyWith(color: Colors.white),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      return Text(
                                        NumberFormat.compact().format(value),
                                        style: FontsGlobal.mediumTextStyle8.copyWith(color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  curveSmoothness: 0,
                                  color: Theme.of(context).primaryColor,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        ColorConstant.primaryColor.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                    show: true,
                                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                                  ),
                                  dotData: const FlDotData(show: false),
                                  spots: dataBulanIni,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            VerticalSeparator(height: 2),
            Text('Riwayat Order Hari Ini', style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white)),
            VerticalSeparator(height: 2),
            BlocConsumer<GetOrderItemByDateBloc, BaseState<List<OrderItemEntity>>>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is LoadedState) {
                  List<GroupedOrder> groupedData = groupByOrderId(state.data!);
                  return Column(
                    children: groupedData.map((e) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Color(0xff1B1B1B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID ${e.orderId}', style: FontsGlobal.mediumTextStyle14.copyWith(color: Colors.white)),
                            VerticalSeparator(height: 1),
                            Row(
                              children: [
                                Text('Rp. ${e.totalAmount!.formatRupiah}', style: FontsGlobal.boldTextStyle14.copyWith(color: Colors.white)),
                                Spacer(),
                                Text(DateFormat('HH:mm').format(e.dateCreated!.toLocal()), style: FontsGlobal.lightTextStyle10.copyWith(color: Colors.white)),
                              ],
                            ),
                            VerticalSeparator(height: 1),
                            Divider(
                              color: ColorConstant.blackColor,
                            ),
                            VerticalSeparator(height: 1),
                            Column(
                              children: e.items!.map((item) {
                                return Row(
                                  children: [
                                    Text('${item.productId!.name!}(x${item.quantity})', style: FontsGlobal.lightTextStyle10.copyWith(color: Colors.white)),
                                    Spacer(),
                                    Text('Rp. ${item.price!.formatRupiah}', style: FontsGlobal.lightTextStyle10.copyWith(color: Colors.white)),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
                return SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mengelompokkan data berdasarkan order_id dan menghitung total_amount
  List<GroupedOrder> groupByOrderId(List<OrderItemEntity> orderItems) {
    Map<int, GroupedOrder> groupedData = {};

    for (var item in orderItems) {
      if (item.orderId != null && item.orderId!.id != null) {
        if (!groupedData.containsKey(item.orderId!.id)) {
          groupedData[item.orderId!.id!] = GroupedOrder(
            orderId: item.orderId!.id,
            totalAmount: 0,
            items: [],
            dateCreated: item.orderId!.dateCreated,
          );
        }
        groupedData[item.orderId!.id]!.items!.add(item);
        groupedData[item.orderId!.id]!.totalAmount = (groupedData[item.orderId!.id]!.totalAmount ?? 0) + (item.price ?? 0);
      }
    }

    return groupedData.values.toList();
  }
}

class GroupedOrder {
  int? orderId;
  int? totalAmount;
  DateTime? dateCreated;
  List<OrderItemEntity>? items;

  GroupedOrder({
    this.orderId,
    this.totalAmount,
    this.items,
    this.dateCreated,
  });

  factory GroupedOrder.fromJson(Map<String, dynamic> json) => GroupedOrder(
        orderId: json["order_id"],
        totalAmount: json["total_amount"],
        dateCreated: DateTime.parse(json["date_created"]),
        items: (json["items"] as List).map((i) => OrderItemEntity.fromJson(i)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "total_amount": totalAmount,
        "date_created": dateCreated?.toIso8601String(),
        "items": items?.map((i) => i.toJson()).toList(),
      };
}
