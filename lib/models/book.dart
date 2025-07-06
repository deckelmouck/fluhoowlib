class Book {
  final int? id;
  final String title;
  final String author;
  final bool gelesen;
  final int bewertung;

  Book({this.id, required this.title, required this.author, required this.gelesen, required this.bewertung});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'gelesen': gelesen ? 1 : 0,
      'bewertung': bewertung,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      gelesen: map['gelesen'] == 1,
      bewertung: map['bewertung'],
    );
  }
}
