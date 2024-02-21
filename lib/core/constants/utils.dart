/// returns number of days in a year
int getNumberOfDaysElapsed(int year) {
  final currentDay = DateTime(year, DateTime.now().month, DateTime.now().day);
  final firstDayOfYear = DateTime(year);
  return currentDay.difference(firstDayOfYear).inDays;
}

/// returns number of days in a year
int getNumberOfDaysInYear(int year) {
  final firstDayOfYear = DateTime(year);
  final firstDayOfNextYear = DateTime(year + 1);
  return firstDayOfNextYear.difference(firstDayOfYear).inDays;
}
