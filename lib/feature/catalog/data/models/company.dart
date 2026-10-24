class Company {
  const Company({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tagline,
    required this.logoAsset,
    this.logoOnDark = false,
    this.logoMarkOnly = false,
  });

  final String id;
  final String name;
  final String shortName;
  final String tagline;
  final String logoAsset;
  final bool logoOnDark;
  final bool logoMarkOnly;
}
