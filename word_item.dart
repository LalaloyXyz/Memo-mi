class WordItem {
  final String word;
  final String meaning;
  final String emoji;
  WordItem(this.word, this.meaning, {required this.emoji});
}

final List<WordItem> easyWords = [
  WordItem('Apple', 'แอปเปิล', emoji: '🍎'),
  WordItem('Ball', 'ลูกบอล', emoji: '⚽'),
  WordItem('Cat', 'แมว', emoji: '🐱'),
  WordItem('Dog', 'สุนัข', emoji: '🐶'),
  WordItem('Egg', 'ไข่', emoji: '🥚'),
  WordItem('Fish', 'ปลา', emoji: '🐟'),
  WordItem('Goat', 'แพะ', emoji: '🐐'),
  WordItem('Hat', 'หมวก', emoji: '🎩'),
  WordItem('Ice', 'น้ำแข็ง', emoji: '🧊'),
  WordItem('Jam', 'แยม', emoji: '🍓'),
];

final List<WordItem> mediumWords = [
  WordItem('Beautiful', 'สวยงาม', emoji: '✨'),
  WordItem('Bottle', 'ขวด', emoji: '🍼'),
  WordItem('Camera', 'กล้อง', emoji: '📷'),
  WordItem('Dinner', 'อาหารเย็น', emoji: '🍽️'),
  WordItem('Elephant', 'ช้าง', emoji: '🐘'),
];

final List<WordItem> hardWords = [
  WordItem('Abandon', 'ละทิ้ง', emoji: '🏃‍♂️'),
  WordItem('Benevolent', 'ใจดีมีเมตตา', emoji: '🤲'),
  WordItem('Complicated', 'ซับซ้อน', emoji: '🧩'),
  WordItem('Determination', 'ความมุ่งมั่น', emoji: '💪'),
  WordItem('Enthusiastic', 'กระตือรือร้น', emoji: '🤩'),
];
