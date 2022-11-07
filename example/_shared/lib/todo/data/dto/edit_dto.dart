import 'package:wire_example_shared/todo/data/base/dto.dart';

class EditDTO extends DTO {
  EditDTO(this.id, this.text, this.note);

  final String text;
  final String note;
  final String id;
}
