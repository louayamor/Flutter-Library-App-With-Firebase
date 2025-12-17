import 'package:flutter/material.dart';

/// ================= COLORS =================
/// Warm, accessible orange palette
const Color kPrimaryColor = Color(0xFFF97316); // Orange-500
const Color kPrimaryDarkColor = Color(0xFFEA580C); // Orange-600
const Color kPrimaryLightColor = Color(0xFFFFEDD5); // Orange-100

const Color kSecondaryColor = Color(0xFF22C55E); // Success green
const Color kBackgroundColor = Color(0xFFFFFBF5); // Soft warm background
const Color kSurfaceColor = Colors.white;

const Color kTextPrimaryColor = Color(0xFF1F2937); // Gray-800
const Color kTextSecondaryColor = Color(0xFF6B7280); // Gray-500
const Color kBorderColor = Color(0xFFF3E8D8);
const Color kErrorColor = Color(0xFFEF4444);

const LinearGradient kPrimaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kPrimaryLightColor, kPrimaryColor],
);

/// ================= ANIMATION =================
const Duration kAnimationDuration = Duration(milliseconds: 200);
const Duration kDefaultDuration = Duration(milliseconds: 250);

/// ================= TEXT STYLES =================
const TextStyle headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: kTextPrimaryColor,
  height: 1.4,
);

const TextStyle subtitleStyle = TextStyle(
  fontSize: 16,
  color: kTextSecondaryColor,
);

/// ================= FORM VALIDATION =================
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

const String kEmailNullError = "Please enter your email";
const String kInvalidEmailError = "Please enter a valid email";
const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords do not match";
const String kNameNullError = "Please enter your name";
const String kPhoneNumberNullError = "Please enter your phone number";
const String kAddressNullError = "Please enter your address";

/// ================= INPUT DECORATION =================
final InputDecoration otpInputDecoration = InputDecoration(
  filled: true,
  fillColor: kSurfaceColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
  focusedBorder: outlineInputBorder(focused: true),
  errorBorder: outlineInputBorder(error: true),
);

OutlineInputBorder outlineInputBorder({
  bool focused = false,
  bool error = false,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(
      color: error
          ? kErrorColor
          : focused
              ? kPrimaryColor
              : kBorderColor,
      width: focused ? 2 : 1,
    ),
  );
}
