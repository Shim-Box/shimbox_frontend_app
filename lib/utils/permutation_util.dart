List<List<T>> permutations<T>(List<T> items) {
  if (items.length <= 1) return [items];
  final List<List<T>> result = [];
  for (int i = 0; i < items.length; i++) {
    final current = items[i];
    final remaining = [...items]..removeAt(i);
    for (final perm in permutations(remaining)) {
      result.add([current, ...perm]);
    }
  }
  return result;
}
