# Dokumentacja techniczna

## 1\. Wprowadzenie

|     |     |
| --- | --- |
| **Cel dokumentu** | Przedstawienie szczegółowych aspektów technicznych związanych z budową i działaniem raportu sprzedażowego w Power BI |
| **Projekt** | Raport Sprzedażowy |
| **Data utworzenia** | 14.12.2024 |
| **Data ostatniej aktualizacji** | 10.012024 |

## 2\. Architektura rozwiązania

### 2.1 Przepływ danych

1.  Dane źródłowe pobierane są z poniższych systemów i wystawiane w plikach .csv
    - System ERP - dane o zamówieniach i produktach
    - CMR - dane o klientach
2.  Dane za pomocą Pythona są przetwarzane, przygotowywane pod struktury bazy danych i ładowane do odpowiednich tabel.
3.  Dane z bazy są pobierane i ładowane do modelu
4.  Dane są wizualizowane w raportach i udostępniane użytkownikom w przestrzeni Power BI

### 2.2 Diagram architektury

![diagram.drawio.svg](/files/0193c752-86f4-7551-8f68-2a080183276a/diagram.drawio.svg?t=1734216274890)

## 3\. Źródła danych

### 3.1 Źródła pierwotne

|     |     |     |     |
| --- | --- | --- | --- |
| Źródło | Typ | Lokalizacja | Opis |
| ERP | Plik CSV | ./data/olist_order_items_dataset.csv  ./data/olist_order_payments_dataset.csv  ./data/olist_order_reviews_dataset.csv  ./data/olist_orders_dataset.csv  ./data/olist_products_dataset.csv  ./data/product_category_name_translation.csv | Dane o zamówieniach i produktach |
| CMR | Plik CSV | ./data/olist_sellers_dataset.csv  ./data/olist_customers_dataset.csv  ./data/olist_geolocation_dataset.csv | Dane o klientach |

Ze względów technicznych nie ma możliwości połączenia bezpośrednio do danych z powyższych systemów, w związku z tym wystawiane są one w formie plików CSV.

### 3.2 Źródła bezpośrednie

Poniższe źródła są tymi, które zasilają bezpośrednio model.

|     |     |     |     |
| --- | --- | --- | --- |
| Źródło | Typ | Lokalizacja | Opis |
| Baza danych | MySQL | 120.0.0.1 | Dane o zamówieniach, produktach i klientach |

**Struktura bazy danych:**

![diagram.drawio.svg](/files/0193c9e7-c9f3-74aa-9a10-9cf0c1ddaad8/diagram.drawio.svg?t=1734262140022)

**Struktura tabel:**

|     |     |     |     |
| --- | --- | --- | --- |
| Tabela | Kolumna | Typ danych | Opis |
| orders | orderId | varchar(255) | id reprezentujące zamówienie |
| orders | customerId | varchar(255) | id reprezentujące zamówienie klienta (każde zamówienie to nowy klient) |
| orders | orderStatus | varchar(255) | aktualny status zamówienia |
| orders | orderPurchaseDate | timestamp | data złożenia zamówienia |
| orders | orderDeliveredCarrierDate | timestamp | data wysłania zamówienia |
| orders | orderDeliveredCustomerDate | timestamp | data dostarczenia zamówienia |
| orders | orderEstimatedDeliveryDate | timestamp | estymowana data dostarczenia |
| orderItem | sellerId | varchar(255) | id reprezentujące sprzedawcę |
| orderItem | productId | varchar(255) | id reprezentujące produkt |
| orderItem | orderId | varchar(255) | id reprezentujące zamówienie |
| orderItem | itemCount | int | liczba zamówionych przedmiotów |
| orderItem | shippingLimitDate | timestamp | maksymalna data wysyłki |
| orderItem | price | float | cena produktu |
| orderItem | freightValue | float | kwota dostawy podzielona na każdą pozycję w zamówieniu |
| orderPayments | orderId | varchar(255) | id reprezentujące zamówienie |
| orderPayments | paymentSeq | int | liczba reprezentująca sekwencje płatności (klient może zapłacić przy użyciu kilku metod np. karta i bon) |
| orderPayments | paymentType | varchar(255) | metoda płatności |
| orderPayments | paymentInstallments | int | ilość rat wybranych przez klienta |
| orderPayments | paymentValue | decimal | wartość płatności |
| customers | uniqueCustomerId | varchar(255) | id reprezentujące klienta |
| customers | zipCodeId | varchar(255) | id reprezentujące kod pocztowy |
| customers | customerId | varchar(255) | id reprezentujące zamówienie klienta (dla każdego zamówienia w systemie przypisywany jest nowy klient) |
| geolocation | zipCodeId | varchar(255) | id reprezentujące kod pocztowy |
| geolocation | lat | varchar(255) | szerokość geograficzna |
| geolocation | lng | varchar(255) | gługość geograficzna |
| geolocation | city | varchar(255) | miasto |
| geolocation | geoState | varchar(255) | stan |
| products | productId | varchar(255) | id reprezentujące produkt |
| products | categoryNameBRA | varchar(255) | nazwa kategorii w języku oryginalnym |
| products | categoryNameENG | varchar(255) | nazwa kategorii przetłumaczona na język angielski |
| products | productWeightG | float | waga produktu podana w gramach |
| products | productLenghtCM | float | długość produktu podana w centymetrach |
| products | productHeightCM | float | wysokość produktu podana w centymetrach |
| products | productWidthCM | float | szerokość produktu podana w centymetrach |
| sellers | sellerId | varchar(255) | id reprezentujące sprzedawcę |
| sellers | zipCodeId | varchar(255) | id reprezentujące kod pocztowy sprzedawcy |

## 4\. Transformacja danych

### 4.1 Python

- Przystosowanie nazewnictwa kolumn do bazy danych
- Funkcje ładujące dane do bazy danych

```python
def load_fact_data(df, table_name):
```

```python
def load_filter_data(table_name, df, key_columns):
```

### 4.2 PowerBI / DAX

**Miary:**

- **delivery_carrier_time** - średnia ilość dni, która minęła między datą zamówienia a datą dostawy do przewoźnika
    
    ```
    AVERAGEX(
        orders,
        DATEDIFF(
            orders[orderPurchaseDate],
            orders[orderDeliveredCarrierDate],
            DAY
        )
    )
    ```
    
- **delivery_customer_time** - średnia ilość dni, która minęła między datą dostawy do przewoźnika a datą dostawy do klienta (dostawa przez przewoźnika)
    
    ```
    AVERAGEX(
        orders,
        DATEDIFF(
            orders[orderDeliveredCarrierDate],
            orders[orderDeliveredCustomerDate],
            DAY
        )
    )
    ```
    
- **delivery_full_time** \- średnia ilość dni, która minęła między datą zamówienia a datą dostawy do klienta (pełny czas obsługi zamówienia)
    
    ```
    AVERAGEX(
        orders,
        DATEDIFF(
            orders[orderPurchaseDate],
            orders[orderDeliveredCustomerDate],
            DAY
        )
    )
    ```
    
- **freight_value** - suma wyliczonego kosztu dostawy dla wszystkich zamówień ze statusem innym niż “cancelled”, oraz “unavailable”
    
    ```
    CALCULATE(
        SUM(orderItems[freightValue]),
        FILTER(orders, orders[orderStatus] <> "unavailable" && orders[orderStatus] <> "cancelled"))
    ```
    
- **order_count** \- liczba zamówień o statusach innych niż “cancelled”, oraz “unavailable”
    
    ```
    CALCULATE(
        DISTINCTCOUNT(orderItems[orderId]),
        FILTER(orders, orders[orderStatus] <> "unavailable" && orders[orderStatus] <> "cancelled"))
    ```
    
- **order_count_total** \- liczba wszystkich zamówień
    
    ```
    COUNT(orders[orderId])
    ```
    
- **order_value** - suma całkowitego kosztu zamówienia (kwota za zamówione przedmioty + kwota dostawy)
    
    ```
    [price_value]+[freight_value]
    ```
    
- **order_value_average** \- średni koszt zamówienia
    
    ```
    DIVIDE([order_value],[order_count], 0)
    ```
    
- **price_value** \- suma wartości zamówień o statusach różnych niż “cancelled”, oraz “unavailable”
    
    ```
    CALCULATE(
        SUM(orderItems[price]),
            FILTER(orders, orders[orderStatus] <> "unavailable" && orders[orderStatus] <> "cancelled"))
    ```
    
- **product_count** - wolumen sprzedaży (liczba sprzedanych przedmiotów) dla zamówień o statusach różnych niż “cancelled”, oraz “unavailable”
    
    ```
    CALCULATE(
        COUNT(orderItems[productId]),
        FILTER(orders, orders[orderStatus] <> "unavailable" && orders[orderStatus] <> "cancelled"))
    ```
    

## 5\. Załączniki

- Dokumentacja wymagań biznesowych
- Dokumentacja projektowa