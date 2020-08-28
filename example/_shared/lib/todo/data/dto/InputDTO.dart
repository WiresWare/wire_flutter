import '../base/DTO.dart';

class InputDTO extends DTO {
  final String text;
  final String note;
  final bool completed;

  InputDTO(this.text, this.note, [this.completed = false]);
}
