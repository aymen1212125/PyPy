import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/hive_service.dart';
import 'providers/curriculum_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/session_provider.dart';
import 'screens/chat/mentor_chat_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/learn/lesson_screen.dart';
import 'screens/onboarding/onboarding_flow_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/progress/progress_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  final profileProvider = ProfileProvider();
  final sessionProvider = SessionProvider();
  await profileProvider.init();
  await sessionProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: profileProvider),
        ChangeNotifierProvider(create: (_) => CurriculumProvider()),
        ChangeNotifierProvider.value(value: sessionProvider),
      ],
      child: const PyPyApp(),
    ),
  );
}

class PyPyApp extends StatelessWidget {
  const PyPyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>().profile;
    final router = GoRouter(
      initialLocation: (profile?.name.isEmpty ?? true) ? '/onboarding' : '/home',
      routes: [
        GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingFlowScreen()),
        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            GoRoute(path: '/learn', builder: (_, __) => const LessonScreen()),
            GoRoute(path: '/mentor', builder: (_, __) => const MentorChatScreen()),
            GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
            GoRoute(path: '/progress', builder: (_, __) => const ProgressScreen()),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).routeInformationProvider.value.uri.path;
    int currentIndex = ['/home', '/learn', '/mentor', '/profile'].indexWhere((e) => location.startsWith(e));
    if (currentIndex < 0) currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PyPy'),
        actions: [IconButton(onPressed: () => context.push('/progress'), icon: const Icon(Icons.account_tree_outlined))],
      ),
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xAA1C1C27),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0x33FFFFFF)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (i) => context.go(['/home', '/learn', '/mentor', '/profile'][i]),
          items: const [
            BottomNavigationBarItem(icon: Text('🏠'), label: 'Home'),
            BottomNavigationBarItem(icon: Text('📖'), label: 'Learn'),
            BottomNavigationBarItem(icon: Text('💬'), label: 'Mentor'),
            BottomNavigationBarItem(icon: Text('👤'), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
