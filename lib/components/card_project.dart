import 'package:flutter/material.dart';

class CardProject extends StatelessWidget {
  const CardProject({
    super.key,
    required this.logoImage,
    required this.title,
    required this.owner,
    required this.group,
    required this.modalidade,
    required this.hours,
    required this.startDate,
    required this.endDate,
  });

  final String title;
  final String owner;
  final String group;
  final String modalidade;
  final int hours;
  final String startDate;
  final String endDate;
  final Image logoImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => print('tapped'),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AspectRatio(aspectRatio: 7, child: logoImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge, // Use theme for styling
                    ),
                    const SizedBox(
                      height: 10,
                    ), // Use const SizedBox
                    Text(owner, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    Text('Grupo: $group',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    Text('Carga Horária: $hours',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    Text('Modalidade: $modalidade',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    Text('Data de Início: $startDate',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    Text('Data de Término: $endDate',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
