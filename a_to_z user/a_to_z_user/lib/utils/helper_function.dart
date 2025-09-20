import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

getFormattedDate(DateTime dt, {String pattern = 'dd/MM/YYYY'}) =>
        DateFormat(pattern).format(dt);

String get generateOrderId => 
          'ABC_${getFormattedDate(DateTime.now(), pattern: 'YYYYMMdd_HH:mm:ss')}';