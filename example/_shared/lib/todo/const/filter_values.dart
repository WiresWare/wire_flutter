enum FilterValues {
  ALL('all'),
  ACTIVE('active'),
  COMPLETED('completed');

  const FilterValues(this.value);
  final String value;

  String toJson() => value;
}
