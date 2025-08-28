import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whats_clone/core/routes/app_router.dart';
import 'package:whats_clone/core/secrets.dart';
import 'package:whats_clone/core/theme/app_theme.dart';
import 'package:whats_clone/l10n/app_localizations.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/notification/model/fcm_token.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/providers/theme_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // }
  await initializeHive();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance
      .setPersistenceCacheSizeBytes(10 * 1024 * 1024); // 10 MB cache size
  await Supabase.initialize(
    url: 'https://tsfnxntivmgopccxbuis.supabase.co',
    anonKey: supabaseApikey,
  );

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['assets/fonts'], license);
  });

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initializeHive() async {
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(ChatProfileAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ChatMessagesAdapter());
  Hive.registerAdapter(FcmTokenAdapter());

  await Hive.initFlutter();
  await Hive.openBox<bool>(HiveBoxName.themeMode);
  await Hive.openBox<bool>(HiveBoxName.onboarding);
  await openHiveBoxes();
}

Future<void> openHiveBoxes() async {
  await Hive.openBox<Profile>(HiveBoxName.profiles);
  await Hive.openBox<bool>(HiveBoxName.profileCompletion);
  await Hive.openBox<FcmToken>(HiveBoxName.fcmToken);

  await Hive.openBox<ChatProfile>(HiveBoxName.chatProfiles);
  await Hive.openBox<ChatMessages>(HiveBoxName.chatMessages);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        textTheme: AppTheme.lightTheme.textTheme.apply(fontFamily: 'Mulish'),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: AppTheme.darkTheme.textTheme.apply(fontFamily: 'Mulish'),
      ),
      themeMode: themeMode,
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
    );
  }
}
