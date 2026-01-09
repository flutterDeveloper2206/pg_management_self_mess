import 'package:get/get.dart';

class MenuScreenController extends GetxController {
  var selectedDay = 'Mon'.obs;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];



  final Map<String, Map<String, String>> menuData = {
    'Mon': {
      'breakfast': 'Poha',
      'lunch': 'Dal, Rice & Roti',
      'dinner': 'Khichdi',
    },
    'Tue': {
      'breakfast': 'Idli Sambhar',
      'lunch': 'Paneer & Chapati',
      'dinner': 'Veg Pulao',
    },
    'Wed': {
      'breakfast': 'Aloo Paratha',
      'lunch': 'Mixed Veg & Roti',
      'dinner': 'Dal Khichdi',
    },
    'Thu': {
      'breakfast': 'Upma',
      'lunch': 'Rajma Rice',
      'dinner': 'Bhindi & Chapati',
    },
    'Fri': {
      'breakfast': 'Dosa',
      'lunch': 'Chole Bhature',
      'dinner': 'Egg Curry & Rice',
    },
    'Sat': {
      'breakfast': 'Puri Bhaji',
      'lunch': 'Kadahi Paneer',
      'dinner': 'Tarka Dal & Rice',
    },
    'Sun': {
      'breakfast': 'Sandwich',
      'lunch': 'Special Biryani',
      'dinner': 'Pasta',
    },
  };

  void selectDay(String day) {
    selectedDay.value = day;
  }

  Map<String, String> get currentDayMenu => menuData[selectedDay.value] ?? {};
}
