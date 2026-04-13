import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/schedule_provider.dart';
import 'services/ai_schedule_service.dart';
import 'screens/dashboard_screen.dart';

void main () {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ScheduleProvider()),
          ChangeNotifierProvider(create: (_) => AiScheduleService()),
        ],
      child: const ScheduleResolverApp(),
    ),
  );
}


class ScheduleResolverApp extends StatelessWidget {
  const ScheduleResolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IT Tech Schedule Resolver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052CC), // Professional Blue (Jira/Atlassian-like)
          primary: const Color(0xFF0052CC),
          secondary: const Color(0xFF0747A6),
          surface: Colors.white,
          background: const Color(0xFFF4F5F7),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0747A6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: Color(0xFFD1D1D1)),
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}