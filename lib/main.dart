import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomedserv/provider/loginprovider.dart';
import 'package:gomedserv/screens/login_screen.dart';
import 'package:gomedserv/screens/dashboard_screen.dart';
import 'package:gomedserv/screens/analytics/analytics.dart';
import 'package:gomedserv/screens/booking_management/add_commission.dart';
import 'package:gomedserv/screens/booking_management/booking_management.dart';
import 'package:gomedserv/screens/financial_management/manage_screen.dart';
import 'package:gomedserv/screens/financial_management/payment_screen.dart';
import 'package:gomedserv/screens/service_management/add_service.dart';
import 'package:gomedserv/screens/service_management/manage_services.dart';
import 'package:gomedserv/screens/user_management/manageusers_screen.dart';
import 'package:gomedserv/screens/user_management/user_profile.dart';
import 'package:gomedserv/screens/vendor_management/add_vendor.dart';
import 'package:gomedserv/screens/vendor_management/vendor_list.dart';
import 'package:gomedserv/screens/notification_screen.dart';
import 'package:gomedserv/screens/notification_settings.dart';
import 'package:gomedserv/screens/settings_screen.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

// Authentication state provider
final authStateProvider = StateProvider<bool>((ref) => false);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(loginProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer(builder: (context, ref, child) {
        print("build main.dart");

        final authState = ref.watch(loginProvider);
        // Watch the authentication state
        // Check for a valid access token
        final accessToken = authState.data?.isNotEmpty == true
            ? authState.data![0].accessToken: null;

        print('token/main $accessToken');
        // Check if the user has a valid refresh token
        if (accessToken != null && accessToken.isNotEmpty) {
          return DashboardScreen(); // User is authenticated, redirect to Home
        } else {
          return LoginScreen();
        }
        ;
      }),
      routes: {
        "loginscreen": (context) => LoginScreen(),
        "analyticsreport": (context) => AnalyticsReportsScreen(),
        "addcommission": (context) => AddCommission(),
        "bookingmanagement": (context) => const BookingManagement(),
        "mangescreen": (context) => ManageScreen(),
        "addvendor": (context) => AddVendor(),
        "vendorlist": (context) => VendorList(),
        "dashboardscreen": (context) => DashboardScreen(),
        "notificationsettings": (context) => NotificationSettings(),
        "settingsscreen": (context) => SettingsScreen(),
        "addsevicescreen": (context) => AddServiceScreen(),
        "manageservices": (context) => ManageServices(),
        "manageusersscreen": (context) => ManageUsersScreen(),
      },
    );
  }

  // Mock implementation for auto-login logic
  Future<bool> tryAutoLogin(WidgetRef ref) async {
    // Simulate a delay for auto-login check (e.g., check shared preferences or secure storage)
    await Future.delayed(const Duration(seconds: 2));

    // Simulate auto-login failure for testing purposes
    bool autoLoginSuccessful = false;

    // Update authentication state
    ref.read(authStateProvider.notifier).state = autoLoginSuccessful;
    return autoLoginSuccessful;
  }
}
