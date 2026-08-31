import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/info_page.dart';
import 'theme/app_colors.dart';
import 'widgets/home_center_button.dart';
import 'widgets/info_center_button.dart';
import 'widgets/navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fluttertemp',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  late final GlobalKey<HomePageState> _homePageKey;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _homePageKey = GlobalKey<HomePageState>();
    _pages = [HomePage(key: _homePageKey), const InfoPage()];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget? _getCenterWidget(BuildContext context) {
    if (_currentPageIndex == 0) {
      // Home page - show expand/collapse button
      final homePageState = _homePageKey.currentState;
      if (homePageState != null) {
        return HomePageCenterButton(
          expandedNotifier: homePageState.expandedNotifier,
          onToggle: homePageState.toggleExpanded,
        );
      }
    } else if (_currentPageIndex == 1) {
      // Info page - show more details button
      return const InfoPageCenterButton();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        onLeftPressed: _goToPreviousPage,
        onRightPressed: _goToNextPage,
        centerWidget: _getCenterWidget(context),
        enableLeftButton: _currentPageIndex > 0,
        enableRightButton: _currentPageIndex < _pages.length - 1,
      ),
    );
  }
}
