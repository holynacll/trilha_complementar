import 'package:complemento/enums.dart';

String mapEnumToString(ActivityGroup group) {
  switch (group) {
    case ActivityGroup.ensino:
      return 'Grupo I. Ensino';
    case ActivityGroup.pesquisa:
      return 'Grupo II. Pesquisa';
    case ActivityGroup.extensao:
      return 'Grupo III. Extensão';
    case ActivityGroup.vivenciaProfissional:
      return 'Grupo IV. Vivência Profissional';
    case ActivityGroup.eventosTecnicosCientificos:
      return 'Grupo V. Eventos Técnicos Científicos';
    case ActivityGroup.intervencaoOrganizacional:
      return 'Grupo VI. Intervenção Organizacional';
    case ActivityGroup.representacaoEstudantil:
      return 'Grupo VII. Representação Estudantil';
    case ActivityGroup.formacaoInterdisciplinar:
      return 'Grupo VIII. Formação Interdisciplinar';
  }
}
