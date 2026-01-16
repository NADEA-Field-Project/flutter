import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'order_list_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  int _refreshCounter = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      FavoritesScreen(key: ValueKey('fav_$_refreshCounter')),
      const OrderListScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _refreshCounter++;
        // Update _screens since it's used in IndexedStack
        _screens[1] = FavoritesScreen(key: ValueKey('fav_$_refreshCounter'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Sliding background indicator
            AnimatedAlign(
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              alignment: Alignment(
                -1.0 + (_selectedIndex * (2.0 / (_screens.length - 1))),
                0,
              ),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, 'Home', Icons.home_filled, Icons.home_outlined),
                _buildNavItem(1, 'Favorites', Icons.favorite, Icons.favorite_border),
                _buildNavItem(2, 'Orders', Icons.receipt_long, Icons.receipt_long_outlined),
                _buildNavItem(3, 'Profile', Icons.person, Icons.person_outline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData activeIcon, IconData inactiveIcon) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.2 : 1.0,
              curve: Curves.easeOutBack,
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? Colors.black : Colors.grey[400],
                size: 26,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isSelected ? 16 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isSelected ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
