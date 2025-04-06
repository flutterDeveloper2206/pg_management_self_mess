import 'package:intl/intl.dart';



class AppDateFormats {
  static const String DATE_FORMAT_SERVER = "yyyy-MM-DDTHH:mm:ss.SSSSSSZ";
  static const String DATE_FORMAT_YYYY_MM_SS_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";
  static const String DATE_FORMAT_YYYY_MM_SS_HH_MM_SSS = "yyyy-MM-dd HH:mm:sss";

  static const String DATE_FORMAT_DD_MM_YYYY = "dd/MM/yyyy";
  static const String DATE_DOT_FORMAT_DD_MM_YYYY = "dd.MM.yyyy";
  static const String DATE_FORMAT_DD_MM_YYYY_DES = "dd-MM-yyyy";
  static const String DATE_FORMAT_DD_M_YYYY = "dd/M/yyyy";
  static const String DATE_FORMAT_YYYY_MM_DD = "yyyy-MM-dd";
  static const String DATE_FORMAT_MM_YYYY = "MM/yyyy";
  static const String DATE_FORMAT_MMM_YYYY = "MMMM yyyy";
  static const String DATE_FORMAT_MMM_Y = "MMM y";
  static const String DATE_FORMAT_DD_MMM = "dd MMM";
  static const String DATE_FORMAT_DD_MMM_COMMA_YYYY = "d MMM, y";
  static const String DATE_FORMAT_DD = "dd";
  static const String DATE_FORMAT_D = "d";
  static const String DATE_FORMAT_MMM = "MMM";
  static const String DATE_FORMAT_HH_MM_A = "hh:mm a";
  static const String DATE_FORMAT_HH_MM_SS = "HH:mm:ss";
  static const String DATE_FORMAT_HH_MM = "HH:mm";
  static const String DATE_FORMAT_EE = "EE";
  static const dateFormater_with_th_do_mmmm_yyyy_hh_mm = "do MMM, yyyy";
  static const String APP_PLAN_DATE_FORMAT_EE = "| EE | dd MMM";


}

// String dateToAgoFormat(String dateTime, String inputFormat) {
//   DateTime tempDate = DateTime.now();
//   if (dateTime.isNotEmpty) {
//     tempDate = DateFormat(inputFormat).parse(dateTime);
//   }
//   return timeago.format(tempDate);
// }

String getCurrentDate() {
  return DateFormat(AppDateFormats.DATE_FORMAT_YYYY_MM_DD)
      .format(DateTime.now());
}

String getCurrentTime() {
  return DateFormat(AppDateFormats.DATE_FORMAT_HH_MM).format(DateTime.now());
}




// String changeDateFormatWithSTRDTH(
//     String? dates, String inputFormat, String outputFormat) {
//   if (dates != null) {
//     // DateTime tempDate = new DateFormat(inputFormat).parse(dates);
//     // String fd = DateFormat(
//     //   inputFormat,
//     // ).format(tempDate.toLocal());
//     return Jiffy(dates, inputFormat).format(outputFormat);
//   }
//   return "";
// }


String changeDateFormat(
    String? dateTime, String inputFormat, String outputFormat) {
  DateTime inputDate = DateTime.now();
  if (dateTime!=null && dateTime.isNotEmpty) {
    inputDate = DateFormat(inputFormat).parse(dateTime);
  }
  return DateFormat(outputFormat).format(inputDate);
}

bool showTimer(val) {
  return DateTime.now().compareTo(
      DateFormat(AppDateFormats.DATE_FORMAT_DD_MM_YYYY).parse(val)) ==
      -1;
}

bool checkCurrentDate(val) {
  return DateTime.now().compareTo(
      DateFormat(AppDateFormats.DATE_FORMAT_DD_MM_YYYY).parse(val)) >
      0;
}

String hhMm(val) {
  if (val != null) {
    var inputFormat = DateFormat(AppDateFormats.DATE_FORMAT_HH_MM_SS);
    var invoiceDates = inputFormat.parse(val);
    var outputFormat = DateFormat(AppDateFormats.DATE_FORMAT_HH_MM_A);
    return outputFormat.format(invoiceDates);
  }
  return "";
}

/// Returns the suffix for the given number, such as 'st' for 1 or 'th' for 11.
String getSuffix(int number) {
  if (number % 100 >= 11 && number % 100 <= 13) {
    return 'th';
  } else {
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}