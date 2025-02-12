import 'package:complemento/activity/activity.dart';
import 'package:complemento/components/details_activity_page.dart';
import 'package:complemento/enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardProject extends StatelessWidget {
  const CardProject({
    super.key,
    required this.activity,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final logoImage = activity.logoImage.isNotEmpty
        ? Image.network(activity.logoImage, height: 150)
        : const Icon(Icons.image);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivityDetailsPage(activity: activity))),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge, // Use theme for styling
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                          '${dateFormat.format(activity.startDate)} até ${dateFormat.format(activity.endDate)}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 10),
                      Opacity(
                        opacity: 0.7,
                        child: Text(
                          'Carga Horária: ${activity.hours} horas',
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AspectRatio(aspectRatio: 7, child: logoImage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
