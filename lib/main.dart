import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whats_clone/core/routes/app_router.dart';
import 'package:whats_clone/core/secrets.dart';
import 'package:whats_clone/core/theme/app_theme.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/notification/model/fcm_token.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeHive();
  FirebaseDatabase.instance
      .setPersistenceCacheSizeBytes(10 * 1024 * 1024); // 10 MB cache size
  await Supabase.initialize(
    url: 'https://tsfnxntivmgopccxbuis.supabase.co',
    anonKey: supabaseApikey,
  );

  var accessToken = await () async {
    // final serviceAccountKey = await rootBundle.loadString('assets/your-service-account.json');
    // final credentials = ServiceAccountCredentials.fromJson(json.decode(serviceAccountKey));
    final credentials = ServiceAccountCredentials.fromJson(firebaseAdmin);

    final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    // Get an authenticated HTTP client
    final client = await clientViaServiceAccount(credentials, scopes);

    var _serverToken = client.credentials.accessToken.data;
    return _serverToken;
  }();
  print(accessToken);

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['assets/fonts'], license);
  });
  await FlutterContacts.requestPermission(readonly: true);

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> initializeHive() async {
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(ChatProfileAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ChatMessagesAdapter());
  Hive.registerAdapter(FcmTokenAdapter());

  await Hive.initFlutter();
  await Hive.openBox<bool>(HiveBoxName.onboarding);
  // await Hive.openBox<Chat>(HiveBoxName.chats);
  await Hive.openBox<Profile>(HiveBoxName.profiles);
  await Hive.openBox<ChatProfile>(HiveBoxName.chatProfiles);
  await Hive.openBox<bool>(HiveBoxName.profileCompletion);
  await Hive.openBox<ChatMessages>(HiveBoxName.chatMessages);
  await Hive.openBox<FcmToken>(HiveBoxName.fcmToken);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
          textTheme:
              GoogleFonts.mulishTextTheme(AppTheme.lightTheme.textTheme)),
      darkTheme: AppTheme.darkTheme.copyWith(
          textTheme: GoogleFonts.mulishTextTheme(AppTheme.darkTheme.textTheme)),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
