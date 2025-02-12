import 'package:complemento/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:complemento/activity/activity.dart';
import 'package:complemento/enums.dart';
import 'package:complemento/utils.dart';
import 'package:intl/intl.dart';

class EditActivityPage extends StatefulWidget {
  final Activity activity;

  const EditActivityPage({super.key, required this.activity});

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  final _formKey = GlobalKey<FormState>();
  String? _uploadedImageUrl;
  final S3UploadService _s3Service = S3UploadService();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _hoursController;
  late TextEditingController _urlController;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  late ActivityGroup _selectedGroup;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Preenche os controladores com os dados da atividade
    _titleController = TextEditingController(text: widget.activity.title);
    _descriptionController =
        TextEditingController(text: widget.activity.description);
    _addressController = TextEditingController(text: widget.activity.address);
    _hoursController =
        TextEditingController(text: widget.activity.hours.toString());
    _urlController = TextEditingController(text: widget.activity.url);
    _selectedGroup = widget.activity.group;
    _startDate = widget.activity.startDate;
    _endDate = widget.activity.endDate;
  }

  Future<void> _uploadImage() async {
    final imageUrl = await _s3Service.uploadImageToS3();

    if (imageUrl != null) {
      setState(() {
        _uploadedImageUrl = imageUrl;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao fazer upload')),
      );
    }
  }

  // Função para exibir o DatePicker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? _startDate : _endDate;
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (newDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = newDate;
          // Se a data de término for antes da data de início, limpa a data de término
          // if (_endDate.isBefore(_startDate)) {
          //   _endDate = null;
          // }
        } else {
          _endDate = newDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Atividade'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              OutlinedButton(
                onPressed: _uploadImage,
                child: const Text('Fazer Upload da Imagem da Atividade'),
              ),
              const SizedBox(height: 16),

              // Exibir imagem carregada
              if (_uploadedImageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _uploadedImageUrl!,
                    height: 150,
                    // width: double.infinity,
                    fit: BoxFit.none,
                  ),
                ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título*',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 200,
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.start,
                  controller: _descriptionController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Escreva uma descrição da atividade',
                      labelText: 'Descrição'),
                  validator: (value) => value!.isEmpty
                      ? 'Informe a descrição da atividade'
                      : null,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownButtonFormField(
                value: _selectedGroup,
                decoration: const InputDecoration(labelText: 'Grupo*'),
                // controller: _groupController,
                items: ActivityGroup.values.map((ActivityGroup group) {
                  return DropdownMenuItem<ActivityGroup>(
                      value: group, child: Text(mapEnumToString(group)));
                }).toList(),
                onChanged: (ActivityGroup? newValue) {
                  setState(() {
                    _selectedGroup = newValue!;
                  });
                },
                validator: (value) => value == null ? 'Informe o grupo' : null,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(labelText: 'Carga horária*'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Informe as horas' : null,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Data de Início*',
                  suffixIcon: Icon(Icons.calendar_today),
                  hintText: 'Selecione a data de início',
                ),
                onTap: () => _selectDate(context, true),
                controller: TextEditingController(
                  text:
                      _startDate != null ? _dateFormat.format(_startDate!) : '',
                ),
                validator: (_) =>
                    _startDate == null ? 'Informe a data de início' : null,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Data de Término*',
                  suffixIcon: Icon(Icons.calendar_today),
                  hintText: 'Selecione a data de término',
                ),
                onTap: () => _selectDate(context, false),
                controller: TextEditingController(
                  text: _endDate != null ? _dateFormat.format(_endDate!) : '',
                ),
                validator: (_) => _endDate == null
                    ? 'Informe a data de término'
                    : (_startDate != null && _endDate!.isBefore(_startDate!))
                        ? 'A data de término não pode ser anterior à data de início'
                        : null,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                    labelText: 'Link para a página da atividade'),
              ),

              // Botão de salvar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Atualiza a atividade com os novos dados
                    final updatedActivity = Activity(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      group: _selectedGroup,
                      address: _addressController.text,
                      hours: int.parse(_hoursController.text),
                      url: _urlController.text,
                      startDate: _startDate,
                      endDate: _endDate,
                      logoImage: widget.activity.logoImage,
                    );

                    // Atualiza a atividade no Provider ou Riverpod
                    // ref.read(activityControllerProvider.notifier).updateActivity(updatedActivity);

                    // Navega de volta
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
