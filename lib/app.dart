import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill_app/routes.dart';

class SmsAutofillApp extends StatefulWidget {
  const SmsAutofillApp({super.key});

  @override
  State<SmsAutofillApp> createState() => _SmsAutofillAppState();
}

class _SmsAutofillAppState extends State<SmsAutofillApp> {
  final router = FluroRouter();

  @override
  void initState() {
    AppRoutes.defineRoutes(router);
    Application.router = router;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Application.router.generator,
      home: Scaffold(
        appBar: AppBar(title: const Text('SMS Autofill')),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.otpScreenWithTelephony);
                  },
                  child: const Text('Navigate to OTP Screen (Telephony)'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.otpScreenWithAutoFill);
                  },
                  child: const Text('Navigate to OTP Screen (Autofill)'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
