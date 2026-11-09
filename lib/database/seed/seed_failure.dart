final class SeedFailure implements Exception {
  const SeedFailure(this.file, this.field, [this.cause]);

  final String file;
  final String field;
  final Object? cause;

  @override
  String toString() =>
      'SeedFailure: $file field "$field" is invalid'
      '${cause == null ? '' : ': $cause'}';
}
