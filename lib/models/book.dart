class Book {
  final int? id;
  final String title;
  final String author;
  final bool readed;
  final int rating;
  final DateTime? publicationDate;
  final DateTime? finishedDate;
  final String? isbn;
  final bool borrowed;
  final String? borrowedBy;
  final DateTime? borrowedDate;
  final String? notes;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.readed,
    required this.rating,
    this.publicationDate,
    this.finishedDate,
    this.isbn,
    this.borrowed = false,
    this.borrowedBy,
    this.borrowedDate,
    this.notes,
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
      'isbn': isbn,
      'borrowed': borrowed ? 1 : 0,
      'borrowedBy': borrowedBy,
      'borrowedDate': borrowedDate?.toIso8601String(),
      'notes': notes,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      readed: map['readed'] == 1,
      rating: map['rating'],
      publicationDate: map['publicationDate'] != null
          ? DateTime.parse(map['publicationDate'])
          : null,
      finishedDate: map['finishedDate'] != null
          ? DateTime.parse(map['finishedDate'])
          : null,
      isbn: map['isbn'],
      borrowed: map['borrowed'] == 1,
      borrowedBy: map['borrowedBy'],
      borrowedDate: map['borrowedDate'] != null
          ? DateTime.parse(map['borrowedDate'])
          : null,
      notes: map['notes'],
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
    'borrowed': borrowed,
    'borrowedBy': borrowedBy,
    'borrowedDate': borrowedDate?.toIso8601String(),
    'notes': notes,
  };
}
