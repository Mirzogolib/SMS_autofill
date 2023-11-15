import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill_app/pages/autofill_otp_screen.dart';
import 'package:sms_autofill_app/pages/telephony_otp_screen.dart';

class Application {
  static FluroRouter router = FluroRouter();
}

class AppRoutes {
  static String login = '/login';
  static String otpScreenWithTelephony = '/otpWithTelephony';
  static String otpScreenWithAutoFill = '/otpWithAutofill';

  static void defineRoutes(FluroRouter router) {
    router.notFoundHandler = notFound;
    router.define(login, handler: loginHandler);
    router.define(otpScreenWithTelephony, handler: otpWithTelephonyHandler);
    router.define(otpScreenWithAutoFill, handler: otpWithAutofillHandler);
  }
}

final notFound = Handler(handlerFunc: (_, __) => Container());
final loginHandler = Handler(handlerFunc: (_, __) => Container());
final otpWithTelephonyHandler =
    Handler(handlerFunc: (_, __) => const TelephonyOtpScreen());
final otpWithAutofillHandler =
    Handler(handlerFunc: (_, __) => const AutofillOtpScreen());
