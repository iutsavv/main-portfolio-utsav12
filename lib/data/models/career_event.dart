import 'package:flutter/material.dart';

@immutable
class CareerEvent {
  const CareerEvent({
    required this.year,
    required this.title,
    required this.description,
    required this.icon,
    this.company,
    this.location,
  });
  final int year;
  final String title;
  final String description;
  final IconData icon;
  final String? company;
  final String? location;

  static List<CareerEvent> get sampleEvents => [
    const CareerEvent(
      year: 2022,
      title: 'Head of Coding Club',
      description:
          'Led the Coding Club at NIT Manipur and began MERN stack development through a web app internship.',
      icon: Icons.code,
      company: 'Qubit Coding Club',
      location: 'NIT Manipur, Imphal',
    ),
    const CareerEvent(
      year: 2024,
      title: 'MERN Stack Developer',
      description:
          "Actively involved in the maintenance and development of Collega's Application Java Project Olibs Backend 724.",
      icon: Icons.code,
      company: 'NovaNectar',
      location: 'Remote',
    ),
    const CareerEvent(
      year: 2025,
      title: 'Training and Placement Coordinator',
      description:
          'Serving as the Training and Placement Coordinator at NIT Manipur, facilitating campus recruitment and student career development.',
      icon: Icons.work,
      company: 'NIT Manipur',
      location: 'NIT Manipur, Imphal',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareerEvent &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          title == other.title &&
          description == other.description &&
          icon == other.icon &&
          company == other.company &&
          location == other.location;

  @override
  int get hashCode =>
      year.hashCode ^ title.hashCode ^ description.hashCode ^ icon.hashCode ^ company.hashCode ^ location.hashCode;

  @override
  String toString() => 'CareerEvent(year: $year, title: $title, company: $company)';
}
