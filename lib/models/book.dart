class Book {
  final int? id;
  final String title;
  final String author;
  final bool readed;
  final int rating;

  Book({this.id, required this.title, required this.author, required this.readed, required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'readed': readed ? 1 : 0,
      'rating': rating,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      readed: map['readed'] == 1,
      rating: map['rating'],
    );
  }
}
