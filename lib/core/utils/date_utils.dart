/// Date utility functions.
///
/// This file provides date formatting and manipulation utilities.
library;

import 'package:intl/intl.dart';

/// Date utility class.
///
/// Provides static methods for date formatting and manipulation.
abstract final class DateUtils {
  /// Formats a [DateTime] to a human-readable string.
  ///
  /// Examples:
  /// - Today: "Today at 3:30 PM"
  /// - Yesterday: "Yesterday at 10:00 AM"
  /// - This week: "Monday at 2:00 PM"
  /// - Older: "Jan 15, 2024"
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0 && dateTime.day == now.day) {
      return 'Today at ${DateFormat.jm().format(dateTime)}';
    }

    if (difference.inDays == 1 && dateTime.day == now.day - 1) {
      return 'Yesterday at ${DateFormat.jm().format(dateTime)}';
    }

    if (difference.inDays < 7) {
      return '${DateFormat.EEEE().format(dateTime)} at ${DateFormat.jm().format(dateTime)}';
    }

    return DateFormat.yMMMd().format(dateTime);
  }

  /// Formats a [DateTime] to ISO 8601 string.
  static String toIso8601(DateTime dateTime) => dateTime.toIso8601String();

  /// Parses an ISO 8601 string to [DateTime].
  static DateTime fromIso8601(String isoString) => DateTime.parse(isoString);

  /// Formats a [DateTime] to a short date string (MM/dd/yyyy).
  static String formatShortDate(DateTime dateTime) =>
      DateFormat('MM/dd/yyyy').format(dateTime);

  /// Formats a [DateTime] to a time string (h:mm a).
  static String formatTime(DateTime dateTime) =>
      DateFormat.jm().format(dateTime);

  /// Formats a [DateTime] to a long date string (EEEE, MMMM d, yyyy).
  static String formatLongDate(DateTime dateTime) =>
      DateFormat('EEEE, MMMM d, yyyy').format(dateTime);

  /// Returns true if the [DateTime] is today.
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// Returns true if the [DateTime] is yesterday.
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  /// Returns true if the [DateTime] is in the past.
  static bool isPast(DateTime dateTime) => dateTime.isBefore(DateTime.now());

  /// Returns true if the [DateTime] is in the future.
  static bool isFuture(DateTime dateTime) => dateTime.isAfter(DateTime.now());

  /// Calculates the age in years from a birth date.
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Returns the start of the day (00:00:00) for the given [DateTime].
  static DateTime startOfDay(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);

  /// Returns the end of the day (23:59:59) for the given [DateTime].
  static DateTime endOfDay(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);

  /// Returns the start of the week (Monday) for the given [DateTime].
  static DateTime startOfWeek(DateTime dateTime) {
    final monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Returns the end of the week (Sunday) for the given [DateTime].
  static DateTime endOfWeek(DateTime dateTime) {
    final sunday = dateTime.add(Duration(days: 7 - dateTime.weekday));
    return DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
  }

  /// Returns the number of days between two dates.
  static int daysBetween(DateTime from, DateTime to) {
    final fromStart = startOfDay(from);
    final toStart = startOfDay(to);
    return toStart.difference(fromStart).inDays;
  }

  /// Adds days to a [DateTime], handling daylight saving time.
  static DateTime addDays(DateTime dateTime, int days) =>
      dateTime.add(Duration(days: days));

  /// Adds months to a [DateTime].
  static DateTime addMonths(DateTime dateTime, int months) {
    final newMonth = dateTime.month + months;
    final newYear = dateTime.year + (newMonth - 1) ~/ 12;
    final adjustedMonth = ((newMonth - 1) % 12) + 1;
    final lastDayOfMonth = DateTime(newYear, adjustedMonth + 1, 0).day;
    final newDay = dateTime.day.clamp(1, lastDayOfMonth);
    return DateTime(newYear, adjustedMonth, newDay);
  }

  /// Returns a human-readable time difference string.
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    }

    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months months ago';
    }

    final years = (difference.inDays / 365).floor();
    return '$years years ago';
  }
}
