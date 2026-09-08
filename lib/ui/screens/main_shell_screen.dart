import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';
import 'about_screen.dart';
import 'disease_search_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'identify_screen.dart';
import 'remedies_screen.dart';

/// Main scaffold container hosting the 5 bottom navigation tabs
class MainShellScreen extends StatefulWidget {
  final int initialIndex;

  const MainShellScreen({super.key, this.initialIndex = 0});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onNavigateToIdentify: () => _onTabChanged(1),
        onNavigateToSearch: () => _onTabChanged(2),
        onNavigateToRemedies: () => _onTabChanged(3),
        onNavigateToHistory: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
        },
      ),
      const IdentifyScreen(),
      const DiseaseSearchScreen(),
      const RemediesScreen(),
      const AboutScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/logo.png', width: 32, height: 32, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            const Text(
              'MediPlant',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          // History shortcut
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Scan History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onIndexChanged: _onTabChanged,
      ),
    );
  }
}
