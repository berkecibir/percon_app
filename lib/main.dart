import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/config/theme/app_theme.dart';
import 'package:percon_app/core/init/app_init.dart';
import 'package:percon_app/core/routes/app_routes.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/widgets/navigation/navigation_helper.dart';
import 'package:percon_app/feat/presentation/pages/home/page/home_page.dart';
import 'package:percon_app/feat/providers/bloc_providers_set_up.dart';

Future<void> main() async {
  // Application Initialize
  await AppInit.initializeApp();
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
