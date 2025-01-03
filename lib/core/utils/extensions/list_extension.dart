extension ListRangeExtension<E> on List<E> {
  Iterable<E> safeSubRange(int start, int end) {
    // Validate input
    if (start < 0 || end < 0 || start > end) {
      throw ArgumentError('Invalid range: start must be <= end, and both >= 0');
    }
    // Adjust start and end to avoid out-of-bounds errors
    start = start.clamp(0, length);
    end = end.clamp(0, length);

    return getRange(start, end);
  }
}