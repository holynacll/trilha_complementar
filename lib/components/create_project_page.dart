import 'package:complemento/activity/activity.dart';
import 'package:complemento/activity/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateProjectPage extends ConsumerStatefulWidget {
  const CreateProjectPage({super.key});

  @override
  ConsumerState<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends ConsumerState<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _modalidadeController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

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
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = newDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Nova Atividade Complementar')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: _ownerController,
                decoration: const InputDecoration(labelText: 'Proprietário'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o proprietário' : null,
              ),
              TextFormField(
                controller: _groupController,
                decoration: const InputDecoration(labelText: 'Grupo'),
                validator: (value) => value!.isEmpty ? 'Informe o grupo' : null,
              ),
              TextFormField(
                controller: _modalidadeController,
                decoration: const InputDecoration(labelText: 'Modalidade'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a modalidade' : null,
              ),
              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(labelText: 'Horas'),
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
                  labelText: 'Data de Início',
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
                  labelText: 'Data de Término',
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newActivity = Activity(
                      title: _titleController.text,
                      owner: _ownerController.text,
                      group: _groupController.text,
                      modalidade: _modalidadeController.text,
                      hours: int.parse(_hoursController.text),
                      startDate: _startDate!,
                      endDate: _endDate!,
                      logoImage: 'images/logo-ic.png',
                    );
                    await ref
                        .read(activityControllerProvider.notifier)
                        .addActivity(newActivity);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar Atividade'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
