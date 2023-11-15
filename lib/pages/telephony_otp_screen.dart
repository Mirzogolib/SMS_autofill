import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class TelephonyOtpScreen extends StatefulWidget {
  const TelephonyOtpScreen({super.key});

  @override
  State<TelephonyOtpScreen> createState() => _TelephonyOtpScreenState();
}

class _TelephonyOtpScreenState extends State<TelephonyOtpScreen> {
  String otpCode = '';
  final telephony = Telephony.instance;
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

  String? _validateOtpCode(String body) {
    // Here is regular expression which will take 6 digits from the text
    final otpCodeRegex = RegExp(r'\b\d{6}\b');
    Match? match = otpCodeRegex.firstMatch(body);
    if (match != null) {
      String otpCode = match.group(0)!;

      return otpCode;
    } else {
      return null;
    }
  }

  Future<void> _startMessageListener() async {
    final bool? result = Platform.isAndroid
        ? await telephony.requestPhoneAndSmsPermissions
        : null;
    if (result != null && result) {
      telephony.listenIncomingSms(
        onBackgroundMessage: onBackgroundMessage,
        onNewMessage: _messageHandler,
      );
    }
    if (!mounted) return;
  }

  void _messageHandler(SmsMessage message) {
    final body = message.body;
    if (body != null) {
      String? receivedOtpCode = _validateOtpCode(body);
      if (receivedOtpCode != null) {
        setState(() {
          otpEditingController.text = receivedOtpCode;
        });
      }
    }
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
        title: const Text('OTP Screen (Telephony)'),
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
