# Dashboard e-commerce

## Cel projektu

Celem raportu sprzedażowego jest umożliwienie śledzenia wyników sprzedaży i dostaw w czasie rzeczywistym, identyfikacja kluczowych trendów oraz wspieranie podejmowania decyzji biznesowych.

---

## Zakres projektu

1.  Analiza wymagań biznesowych
    1.  Pytania biznesowe:
        1.  Jakie są całkowite przychody firmy w wybranym okresie?
        2.  Które regiony generują najwyższe przychody?
        3.  Jakie produkty sprzedają się najlepiej w poszczególnych regionach?
        4.  Jak zmieniały się wyniki sprzedaży na przestrzeni miesięcy?
        5.  Ile czasu zajmuje dostawa zamówienia do klienta?
    2.  Kluczowe wskaźniki (KPI)
        1.  Całkowite przychody
        2.  Średnia wartość zamówienia
        3.  Wolumen sprzedaży
        4.  Czas dostawy do klienta
2.  Przygotowanie źródeł danych
    1.  Architektura przepływu danych![](/files/01947e0c-89c7-71e9-b117-f8d393089937/architektura_przeplywu.png)
    2.  Struktura bazy danych![](/files/01947e0c-f9b1-7401-aa6a-2d3ee84ea5c0/struktura_db.png)
3.  Tworzenie modelu danych![](/files/01947e10-9a8f-7220-bf63-7c81eae75c1c/model_danych.png)
4.  Wizualizacja danych
    1.  Strona Sprzedaży![](/files/01947e12-b6c9-715e-9335-12e7dea79f7f/wizualizacje_sprzedaż.png)
    2.  Strona Dostawy![](/files/01947e13-7a18-7409-9658-7e9f5d71d968/wizualizacje_dostawa.png)

---

## Technologie i narzędzia

1.  Podstawowe narzędzia i technologie wykorzystane do utworzenia dashboardu
    1.  **Excel** \- dane źródłowe w formie plików .csv
    2.  **Python** \- przetworzenie i transformacja danych, oraz zapis do bazy MySQL
    3.  **SQL** \- pozyskanie danych z bazy MySQL
    4.  **DAX** \- miary i kalkulacje
    5.  **Power BI** - publikacja raportu