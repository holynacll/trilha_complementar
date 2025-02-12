import 'package:complemento/activity/controller.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'
    show ProfileScreen, SignedOutAction;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            .where((activity) => activity.title.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Activity>> activities =
        ref.watch(activityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                  ),
                ),
              );
            },
            tooltip: 'Profile',
          ),
        ],
        automaticallyImplyLeading: false,
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
                      borderRadius: BorderRadius.circular(16),
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
                              activity: activity,
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
