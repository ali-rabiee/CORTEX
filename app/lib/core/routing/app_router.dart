import 'package:go_router/go_router.dart';

import '../../presentation/home/home_screen.dart';
import '../../presentation/daily_session/session_screen.dart';
import '../../presentation/concept_detail/concept_detail_screen.dart';
import '../../presentation/review_queue/review_queue_screen.dart';
import '../../presentation/quiz/quiz_screen.dart';
import '../../presentation/progress/progress_screen.dart';
import '../../presentation/settings/settings_screen.dart';

/// Application route paths.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const session = '/session';
  static const concept = '/concept/:id';
  static const reviewQueue = '/review';
  static const quiz = '/quiz';
  static const progress = '/progress';
  static const settings = '/settings';
}

/// GoRouter configuration for the app.
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.session,
      builder: (context, state) => const SessionScreen(),
    ),
    GoRoute(
      path: AppRoutes.concept,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ConceptDetailScreen(conceptId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.reviewQueue,
      builder: (context, state) => const ReviewQueueScreen(),
    ),
    GoRoute(
      path: AppRoutes.quiz,
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: AppRoutes.progress,
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
