extension LanguageListExtension on List {
  String displayLanguages() {
    if (this.isEmpty) return '';
    if (this.length == 1) return this[0];
    if (this.length == 2) return '${this[0]}/${this[1]}';

    return '${this[0]}/${this[1]} + ${this.length - 2}';
  }
}
