import 'package:complemento/activity/controller.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'
    show ProfileScreen, SignedOutAction;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'activity/activity.dart';
import 'components/card_project.dart';
import 'components/create_project_page.dart'; // Import for date formatting

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Activity> _filteredActivities = [];
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filteredActivitiesSearch);
  }

  void _filteredActivitiesSearch() {
    final query = _searchController.text.toLowerCase();
    final activities = ref.read(activityControllerProvider).value ?? [];
    if (activities.isNotEmpty) {
      setState(() {
        _filteredActivities = activities
            .where((activity) =>
                activity.title.toLowerCase().contains(query) ||
                activity.group.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  Widget build(BuildContext context) {
    final logoImage = Image.asset('images/logo-ic.png',
        errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.error); // Handle image loading errors
    });
    final AsyncValue<List<Activity>> activities =
        ref.watch(activityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text('Olá, Alexandre'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  // Specify void for no return value
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(title: const Text('User Profile')),
                    actions: [
                      SignedOutAction((context) => Navigator.of(context).pop())
                    ],
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: logoImage, // Use the logoImage variable
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            tooltip: 'Profile',
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    labelText: 'Pesquisar',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ))),
            SizedBox(height: 16),
            activities.when(
              data: (value) {
                if (value.isEmpty ||
                    (_searchController.text.isNotEmpty &&
                        _filteredActivities.isEmpty)) {
                  return const Text('Nenhuma evento encontrado.');
                }

                final displayList =
                    _filteredActivities.isEmpty ? value : _filteredActivities;

                return Expanded(
                  child: ListView(
                    children: displayList
                        .map((activity) => CardProject(
                              logoImage: Image.asset('images/logo-ic.png'),
                              title: activity.title,
                              owner: activity.owner,
                              group: activity.group,
                              modalidade: activity.modalidade,
                              hours: activity.hours,
                              startDate: _dateFormat.format(activity.startDate),
                              endDate: _dateFormat.format(activity.endDate),
                            ))
                        .toList(),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => SelectableText('Erro: $error'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const CreateProjectPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
