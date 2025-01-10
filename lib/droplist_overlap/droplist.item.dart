class DropListItem<T> {
  int id;
  String nameSelected;
  String? flag;
  int? index;
  T? data;

  DropListItem(
      {required this.id,
      this.index,
      required this.nameSelected,
      this.flag,
      this.data});

  factory DropListItem.fromJson(Map<String, dynamic> json) {
    return DropListItem(
      id: json['id'] ?? 0,
      nameSelected: json['nameSelected'],
      flag: json['flag'],
      index: json['index'],
    );
  }

  void copyWith({
    String? nameSelected,
    int? id,
    int? index,
  }) {
    this.nameSelected = nameSelected ?? this.nameSelected;
    this.id = id ?? this.id;
    this.index = index ?? this.index;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DropListItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
