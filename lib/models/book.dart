class Book {
  final int? id;
  final String title;
  final String author;
  final bool readed;
  final int rating;
  final DateTime? publicationDate;
  final DateTime? finishedDate;
  final String? isbn;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.readed,
    required this.rating,
    this.publicationDate,
    this.finishedDate,
    this.isbn
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'readed': readed ? 1 : 0,
      'rating': rating,
      'publicationDate': publicationDate?.toIso8601String(),
      'finishedDate': finishedDate?.toIso8601String(),
      'isbn': isbn
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      readed: map['readed'] == 1,
      rating: map['rating'],
      publicationDate: map['publicationDate'] != null ? DateTime.parse(map['publicationDate']) : null,
      finishedDate: map['finishedDate'] != null ? DateTime.parse(map['finishedDate']) : null,
      isbn: map['isbn'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'readed': readed,
    'rating': rating,
    'publicationDate': publicationDate?.toIso8601String(),
    'finishedDate': finishedDate?.toIso8601String(),
    'isbn': isbn,
  };
}
