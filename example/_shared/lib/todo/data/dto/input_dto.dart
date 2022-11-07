import 'package:wire_example_shared/todo/data/base/dto.dart';

class InputDTO extends DTO {
  InputDTO(this.text, this.note, [this.completed = false]);

  final String text;
  final String note;
  final bool completed;
}
