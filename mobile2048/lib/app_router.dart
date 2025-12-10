import 'package:flutter/material.dart';
import 'pages/opening_page.dart';
import 'pages/home_page.dart';
import 'pages/campaign/campaign_page.dart';
import 'pages/campaign/new_save_select_difficulty.dart';
import 'pages/missions/missions_page.dart';
import 'pages/missions/crazy_numbers_page.dart';
import 'pages/tasks/tasks_page.dart';
import 'pages/leaderboard/leaderboard_page.dart';
import 'pages/settings/settings_page.dart';
// import 'pages/game/game_board_page.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/': (_) => OpeningPage(),
    '/home': (_) => HomePage(),
    '/campaign': (_) => CampaignPage(),
    '/campaign-new': (_) => NewGameDifficultyPage(),
    '/missions': (_) => MissionsPage(),
    '/crazy-numbers': (_) => CrazyNumbersPage(),
    '/tasks': (_) => TasksPage(),
    '/leaderboard': (_) => LeaderboardPage(),
    '/settings': (_) => SettingsPage(),
    // '/game': (_) => GameBoardPage(),
  };
}
