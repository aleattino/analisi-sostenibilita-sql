# Analisi globale della sostenibilità: emissioni di CO2 e energie rinnovabili (SQL)

## 🌍 Obiettivo del progetto

Questo progetto di **Data Analysis** è stato sviluppato interamente in **SQL (PostgreSQL)** e mira a esplorare le correlazioni tra i dati socio-economici dei Paesi, le emissioni di CO2 e l'adozione di energie rinnovabili a livello globale.

L'obiettivo principale è:
1.  **Mettere in luce** i Paesi leader nell'adozione di energie rinnovabili.
2.  **Analizzare** l'andamento delle emissioni di CO2 nel tempo e confrontare i principali Paesi emettitori.
3.  **Dimostrare** le competenze di **Data Wrangling** e **Data Cleaning** direttamente in SQL.

## 🛠️ Metodologia e strumenti

Il progetto si articola in due fasi cruciali: **Data Cleaning/ETL** e **Analisi/Insight**.

| Strumento | Ruolo nel progetto |
| :--- | :--- |
| **Linguaggio** | PostgreSQL (SQL) |
| **Ambiente** | pgAdmin 4 |
| **Tecnica SQL** | Utilizzo di tabelle temporanee, funzioni `REPLACE()` e `CAST()` per la pulizia dei dati e la corretta tipizzazione. Uso di CTE (`WITH`) per analisi complesse. |

### 📊 Dataset utilizzati

L'analisi si basa sull'integrazione di tre dataset pubblici:
1.  **Global Country Information Dataset 2023** (Dati socio-economici e geografici).
2.  **Global Data on Sustainable Energy 2000-2020** (Dati storici su energia e CO2).
3.  **Global Ecological Footprint 2023** (Dati sull'impronta ecologica).

## 🧹 Data Cleaning e Preparazione (ETL in SQL)

Un aspetto fondamentale di questo progetto è la gestione dei dati sporchi. I dataset originali contenevano simboli non numerici (come `$`, `%`, e `,`) che impedivano l'importazione diretta in colonne numeriche.

Per risolvere questo problema, è stata adottata una strategia robusta di **ETL (Extract, Transform, Load)** interamente in SQL:
1.  **Extract & Load (Temporaneo):** I dati sono stati importati in tabelle temporanee (`*_temp`) dove tutte le colonne erano definite come `TEXT`.
2.  **Transform & Load (Definitivo):** È stata creata la tabella definitiva (es. `world_data_2023`) utilizzando query `CREATE TABLE AS SELECT` che applicano:
    *   La funzione `REPLACE()` per rimuovere i simboli non desiderati.
    *   La funzione `CAST()` per convertire le stringhe pulite nei tipi di dato corretti (`DECIMAL`, `FLOAT`, `INT`).

Questa sezione dimostra la capacità di gestire problemi di qualità dei dati e di preparare un database relazionale solido per l'analisi.

## 💡 Risultati chiave e insight

Le query di analisi hanno permesso di estrarre i seguenti insight cruciali:

### 1. Classifica dei Paesi per percentuale di energia rinnovabile (2020)

**Domanda:** Quali Paesi con accesso universale all'elettricità (100%) hanno la più alta percentuale di energia primaria equivalente proveniente da fonti rinnovabili?

| Paese | Anno | % Rinnovabili | Insight Principale |
| :--- | :--- | :--- | :--- |
| **Iceland** | 2020 | 86.84% | Netto leader globale, grazie alla sua abbondanza di risorse geotermiche e idroelettriche. |
| **Norway** | 2020 | 70.96% | Forte dipendenza dall'energia idroelettrica. |
| **Brazil** | 2020 | 49.47% | Spicca tra le Americhe, con una delle più grandi reti idroelettriche al mondo. |
| **Sweden** | 2020 | 51.06% | Performance eccellente in Europa, evidenziando politiche energetiche efficaci. |

### 2. Analisi delle emissioni di CO2 (2017-2023)

**Domanda:** Qual è l'andamento delle emissioni di CO2 nei tre principali Paesi emettitori (Cina, USA, India) e come si confrontano i dati storici (2017-2019) con quelli più recenti (2023)?

L'analisi ha rivelato fluttuazioni significative:

*   **Cina:** Dopo un aumento del **+6.05%** tra il 2017 e il 2019, i dati più recenti del 2023 mostrano una potenziale inversione di tendenza con una riduzione del **-7.60%** rispetto al 2019, suggerendo l'inizio di un'efficacia delle politiche di decarbonizzazione.
*   **Stati Uniti:** Hanno mostrato una crescita delle emissioni del **+3.91%** tra il 2019 e il 2023, sollevando interrogativi sull'efficacia delle politiche di contenimento attuali.
*   **India:** Ha mantenuto un percorso di crescita più moderato, con un leggero calo nel 2023 rispetto al 2019, riflettendo il delicato equilibrio tra sviluppo economico e sostenibilità.

### 3. Tendenze globali (2000-2019)

**Domanda:** Qual è stata la variazione totale delle emissioni di CO2 e della quota di energie rinnovabili a livello globale tra il 2000 e il 2019?

*   **Emissioni di CO2:** Le emissioni globali sono aumentate da **16.63 milioni di kt CO2 eq** nel 2000 a **33.37 milioni di kt CO2 eq** nel 2019, con un aumento complessivo del **+100.6%** nel periodo.
*   **Energie rinnovabili:** Parallelamente, la quota globale di energia da fonti rinnovabili è cresciuta, passando da **13.06%** nel 2000 a **17.06%** nel 2019, con un aumento del **+30.6%**.

Questo evidenzia la sfida globale: sebbene l'uso di rinnovabili stia crescendo, l'aumento del consumo energetico complessivo ha portato a un raddoppio delle emissioni totali di CO2.


## 🔗 Link ai dati originali

*   [Global Country Information Dataset 2023](https://is.gd/o6FOAm)
*   [Global Data on Sustainable Energy 2000-2020](https://is.gd/CVwsUN)
*   [Global Ecological Footprint 2023](https://is.gd/fGJjKz)
