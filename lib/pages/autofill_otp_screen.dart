import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class AutofillOtpScreen extends StatefulWidget {
  const AutofillOtpScreen({super.key});

  @override
  State<AutofillOtpScreen> createState() => _AutofillOtpScreenState();
}

class _AutofillOtpScreenState extends State<AutofillOtpScreen>
    with CodeAutoFill {
  String otpCode = '';
  final telephony = Telephony.instance;
  final otpCodeRegex = RegExp(r'\b\d{6}\b');
  final otpEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _startMessageListener();
  }

  @override
  void dispose() {
    otpEditingController.dispose();
    super.dispose();
  }

  Future<void> _startMessageListener() async {
    listenForCode();

    /// Get your app signature
    /// TODO: Step X+1: Get your application signature and save it
    /// in my case:  182uGE0iANr
    final aaa = await SmsAutoFill().getAppSignature;
    log('Your app signature is $aaa');
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Screen (AutoFill)'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OtpHeader(),
          Pinput(
            controller: otpEditingController,
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
          ),
          const SizedBox(height: 16),
          Text(
            'Didn’t receive code?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color.fromRGBO(62, 116, 165, 1),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Resend',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              decoration: TextDecoration.underline,
              color: const Color.fromRGBO(62, 116, 165, 1),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void codeUpdated() {
    if (code != null) {
      setState(() {
        otpEditingController.text = code!;
      });
    }
  }
}

class OtpHeader extends StatelessWidget {
  const OtpHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Verification',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color.fromRGBO(30, 60, 87, 1),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Enter the code sent to the number',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color.fromRGBO(133, 153, 170, 1),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '+999 88 123 45 67',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color.fromRGBO(30, 60, 87, 1),
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }
}
