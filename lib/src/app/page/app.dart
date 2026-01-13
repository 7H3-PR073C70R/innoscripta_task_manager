import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innoscripta_task_manager/src/app/router/app_router.dart';
import 'package:innoscripta_task_manager/src/core/themes/app_theme.dart';
import 'package:innoscripta_task_manager/src/l10n/arb/app_localizations.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/dismiss_keyboard.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MaterialApp.router(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
