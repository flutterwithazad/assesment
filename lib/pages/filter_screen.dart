import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  final List<String>? selectedProfile;
  final List<String>? locationData;
  final List<String>? selectedDuration;
  final List<String> profileOptions;
  final List<String> locationOptions;
  final List<String> durationOptions;

  const FiltersScreen({
    super.key,
    this.selectedProfile,
    this.locationData,
    this.selectedDuration,
    required this.profileOptions,
    required this.locationOptions,
    required this.durationOptions,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  Set<String> currentSelectedProfiles = {};
  Set<String> currentSelectedCities = {};
  Set<String> currentSelectedDurations = {};

  @override
  void initState() {
    super.initState();
    if (widget.selectedProfile != null) {
      currentSelectedProfiles = widget.selectedProfile!.toSet();
    }
    if (widget.locationData != null) {
      currentSelectedCities = widget.locationData!.toSet();
    }
    if (widget.selectedDuration != null) {
      currentSelectedDurations = widget.selectedDuration!.toSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, {
                'profile': currentSelectedProfiles.toList(),
                'city': currentSelectedCities.toList(),
                'duration': currentSelectedDurations.toList(),
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSection(
              title: "Profile",
              options: widget.profileOptions,
              selectedOptions: currentSelectedProfiles,
            ),
            _buildFilterSection(
              title: "Location",
              options: widget.locationOptions,
              selectedOptions: currentSelectedCities,
            ),
            _buildFilterSection(
              title: "Duration",
              options: widget.durationOptions,
              selectedOptions: currentSelectedDurations,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required Set<String> selectedOptions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: double.infinity,
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = selectedOptions.contains(option);
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: Colors.purple,
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
