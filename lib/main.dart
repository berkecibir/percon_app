import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/core/config/theme/app_theme.dart';
import 'package:percon_app/core/init/app_init.dart';
import 'package:percon_app/core/routes/app_routes.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/core/utils/helper/cache_helper.dart';
import 'package:percon_app/core/widgets/navigation/navigation_helper.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_state.dart';
import 'package:percon_app/feat/presentation/pages/auth/page/login_page.dart';
import 'package:percon_app/feat/presentation/pages/home/page/home_page.dart';
import 'package:percon_app/feat/presentation/pages/splash/page/splash_page.dart';
import 'package:percon_app/feat/providers/bloc_providers_set_up.dart';

Future<void> main() async {
  // Application Initialize
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppInit.initializeApp();
  await CacheHelper.migrateFavoriteData();
  runApp(
    EasyLocalization(
      key: UniqueKey(), // Add key to force rebuild when locale changes
      supportedLocales: const [Locale('en'), Locale('tr'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('de'),
      startLocale: const Locale('de'),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize device size
    AppInit.initDeviceSize(context);
    return MultiBlocProvider(
      providers: BlocProvidersSetUp.providers,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: MyAppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            title: AppTexts.appName.tr(),
            navigatorKey: Navigation.navigationKey,
            routes: AppRoutes.routes,
            initialRoute: SplashPage.id,
            builder: (context, child) {
              return BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthUnauthenticated) {
                    Navigation.pushReplacementNamed(root: LoginPage.id);
                  } else if (state is AuthAuthenticated) {
                    Navigation.pushReplacementNamed(root: HomePage.id);
                  }
                },
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
