import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pill_time/data/webservice/auth_webservice.dart';
import 'package:pill_time/data/webservice/reminder_webservice.dart';
import 'package:pill_time/data/webservice/user_webservice.dart';
import 'package:pill_time/helper/cache_helper.dart';
import 'package:pill_time/logic/app_provider.dart';
import 'package:pill_time/logic/auth_provider.dart';
import 'package:pill_time/logic/reminder_provider.dart';
import 'package:pill_time/presentation/screen/add_reminder_screen.dart';
import 'package:pill_time/presentation/screen/log_in_screen.dart';
import 'package:pill_time/presentation/screen/intro_screen.dart';
import 'package:pill_time/presentation/screen/main_screen.dart';
import 'package:pill_time/presentation/screen/splash_screen.dart';
import 'package:pill_time/presentation/screen/register_screen.dart';
import 'package:pill_time/presentation/screen/user_profile_screen.dart';
import 'package:pill_time/widgets/restart_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  debugPrint("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper.init();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final String localeLanguage = CacheHelper.getData('lang') ?? 'en';

  runApp(
    RestartWidget(
      child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale(localeLanguage),
        startLocale: Locale(localeLanguage),
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      _showNotification(
          message.notification!.title, message.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      // Handle the message when the app is opened from a notification
    });
  }

  Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel_id',
      'reminder_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (_) => AuthProvider(
                    authWebService: AuthWebService(),
                    userWebservice: UserWebservice())),
            ChangeNotifierProvider(
                create: (_) =>
                    ReminderProvider(reminderWebService: ReminderWebService())),
            ChangeNotifierProvider(create: (_) => AppProvider()),
          ],
          child: MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: ThemeData(
              primaryColor: Colors.blue,
              appBarTheme: getAppBarTheme(),
              textTheme: getTextTheme(),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/intro': (context) => IntroScreen(),
              '/login': (context) => LoginScreen(),
              '/register': (context) => RegisterScreen(),
              '/add_reminder': (context) => AddReminderScreen(),
              '/main_screen': (context) => MainScreen(),
              '/user_profile': (context) => UserProfileScreen(),
            },
          ),
        );
      },
    );
  }

  TextTheme getTextTheme() {
    return TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 25.0,
          color: Colors.blue[600],
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.blue[600],
        ),
        bodySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          color: Color(0xff868D95),
        ));
  }

  AppBarTheme getAppBarTheme() {
    return AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: Colors.blue[500],
      ),
    );
  }
}
