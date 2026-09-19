import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';

/// Temporary local course catalog for the PoC.
/// In production this list will live in Firestore.
final List<Course> mockCourses = [
  Course(
    id: 'course_fascia',
    title: 'Zoga Movement Introduction',
    description:
        'Podstawy metody Zoga Movement dla specjalistów ruchu i terapeutów manualnych — punkt wyjścia do ścieżek Practice i Therapy.',
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
    id: 'course_practice',
    title: 'Zoga Movement Practice',
    description: 'Ścieżka dla pracy ruchowej z grupami, po szkoleniu Zoga Movement Introduction.',
    icon: Icons.groups_outlined,
    lessons: const [
      Lesson(
        id: 'practice_1',
        title: 'Ruch jako narzędzie zmiany',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
      Lesson(
        id: 'practice_2',
        title: 'Dotyk i precyzja pracy',
        url: 'https://www.youtube.com/watch?v=usop847mLuI',
        source: VideoSource.youtube,
      ),
    ],
  ),
  Course(
    id: 'course_therapy_home',
    title: 'Zoga Movement Therapy — Wady Postawy',
    description: 'Badanie posturalne w statyce i w ruchu oraz korekcja najczęstszych wad postawy technikami ZOGA.',
    icon: Icons.straighten,
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
  ..._catalogCourses,
];

/// Selected trainings from the Zoga offer (zoga-movement.com). PoC lessons
/// are placeholders sharing one demo video until real content is uploaded.
final List<Course> _catalogCourses = [
  for (final c in _catalog)
    Course(
      id: 'course_${c.slug}',
      title: c.title,
      description: c.description,
      icon: c.icon,
      lessons: [
        Lesson(
          id: '${c.slug}_1',
          title: 'Wprowadzenie do szkolenia',
          url: _demoVideo,
          source: VideoSource.youtube,
        ),
        Lesson(
          id: '${c.slug}_2',
          title: 'Materiały uzupełniające',
          url: _demoVideo,
          source: VideoSource.youtube,
        ),
      ],
    ),
];

const _demoVideo = 'https://www.youtube.com/watch?v=usop847mLuI';

typedef _CatalogEntry = ({String slug, String title, String description, IconData icon});

const List<_CatalogEntry> _catalog = [
  (
    slug: 'face_1',
    title: 'Zoga Face Integration — Moduł 1',
    description:
        'Bezpieczna, precyzyjna praca z tkankami twarzy, jamy ustnej i czaszki — dla terapeutów, kosmetycznych masażystów i specjalistów manualnych.',
    icon: Icons.face_retouching_natural,
  ),
  (
    slug: 'pediatrics_1',
    title: 'Zoga Therapy w Pediatrii — Moduł 1',
    description:
        'Rozluźnianie mięśniowo-powięziowe u dzieci (szczególnie z problemami neurologicznymi) — dla fizjoterapeutów i lekarzy.',
    icon: Icons.child_care,
  ),
];
