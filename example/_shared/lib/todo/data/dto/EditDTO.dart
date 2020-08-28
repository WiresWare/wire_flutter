import '../base/DTO.dart';

class EditDTO extends DTO {
  final String text;
  final String note;
  final String id;

  EditDTO(this.id, this.text, this.note);
}
