import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:percon_app/core/config/theme/app_theme.dart';
import 'package:percon_app/core/init/app_init.dart';
import 'package:percon_app/core/routes/app_routes.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/navigation/navigation_helper.dart';
import 'package:percon_app/feat/presentation/pages/home/page/home_page.dart';
import 'package:percon_app/feat/providers/bloc_providers_set_up.dart';
import 'package:percon_app/firebase_options.dart';

Future<void> main() async {
  // Application Initialize
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize device size
    AppInit.initDeviceSize(context);
    return MultiBlocProvider(
      providers: BlocProvidersSetUp.providers,
      child: MaterialApp(
        theme: MyAppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        title: AppTexts.appName,
        navigatorKey: Navigation.navigationKey,
        routes: AppRoutes.routes,
        initialRoute: HomePage.id,
      ),
    );
  }
}
