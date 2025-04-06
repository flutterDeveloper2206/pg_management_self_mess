
/// Checks if string consist only Alphabet. (No Whitespace)
bool isText(
  String? inputString, {
  bool isRequired = false,
}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^[a-zA-Z]+$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}




/// [ValidationHelpers] is an abstract class for manage validation
///
/// of the whole application
abstract class ValidationHelpers {
  /// Reg exp Patterns
  static const String _patternEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static const String _patternUpi =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]";

  static const String patternPhone =
      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';

  /// Check value is Empty OR Not
  static String? emptyCheck(String? value, String errorMessage) {
    if (value!.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  ///
  static String? checkPincode(String? value) {
    if (value!.trim().isEmpty) {
      return ('enter_pincode');
    }
    if (value.trim().length < 6) {
      return ('pincode_validation');
    }
    return null;
  }


  /// Check name field
  static String? nameField(String? value) {
    if (value!.trim().isEmpty) {
      return ('enter_name');
    }
    if (value.trim().length < 3) {
      return ('enter_more_char');
    }
    return null;
  }

  /// Check value is More than 10 Characters
  static String? tenCharacterValidate(String? value) {
    if (value!.trim().isEmpty) {
      return ('enter_mobile_number');
    }

    if (!isNumeric(value)) {
      return ('enter_valid_number');
    }

    if (value.trim().length < 10) {
      return ('mobile_10_char');
    }
    return null;
  }

  /// Check value is More than 8 Characters
  static String? passwordCheckValidate(String? value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$');
    if (value!.trim().isEmpty) {
      return ('p_enter_pass');
    } else if (!regex.hasMatch(value)) {
      return ('p_valid_8');
    } else if (value.trim().length < 8) {
      return ('pass_8');
    }
    return null;
  }

  /// Check dropdown not empty
  static String? dropdownValidate(value) {
    if (value == null) {
      return ('select_subject');
    }

    return null;
  }

  static String? dropdownTextFieldValidate(String? value) {
    if (value!.trim().isEmpty) {
      return ('p_type_message');
    }

    return null;
  }

  static String? confirmPasswordValidate(String? value) {
    return ('p_not_match');
  }

  static bool isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  /// email or phone validate
  static String? emailOrPhoneNoValidate(String? value) {
    RegExp regEmail = RegExp(_patternEmail);
    RegExp regPhone = RegExp(patternPhone);

    if (value!.trim().isNotEmpty) {
      if (isNumeric(value)) {
        if (!regPhone.hasMatch(value)) {
          return ('enter_valid_number');
        }
        return null;
      } else {
        if (!regEmail.hasMatch(value)) {
          return ('enter_valid_emil');
        }
        return null;
      }
    }
    return ('enter_email_phone');
  }

  /// Credit / Debit card validations
  ///  Card number validation
  static String? creditCardNumberValidation(String? value) {
    if (value != null) {
      if (!isNumeric(value.replaceAll(' ', ''))) {
        return ('enter_only_number');
      }
      if (isNumeric(value.replaceAll(' ', '')) && value.length != 19) {
        return ('enter_valid_card');
      }
    } else if (value == null || value.isEmpty) {
      return ('enter_card_no');
    }
    return null;
  }

  ///  Card CVV validation
  static String? creditCardCVVValidation(String? value) {
    if (value != null) {
      if (!isNumeric(value)) {
        return ('enter_valid_cvv');
      }
      if (isNumeric(value) && value.length != 3) {
        return ('enter_valid_cvv');
      }
    } else if (value == null || value.isEmpty) {
      return ('enter_cvv');
    }
    return null;
  }

  ///  Card Expiry validation
  static String? creditCardExpiryValidation(String? value) {
    if (value != null) {
      if (value.length != 7) {
        return ('enter_valid_exDate');
      }
    } else if (value == null || value.isEmpty) {
      return ('enter_exDate');
    }
    return null;
  }

  ///  UPI ID validation
  static String? upiIdValidation(String? value) {
    RegExp regUpi = RegExp(_patternUpi);

    if (value != null) {
      if (!regUpi.hasMatch(value)) {
        return ('enter_valid_UPI');
      }
    } else if (value == null || value.isEmpty) {
      return ('enter_upi');
    }
    return null;
  }
}
