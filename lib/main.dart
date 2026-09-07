import 'package:flutter/material.dart';
import 'models/app_user.dart';
import 'pages/admin_page.dart';
import 'pages/home_page.dart';
import 'pages/info_page.dart';
import 'pages/login_page.dart';
import 'services/auth_service.dart';
import 'services/course_repository.dart';
import 'theme/app_colors.dart';
import 'widgets/home_center_button.dart';
import 'widgets/info_center_button.dart';
import 'widgets/navigation_bar.dart';
import 'widgets/unlock_course_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoga',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

/// Shows the login flow on first launch, then the main app once a session
/// is found in secure storage.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  AppUser? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final user = await AuthService.instance.getStoredUser();
    if (user != null) {
      courseRepository.setCurrentUser(user.email);
    }
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  void _onLoggedIn(AppUser user) {
    courseRepository.setCurrentUser(user.email);
    setState(() => _user = user);
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    setState(() => _user = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    if (_user == null) {
      return LoginPage(onLoggedIn: _onLoggedIn);
    }
    return RootPage(user: _user!, onLogout: _logout);
  }
}

class RootPage extends StatefulWidget {
  final AppUser user;
  final VoidCallback onLogout;

  const RootPage({super.key, required this.user, required this.onLogout});

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
    _pages = [
      HomePage(key: _homePageKey, onLogout: widget.onLogout),
      if (widget.user.isAdmin) const AdminPage(),
      const InfoPage(),
    ];
  }

  /// Index of the info page within [_pages] — shifts by one when the admin
  /// page is present ahead of it.
  int get _infoPageIndex => widget.user.isAdmin ? 2 : 1;

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

  Future<void> _showUnlockSheet() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UnlockCourseSheet(),
    );
    _homePageKey.currentState?.refresh();
  }

  Widget? _getCenterWidget(BuildContext context) {
    if (_currentPageIndex == 0) {
      return HomePageCenterButton(onPressed: _showUnlockSheet);
    } else if (_currentPageIndex == _infoPageIndex) {
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
