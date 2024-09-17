import 'package:dealsdrayapp/screens/account_scr.dart';
import 'package:dealsdrayapp/screens/cart_screen.dart';
import 'package:dealsdrayapp/screens/category_scr.dart';
import 'package:dealsdrayapp/screens/deals_scr.dart';
import 'package:dealsdrayapp/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  TabController? tabController;
  int selectIndex = 0;

  onItemClicked(int index){
    setState(() {
      selectIndex = index;
      tabController!.index = selectIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5,vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
         HomeScreen(),
         CategoriesScreen(),
         DealsScreen(),
         CartScreen(),
         AccountScreen()
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined),label: "Categories"),
        BottomNavigationBarItem(icon: Icon(Icons.discount_outlined),label: "Deals"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: "Account"),
      ],
      unselectedItemColor: const Color.fromARGB(255, 162, 162, 162),
      selectedItemColor: const Color.fromARGB(255, 215, 6, 6),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      currentIndex: selectIndex,
      onTap: onItemClicked,
      
      ),
    );
  }
}