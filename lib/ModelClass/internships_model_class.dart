class Internship {
  final String title;
  final String companyName;
  final bool workFromHome;
  final String duration;
  final String stipend;
  final List<String> locationNames;
  final String profile;
  final String startDate;
  final String postalByLabel;
  final String ppoData;
  final String employmentType;
  final String logo;

  Internship(
      {required this.startDate,
      required this.title,
      required this.companyName,
      required this.workFromHome,
      required this.duration,
      required this.stipend,
      required this.locationNames,
      required this.profile,
      required this.postalByLabel,
      required this.ppoData,
      required this.employmentType,
      required this.logo});

  factory Internship.fromJson(Map<String, dynamic> json) {
    return Internship(
      title: json['title'] as String,
      companyName: json['company_name'] as String,
      workFromHome: json['work_from_home'] as bool,
      duration: json['duration'] as String,
      stipend: json['stipend']['salary'] as String,
      locationNames: List<String>.from(json['location_names']),
      profile: json['profile_name'] as String,
      startDate: json['start_date'] as String,
      postalByLabel: json['posted_by_label'] as String,
      ppoData: json["ppo_label_value"] as String,
      employmentType: json["employment_type"],
      logo: json["company_logo"],
    );
  }
}
