class TodoVO {
  TodoVO(this.id, this.text, this.note, this.completed);
  TodoVO.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as String,
        text = json['text'] as String,
        note = json['note'] as String,
        completed = json['completed'] as bool;

  bool completed;
  String text;
  String note;
  String id;

  bool visible = true;

  Map<dynamic, dynamic> toJson() => {'id': id, 'text': text, 'note': note, 'completed': completed};
}
