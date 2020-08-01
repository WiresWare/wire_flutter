class InputDTO {
  final String text;
  final String note;
  final bool completed;

  InputDTO(this.text, this.note, [this.completed = false]);
}
