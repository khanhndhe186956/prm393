import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  static final _date = DateFormat('dd/MM/yyyy');
  static final _month = DateFormat('MM/yyyy');
  static final _dateTime = DateFormat('dd/MM/yyyy HH:mm');

  static String currency(double amount) => _currency.format(amount);
  static String date(DateTime value) => _date.format(value);
  static String month(DateTime value) => _month.format(value);
  static String dateTime(DateTime value) => _dateTime.format(value);
}
