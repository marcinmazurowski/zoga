import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';

/// Temporary local course catalog for the PoC.
/// In production this list will live in Firestore.
final List<Course> mockCourses = [
  Course(
    id: 'course_fascia',
    title: 'Praca z powięzią',
    description:
        'Techniki uwalniania powięzi, czytanie ciała jako mapy oraz precyzja dotyku.',
    icon: Icons.accessibility_new,
    lessons: const [
      Lesson(
        id: 'fascia_1',
        title: 'Wprowadzenie do pracy z powięzią',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
      Lesson(
        id: 'fascia_2',
        title: 'Techniki neuromięśniowe',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
      Lesson(
        id: 'fascia_3',
        title: 'Materiały uzupełniające',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
    ],
  ),
  Course(
    id: 'course_somatic',
    title: 'Świadomość ciała',
    description: 'Praktyki somatyczne prowadzące do zmiany postawy i świadomości siebie.',
    icon: Icons.psychology_outlined,
    lessons: const [
      Lesson(
        id: 'somatic_1',
        title: 'Ruch jako narzędzie zmiany',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
      Lesson(
        id: 'somatic_2',
        title: 'Dotyk i precyzja pracy',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
    ],
  ),
  Course(
    id: 'course_therapy_home',
    title: 'Terapia ruchem w domu',
    description: 'Zestaw ćwiczeń terapeutycznych do samodzielnej pracy w domu.',
    icon: Icons.home_work_outlined,
    lessons: const [
      Lesson(
        id: 'home_1',
        title: 'Rozgrzewka i przygotowanie',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
      Lesson(
        id: 'home_2',
        title: 'Sekwencja główna',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
      Lesson(
        id: 'home_3',
        title: 'Wyciszenie',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
    ],
  ),
];
