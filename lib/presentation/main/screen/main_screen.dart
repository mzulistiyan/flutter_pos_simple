import 'package:flutter/material.dart';
import 'package:flutter_application_pos/presentation/presentation.dart';

import '../../../common/common.dart';

class MainScreen extends StatefulWidget {
  final int selected;
  MainScreen({
    Key? key,
    this.selected = 0,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  final List<Widget> _pages = [
    const SalesScreen(),
    const ManageScreen(),
    const ReportScreen(),
  ];

  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selected;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
    });
    _pageController!.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/icons/ic-store.png',
                width: 24,
                height: 24,
                color: _currentIndex == 0 ? ColorConstant.primaryColor : const Color(0xffD9D9D9),
              ),
              label: 'Store',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/icons/ic-manage.png',
                width: 24,
                height: 24,
                color: _currentIndex == 1 ? ColorConstant.primaryColor : const Color(0xffD9D9D9),
              ),
              label: 'Manage',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/icons/ic-report.png',
                width: 24,
                height: 24,
                color: _currentIndex == 2 ? ColorConstant.primaryColor : const Color(0xffD9D9D9),
              ),
              label: 'Report',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedFontSize: 8,
          unselectedFontSize: 6,
          selectedItemColor: ColorConstant.primaryColor,
          unselectedLabelStyle: FontsGlobal.regulerTextStyle8.copyWith(fontSize: 7),
          selectedLabelStyle: FontsGlobal.semiBoldTextStyle8,
          unselectedItemColor: const Color(0xff949494),
          showUnselectedLabels: true,
          onTap: _onItemTapped,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
