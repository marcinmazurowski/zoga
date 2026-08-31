class TempEntry {
  final String id;
  final String title;
  final String author;
  final String city;

  TempEntry({
    required this.id,
    required this.title,
    required this.author,
    required this.city,
  });
}

final List<TempEntry> tempEntries = [
  TempEntry(
    id: '1',
    title: 'Przykładowy wpis 1',
    author: 'Jan Kowalski',
    city: 'Warszawa',
  ),
  TempEntry(
    id: '2',
    title: 'Przykładowy wpis 2',
    author: 'Anna Nowak',
    city: 'Kraków',
  ),
  TempEntry(
    id: '3',
    title: 'Przykładowy wpis 3',
    author: 'Piotr Wiśniewski',
    city: 'Wrocław',
  ),
  TempEntry(
    id: '4',
    title: 'Przykładowy wpis 4',
    author: 'Katarzyna Zielińska',
    city: 'Poznań',
  ),
  TempEntry(
    id: '5',
    title: 'Przykładowy wpis 5',
    author: 'Tomasz Lewandowski',
    city: 'Gdańsk',
  ),
  TempEntry(
    id: '6',
    title: 'Przykładowy wpis 6',
    author: 'Magdalena Wójcik',
    city: 'Łódź',
  ),
];
