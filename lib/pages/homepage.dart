import 'dart:async';
import 'dart:convert';
import 'package:assessment/ModelClass/internships_model_class.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'filter_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Internship>>? _internshipsFuture;
  List<Internship> internships = [];
  List<Internship> filteredInternships = [];
  List<String> selectedProfiles = [];
  List<String> selectedCities = [];
  List<String> selectedDurations = [];

  @override
  void initState() {
    super.initState();
    _internshipsFuture = fetchInternships();
  }

  Future<List<Internship>> fetchInternships() async {
    final response = await http
        .get(Uri.parse('https://internshala.com/flutter_hiring/search'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final internshipsData = data['internships_meta'] as Map<String, dynamic>;

      List<Internship> fetchedInternships = internshipsData.entries
          .map((entry) => Internship.fromJson(entry.value))
          .toList();

      internships = fetchedInternships;
      filteredInternships =
          List.from(internships); // Initially, no filters applied

      return fetchedInternships;
    } else {
      throw Exception('Failed to load internships');
    }
  }

  void applyFilters() {
    setState(() {
      filteredInternships = internships.where((internship) {
        final matchesProfile = selectedProfiles.isEmpty ||
            selectedProfiles
                .any((profile) => internship.title.contains(profile));
        final matchesCity = selectedCities.isEmpty ||
            selectedCities
                .any((city) => internship.locationNames.contains(city));
        final matchesDuration = selectedDurations.isEmpty ||
            selectedDurations
                .any((duration) => internship.duration.contains(duration));
        return matchesProfile && matchesCity && matchesDuration;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "Internships",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filters = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FiltersScreen(
                    selectedProfile: selectedProfiles,
                    locationData: selectedCities,
                    selectedDuration: selectedDurations,
                    profileOptions:
                        internships.map((i) => i.profile).toSet().toList(),
                    locationOptions: internships
                        .expand((i) => i.locationNames)
                        .toSet()
                        .toList(),
                    durationOptions:
                        internships.map((i) => i.duration).toSet().toList(),
                  ),
                ),
              );
              if (filters != null) {
                selectedProfiles = filters['profile'];
                selectedCities = filters['city'];
                selectedDurations = filters['duration'];
                applyFilters();
              }
            },
          ),
        ],
      ),
      drawer: const Drawer(),
      body: FutureBuilder<List<Internship>>(
        future: _internshipsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No internships found'));
          } else {
            return ListView.builder(
              itemCount: filteredInternships.length,
              itemBuilder: (context, index) {
                final internship = filteredInternships[index];
                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            internship.title.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            internship.companyName.toString(),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          internship.workFromHome
                              ? const RowOnCard(
                                  icon: Icons.home_outlined,
                                  text: "Work from home",
                                )
                              : RowOnCard(
                                  icon: Icons.location_on_outlined,
                                  text: internship.locationNames[0].toString(),
                                ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              RowOnCard(
                                icon: Icons.play_circle_outline_outlined,
                                text: internship.startDate.toString(),
                              ),
                              const SizedBox(width: 15),
                              RowOnCard(
                                icon: Icons.calendar_today_outlined,
                                text: internship.duration.toString(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey[350],
                                ),
                                child: Text(internship.employmentType),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey[350],
                                ),
                                child: Text(internship.ppoData),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey[350],
                                ),
                                child: RowOnCard(
                                  icon: Icons.history,
                                  text: internship.postalByLabel.toString(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class RowOnCard extends StatelessWidget {
  final String text;
  final IconData icon;
  const RowOnCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color.fromARGB(255, 102, 101, 101),
        ),
        Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 39, 39, 39),
          ),
        ),
      ],
    );
  }
}
