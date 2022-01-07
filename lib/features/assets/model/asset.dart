abstract class Asset {
  String code;
  int trailingDigits;
  String? name;

  Asset(this.code, this.trailingDigits, this.name);

  @override
  bool operator ==(Object other) {
    return (other is Asset) &&
        code == other.code &&
        trailingDigits == other.trailingDigits &&
        name == other.name;
  }

  @override
  int get hashCode => code.hashCode;
}
