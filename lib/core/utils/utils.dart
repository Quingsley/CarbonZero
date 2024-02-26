/// Returns a hash code for a [DateTime] object.
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
