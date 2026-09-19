# Zoga — aplikacja mobilna z materiałami szkoleniowymi (Proof of Concept)

Aplikacja dla uczestników szkoleń **Zoga Multidimensional Movement™**. Po szkoleniu uczestnik dostaje jednorazowy kod, wpisuje go w aplikacji i od razu ma dostęp do materiałów wideo z danego kursu — bez zakładania hasła i bez ręcznej obsługi po stronie organizatora.

To wersja demonstracyjna (PoC): pokazuje pełny przebieg od logowania po oglądanie lekcji. Działa na iPhonie i Androidzie.

## Jak to działa w skrócie

1. **Organizator** (admin) generuje kody dostępu do wybranego kursu.
2. **Uczestnik** loguje się adresem e-mail i kodem jednorazowym.
3. Uczestnik wpisuje **kod kursu** otrzymany na szkoleniu — kurs pojawia się na jego liście.
4. Ogląda lekcje wideo, aplikacja **zapamiętuje postęp**.

Każdy kod działa **tylko raz**, więc dostęp do kursu jest przypisany do konkretnej osoby.

---

## 1. Logowanie e-mailem i kodem

Bez haseł. Uczestnik podaje adres e-mail, dostaje jednorazowy kod i wpisuje go, żeby się zalogować. Sesja jest zapamiętana na urządzeniu w bezpiecznym magazynie telefonu, więc przy kolejnym uruchomieniu aplikacja od razu pokazuje kursy.

| Wpisanie adresu e-mail | Ekran wpisania kodu |
|---|---|
| <img src="screenshots/02_email.png" width="260"> | <img src="screenshots/02b_kod_logowania.png" width="260"> |

*W wersji PoC kod jest wyświetlany na ekranie (niebieski pasek „Proof of Concept"), bo nie ma jeszcze wysyłki e-maili. W wersji docelowej trafi na skrzynkę uczestnika.*

Zmiana konta jest jednym kliknięciem ikony wylogowania — aplikacja pyta o potwierdzenie.

<img src="screenshots/13_zmiana_konta_dialog.png" width="260">

---

## 2. Uczestnik: odblokowanie kursu kodem

Nowy uczestnik zaczyna od pustej listy z podpowiedzią, co zrobić. Przycisk **„Odblokuj kurs"** na dole otwiera okno do wpisania kodu. Aplikacja reaguje na każdą sytuację czytelnym komunikatem:

| Pusta lista | Okno odblokowania | Błędny kod |
|---|---|---|
| <img src="screenshots/14_uzytkownik_pusta_lista.png" width="220"> | <img src="screenshots/15_odblokuj_kurs_arkusz.png" width="220"> | <img src="screenshots/16_odblokuj_bledny_kod.png" width="220"> |

| Kod poprawny | Kod już wykorzystany | Lista kursów po odblokowaniu |
|---|---|---|
| <img src="screenshots/17_odblokuj_sukces.png" width="220"> | <img src="screenshots/18_odblokuj_kod_uzyty.png" width="220"> | <img src="screenshots/19_lista_kursow.png" width="220"> |

Uczestnik może odblokować dowolnie wiele kursów. Lista i postęp są przypisane do jego konta — po zalogowaniu na inne konto widać tylko jego kursy.

---

## 3. Oglądanie lekcji i postęp

Kurs to lista lekcji. Kliknięcie lekcji rozwija odtwarzacz wideo bezpośrednio w aplikacji. Lekcja jest **oznaczana jako obejrzana** przy otwarciu, a uczestnik może to zmienić przełącznikiem. Na liście kursów widać licznik „Obejrzano X z Y".

| Lista kursów z postępem | Lista lekcji w kursie | Rozwinięta lekcja z wideo |
|---|---|---|
| <img src="screenshots/22_lista_kursow_postep.png" width="220"> | <img src="screenshots/23_kurs_lista_lekcji.png" width="220"> | <img src="screenshots/24_kurs_rozwinieta_lekcja.png" width="220"> |

Filmy mogą pochodzić z **YouTube** albo **Google Drive**, więc materiały można dalej hostować tam, gdzie już leżą.

### Wyszukiwarka lekcji

Pasek „Szukaj…" na dole ekranu głównego przeszukuje tytuły lekcji ze **wszystkich odblokowanych kursów**. Wybranie wyniku otwiera kurs, od razu rozwija właściwą lekcję i przewija do niej.

| Wyniki wyszukiwania | Lekcja otwarta z wyszukiwarki |
|---|---|
| <img src="screenshots/20_wyszukiwarka_lekcji.png" width="260"> | <img src="screenshots/21_lekcja_wideo.png" width="260"> |

---

## 4. Panel admina: generowanie kodów

Konto administratora ma dodatkowy ekran. Admin od razu po zalogowaniu **widzi wszystkie kursy** (nie musi niczego odblokowywać), a przycisk „Odblokuj kurs" jest dla niego ukryty.

<img src="screenshots/03_admin_ekran_glowny.png" width="260">

Na ekranie **Panel admina** wybiera się kurs i liczbę kodów (1, 5, 10, 20 lub 30 naraz), a wygenerowane kody pojawiają się na liście aktywnych kodów ze statusem „Aktywny".

| Panel admina | Jeden kod | Wybór liczby kodów |
|---|---|---|
| <img src="screenshots/04_panel_admina.png" width="220"> | <img src="screenshots/05_admin_kod_wygenerowany.png" width="220"> | <img src="screenshots/06_admin_wybor_ilosci.png" width="220"> |

| Wiele kodów naraz | Wybór kursu | Kod dla innego kursu |
|---|---|---|
| <img src="screenshots/07_admin_wiele_kodow.png" width="220"> | <img src="screenshots/08_admin_wybor_kursu.png" width="220"> | <img src="screenshots/09_admin_kod_drugi_kurs.png" width="220"> |

Zabezpieczenia: jednorazowo można wygenerować maksymalnie 30 kodów, a na jeden kurs przypada maksymalnie 100 niewykorzystanych kodów naraz. Kody mają 8 znaków i nie zawierają łatwych do pomylenia liter i cyfr (np. O/0, I/1).

---

## 5. Ekran informacyjny

Ostatni ekran przedstawia metodę Zoga, ofertę (szkolenia, terapia w domu, wydarzenia, znajdź terapeutę, sklep) i dane kontaktowe z linkami do strony i Instagramu. Przycisk „Pokaż więcej" otwiera opis działania aplikacji.

| Informacje | Kontakt | Szczegóły |
|---|---|---|
| <img src="screenshots/10_informacje.png" width="220"> | <img src="screenshots/11_informacje_kontakt.png" width="220"> | <img src="screenshots/12_informacje_szczegoly.png" width="220"> |

Nawigacja między ekranami odbywa się przesunięciem palca lub strzałkami na dolnym pasku.

---

## Kursy w wersji demonstracyjnej

W PoC jest pięć przykładowych kursów, nazwanych według prawdziwej oferty szkoleń:

1. Zoga Movement Introduction
2. Zoga Movement Practice
3. Zoga Movement Therapy — Wady Postawy
4. Zoga Face Integration — Moduł 1
5. Zoga Therapy w Pediatrii — Moduł 1

Lekcje w kursach są na razie przykładowe i pokazują ten sam film demonstracyjny.

## Co jest jeszcze tymczasowe (PoC) i co dalej

| Obszar | Teraz (PoC) | Docelowo |
|---|---|---|
| Wysyłka kodu logowania | Kod pokazany na ekranie | Wysyłka na e-mail |
| Konta, kody, postęp | Zapisane lokalnie na telefonie | Baza w chmurze (Firestore) — dostęp z wielu urządzeń, kody ważne globalnie |
| Lista kursów i lekcje | Wpisane na stałe w aplikacji | Zarządzane z panelu, bez aktualizacji aplikacji |
| Konta administratorów | Jeden adres wpisany w kodzie | Zarządzana lista administratorów |
| Treść lekcji | Przykładowe wideo | Prawdziwe materiały z YouTube / Google Drive |

Zrzuty pochodzą z symulatora iPhone w trybie deweloperskim, dlatego w rogu widać czerwony znacznik „DEBUG". W wersji dla użytkowników go nie będzie.
