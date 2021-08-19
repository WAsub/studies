class ThemeType {
  const ThemeType(this._value);
  final String _value;
  String get value => _value;

  static const String _ROSE_VALUE = 'ROSE';
  static const String _SKY_VALUE = 'SKY';
  static const String _PASTEL_VALUE = 'PASTEL';

  static const ThemeType ROSE = ThemeType(_ROSE_VALUE);
  static const ThemeType SKY = ThemeType(_SKY_VALUE);
  static const ThemeType PASTEL = ThemeType(_PASTEL_VALUE);

  static List<ThemeType> values() {
    return [
      ThemeType.ROSE,
      ThemeType.SKY,
      ThemeType.PASTEL,
    ];
  }


  static ThemeType of(String theme) {
    return ThemeType.values().firstWhere((e) => e.toString() == theme,orElse: ()=> null);
  }

  String toString() {
    return this.value;
  }
}