// utils/payment_utils.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/payment.dart';

/// Safely adds [monthsToAdd] to a [DateTime], handling month boundaries and leap years
DateTime addMonths(DateTime date, int monthsToAdd) {
  final totalMonths = date.month + monthsToAdd - 1;
  final year = date.year + (totalMonths ~/ 12);
  final month = (totalMonths % 12) + 1;
  final daysInTargetMonth = DateUtils.getDaysInMonth(year, month);
  final day = min(date.day, daysInTargetMonth);
  return DateTime(year, month, day, date.hour, date.minute, date.second);
}

DateTime computeNextDue(Client client, List<Payment> payments) {
  if (payments.isEmpty) return client.contractStartDate;
  final sorted = [...payments]..sort((a, b) => b.periodEnd.compareTo(a.periodEnd));
  return sorted.first.periodEnd;
}

bool isOverdue(Client client, List<Payment> payments) {
  return computeNextDue(client, payments).isBefore(DateTime.now());
}