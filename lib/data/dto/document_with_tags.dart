import 'package:archivey/data/drift/app_database.dart';

class DocumentWithTags {
  final DocumentEntity documentEntity;
  final List<String> tags;

  DocumentWithTags({
    required this.documentEntity,
    tags
  }): tags = tags ?? [];



  // Document toDocument(){
  //
  // }
  //
  // void fromDocumnet(Document document){
  //   // this.documentEntity=document.toEntity();
  //   this.documentEntity=_toEntity(document);
  //   this.tags=document.tags;
  // }
  // DocumentEntity _toEntity(Document document){
  //
  // }
}
