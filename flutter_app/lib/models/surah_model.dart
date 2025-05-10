class SurahModel {
  final int id;
  final String name;
  final String nameArabic;
  final String meaning;
  final int numberOfAyahs;
  final int juz;
  final String revelationType; // "Meccan" or "Medinan"
  final int order;
  final int level; // Difficulty level for memorization (1-5)

  SurahModel({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.meaning,
    required this.numberOfAyahs,
    required this.juz,
    required this.revelationType,
    required this.order,
    required this.level,
  });

  // Create a Surah from a map (for Firestore or JSON)
  factory SurahModel.fromMap(Map<String, dynamic> map) {
    return SurahModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      nameArabic: map['nameArabic'] ?? '',
      meaning: map['meaning'] ?? '',
      numberOfAyahs: map['numberOfAyahs'] ?? 0,
      juz: map['juz'] ?? 0,
      revelationType: map['revelationType'] ?? '',
      order: map['order'] ?? 0,
      level: map['level'] ?? 1,
    );
  }

  // Convert the Surah to a map for Firestore or JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameArabic': nameArabic,
      'meaning': meaning,
      'numberOfAyahs': numberOfAyahs,
      'juz': juz,
      'revelationType': revelationType,
      'order': order,
      'level': level,
    };
  }

  // Create a list of all Surahs in the Quran
  static List<SurahModel> getAllSurahs() {
    return [
      SurahModel(
        id: 1,
        name: "Al-Fatihah",
        nameArabic: "الفاتحة",
        meaning: "The Opening",
        numberOfAyahs: 7,
        juz: 1,
        revelationType: "Meccan",
        order: 5,
        level: 1,
      ),
      SurahModel(
        id: 2,
        name: "Al-Baqarah",
        nameArabic: "البقرة",
        meaning: "The Cow",
        numberOfAyahs: 286,
        juz: 1,
        revelationType: "Medinan",
        order: 87,
        level: 5,
      ),
      SurahModel(
        id: 3,
        name: "Ali 'Imran",
        nameArabic: "آل عمران",
        meaning: "Family of Imran",
        numberOfAyahs: 200,
        juz: 3,
        revelationType: "Medinan",
        order: 89,
        level: 5,
      ),
      SurahModel(
        id: 4,
        name: "An-Nisa",
        nameArabic: "النساء",
        meaning: "The Women",
        numberOfAyahs: 176,
        juz: 4,
        revelationType: "Medinan",
        order: 92,
        level: 5,
      ),
      SurahModel(
        id: 5,
        name: "Al-Ma'idah",
        nameArabic: "المائدة",
        meaning: "The Table Spread",
        numberOfAyahs: 120,
        juz: 6,
        revelationType: "Medinan",
        order: 112,
        level: 4,
      ),
      // Add more surahs as needed
      SurahModel(
        id: 112,
        name: "Al-Ikhlas",
        nameArabic: "الإخلاص",
        meaning: "Sincerity",
        numberOfAyahs: 4,
        juz: 30,
        revelationType: "Meccan",
        order: 22,
        level: 1,
      ),
      SurahModel(
        id: 113,
        name: "Al-Falaq",
        nameArabic: "الفلق",
        meaning: "The Daybreak",
        numberOfAyahs: 5,
        juz: 30,
        revelationType: "Meccan",
        order: 20,
        level: 1,
      ),
      SurahModel(
        id: 114,
        name: "An-Nas",
        nameArabic: "الناس",
        meaning: "Mankind",
        numberOfAyahs: 6,
        juz: 30,
        revelationType: "Meccan",
        order: 21,
        level: 1,
      ),
    ];
  }

  // Get surahs by memorization level
  static List<SurahModel> getSurahsByLevel(int level) {
    return getAllSurahs().where((surah) => surah.level == level).toList();
  }

  // Get surahs by juz
  static List<SurahModel> getSurahsByJuz(int juz) {
    return getAllSurahs().where((surah) => surah.juz == juz).toList();
  }
}