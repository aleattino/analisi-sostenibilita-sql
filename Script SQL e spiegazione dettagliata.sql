/* Il seguente testo è basato sull'analisi di tre dataset, ovvero:

1. Global Country Information Dataset 2023 (https://is.gd/o6FOAm);
2. Global Data on Sustainable Energy 2000-2020 (https://is.gd/CVwsUN);
3. Global Ecological Footprint 2023 (https://is.gd/fGJjKz)

Inserirò i dataset al database seguendo l'ordine di cui sopra.

Creo il database world-data-2023 direttamente su pgadmin 4 e poi una tabella temporanea world_data_temp.
Ho scelto di creare una tabella temporanea con tutte le colonne definite come TEXT per consentire l’importazione dei dati 
senza dover gestire problemi di formattazione subito. Importare tutto come TEXT permette di aggirare eventuali errori dovuti 
alla presenza di simboli %, $ e , nei numeri, che PostgreSQL non riesce a interpretare se le colonne sono impostate direttamente 
come tipi numerici. Una volta importati i dati come TEXT posso trasformarli successivamente, rimuovendo questi simboli. */

CREATE TABLE world_data_temp (
    country VARCHAR(50),
    density_pk TEXT,
    abbreviation VARCHAR(2),
    agricultural_land_percent TEXT,
    land_area_km2 TEXT,
    armed_forces_size TEXT,
    birth_rate FLOAT,
    calling_code FLOAT,
    capital_major_city VARCHAR(100),
    co2_emissions TEXT,
    cpi TEXT,
    cpi_change_percent TEXT,
    currency_code VARCHAR(3),
    fertility_rate FLOAT,
    forested_area_percent TEXT,
    gasoline_price TEXT,
    gdp TEXT,
    gross_primary_education_enrollment_percent TEXT,
    gross_tertiary_education_enrollment_percent TEXT,
    infant_mortality FLOAT,
    largest_city VARCHAR(100),
    life_expectancy FLOAT,
    maternal_mortality_ratio FLOAT,
    minimum_wage TEXT,
    official_language VARCHAR(50),
    out_of_pocket_health_expenditure TEXT,
    physicians_per_thousand FLOAT,
    population TEXT,
    labor_force_participation_percent TEXT,
    tax_revenue_percent TEXT,
    total_tax_rate TEXT,
    unemployment_rate TEXT,
    urban_population TEXT,
    latitude FLOAT,
    longitude FLOAT
);

/* Creo poi la tabella world_data_2023 impostando le corrette tipologie di dati senza simboli %, utilizzando la seguente 
query per copiare e trasformare i dati. Ho scelto di utilizzare la funzione REPLACE perché PostgreSQL non interpreta correttamente 
i numeri che contengono virgole o separatori, come '1,000' o '2','5'. Eliminando questi simboli, sono riuscito a convertire i valori
di testo puliti in tipi numerici come DECIMAL e FLOAT utilizzando CAST. Questo approccio è stato particolarmente utile perché, 
nonostante i miei tentativi di pulizia manuale in Visual Studio Code, la presenza di virgole e altri simboli continuava a causare 
errori durante l’importazione. Ho quindi deciso di eseguire questa pulizia direttamente con SQL, risparmiando tempo e assicurandomi 
che ogni valore fosse compatibile con i tipi numerici di PostgreSQL. */

CREATE TABLE world_data_2023 AS
SELECT country,
    CAST(REPLACE(REPLACE(density_pk, ',', ''), '$', '') AS DECIMAL(10, 2)) AS density_pk,
    abbreviation,
    CAST(REPLACE(REPLACE(agricultural_land_percent, '%', ''), '$', '') AS DECIMAL(5, 2)) AS agricultural_land_percent,
    CAST(REPLACE(REPLACE(land_area_km2, ',', ''), '$', '') AS DECIMAL(15, 2)) AS land_area_km2,
    CAST(REPLACE(REPLACE(armed_forces_size, ',', ''), '$', '') AS DECIMAL(10, 0)) AS armed_forces_size,
    birth_rate,
    calling_code,
    capital_major_city,
    CAST(REPLACE(REPLACE(co2_emissions, ',', ''), '$', '') AS DECIMAL(15, 2)) AS co2_emissions,
    CAST(REPLACE(REPLACE(cpi, ',', ''), '$', '') AS DECIMAL(6, 2)) AS cpi,
    CAST(REPLACE(REPLACE(cpi_change_percent, '%', ''), '$', '') AS DECIMAL(5, 2)) AS cpi_change_percent,
    currency_code,
    fertility_rate,
    CAST(REPLACE(REPLACE(forested_area_percent, '%', ''), '$', '') AS DECIMAL(5, 2)) AS forested_area_percent,
    CAST(REPLACE(REPLACE(gasoline_price, '$', ''), ',', '') AS DECIMAL(5, 2)) AS gasoline_price,
    CAST(REPLACE(REPLACE(gdp, ',', ''), '$', '') AS DECIMAL(20, 2)) AS gdp,
    CAST(REPLACE(REPLACE(gross_primary_education_enrollment_percent, '%', ''), '$', '') AS DECIMAL(5, 2)) AS gross_primary_education_enrollment_percent,
    CAST(REPLACE(REPLACE(gross_tertiary_education_enrollment_percent, '%', ''), '$', '') AS DECIMAL(5, 2)) AS gross_tertiary_education_enrollment_percent,
    infant_mortality,
    largest_city,
    life_expectancy,
    maternal_mortality_ratio,
    CAST(REPLACE(REPLACE(minimum_wage, ',', ''), '$', '') AS DECIMAL(10, 2)) AS minimum_wage,
    official_language,
    CAST(REPLACE(REPLACE(out_of_pocket_health_expenditure, '%', ''), '$', '') AS DECIMAL(5, 2)) AS out_of_pocket_health_expenditure,
    physicians_per_thousand,
    CAST(REPLACE(REPLACE(population, ',', ''), '$', '') AS DECIMAL(15, 0)) AS population,
    CAST(REPLACE(REPLACE(labor_force_participation_percent, '%', ''), '$', '') AS DECIMAL(5, 2)) AS labor_force_participation_percent,
    CAST(REPLACE(REPLACE(tax_revenue_percent, '%', ''), '$', '') AS DECIMAL(5, 2)) AS tax_revenue_percent,
    CAST(REPLACE(REPLACE(total_tax_rate, '%', ''), '$', '') AS DECIMAL(5, 2)) AS total_tax_rate,
    CAST(REPLACE(REPLACE(unemployment_rate, '%', ''), '$', '') AS DECIMAL(5, 2)) AS unemployment_rate,
    CAST(REPLACE(REPLACE(urban_population, ',', ''), '$', '') AS DECIMAL(15, 0)) AS urban_population,
    latitude,
    longitude
FROM world_data_temp;

-- Una volta verificati i dati nella tabella world_data_2023, procedo ad elimare la tabella temporanea.

DROP TABLE world_data_temp;

/* Utilizzo lo stesso metodo per importare la tabella global_sustainable_energy_data. Creo pertanto una bella provvisoria
chiamata global_sustainable_energy_temp con tutte le colonne come TEXT, in modo da importare i dati così come sono, 
senza problemi di formattazione.*/

CREATE TABLE global_sustainable_energy_temp (
    entity TEXT,
    year TEXT,
    access_to_electricity_percent TEXT,
    access_to_clean_fuels_for_cooking TEXT,
    renewable_electricity_generating_capacity_per_capita TEXT,
    financial_flows_to_developing_countries_usd TEXT,
    renewable_energy_share_total_final_energy TEXT,
    electricity_from_fossil_fuels_twh TEXT,
    electricity_from_nuclear_twh TEXT,
    electricity_from_renewables_twh TEXT,
    low_carbon_electricity_percent TEXT,
    primary_energy_consumption_per_capita_kwh TEXT,
    energy_intensity_mj_per_ppp_gdp TEXT,
    co2_emissions_kt TEXT,
    renewables_percent_equivalent_primary_energy TEXT,
    gdp_growth TEXT,
    gdp_per_capita TEXT,
    density_p_km2 TEXT,
    land_area_km2 TEXT,
    latitude TEXT,
    longitude TEXT
);

/* Importo poi la tabella tramite l'interfaccia grafica di pgadmin e creo la tabella definitiva con le tipologie corrette di dati,
rimuovendo le virgole e facendo il CAST dei valori numerici.*/

CREATE TABLE global_sustainable_energy_data AS
SELECT entity,
    CAST(year AS INT) AS year,
    CAST(REPLACE(access_to_electricity_percent, ',', '') AS DECIMAL(5, 2)) AS access_to_electricity_percent,
    CAST(REPLACE(access_to_clean_fuels_for_cooking, ',', '') AS DECIMAL(5, 2)) AS access_to_clean_fuels_for_cooking,
    CAST(REPLACE(renewable_electricity_generating_capacity_per_capita, ',', '') AS DECIMAL(10, 2)) AS renewable_electricity_generating_capacity_per_capita,
    CAST(REPLACE(financial_flows_to_developing_countries_usd, ',', '') AS DECIMAL(20, 0)) AS financial_flows_to_developing_countries_usd,
    CAST(REPLACE(renewable_energy_share_total_final_energy, ',', '') AS DECIMAL(5, 2)) AS renewable_energy_share_total_final_energy,
    CAST(REPLACE(electricity_from_fossil_fuels_twh, ',', '') AS DECIMAL(10, 2)) AS electricity_from_fossil_fuels_twh,
    CAST(REPLACE(electricity_from_nuclear_twh, ',', '') AS DECIMAL(10, 2)) AS electricity_from_nuclear_twh,
    CAST(REPLACE(electricity_from_renewables_twh, ',', '') AS DECIMAL(10, 2)) AS electricity_from_renewables_twh,
    CAST(REPLACE(low_carbon_electricity_percent, ',', '') AS DECIMAL(5, 2)) AS low_carbon_electricity_percent,
    CAST(REPLACE(primary_energy_consumption_per_capita_kwh, ',', '') AS DECIMAL(10, 2)) AS primary_energy_consumption_per_capita_kwh,
    CAST(REPLACE(energy_intensity_mj_per_ppp_gdp, ',', '') AS DECIMAL(10, 2)) AS energy_intensity_mj_per_ppp_gdp,
    CAST(REPLACE(co2_emissions_kt, ',', '') AS DECIMAL(15, 2)) AS co2_emissions_kt,
    CAST(REPLACE(renewables_percent_equivalent_primary_energy, ',', '') AS DECIMAL(5, 2)) AS renewables_percent_equivalent_primary_energy,
    CAST(REPLACE(gdp_growth, ',', '') AS DECIMAL(5, 2)) AS gdp_growth,
    CAST(REPLACE(gdp_per_capita, ',', '') AS DECIMAL(10, 2)) AS gdp_per_capita,
    CAST(REPLACE(density_p_km2, ',', '') AS INT) AS density_p_km2,
    CAST(REPLACE(land_area_km2, ',', '') AS INT) AS land_area_km2,
    CAST(REPLACE(latitude, ',', '') AS DECIMAL(8, 5)) AS latitude,
    CAST(REPLACE(longitude, ',', '') AS DECIMAL(8, 5)) AS longitude
FROM global_sustainable_energy_temp;

-- Una volta verificati i dati nella tabella global_sustainable_energy_data, procedo ad elimare la tabella temporanea.

DROP TABLE global_sustainable_energy_temp;

/* Adopero lo stesso metodo per importare la successiva tabella chiamata ecological_data_2023. Creo pertanto una bella provvisoria
chiamata temp_ecological_data con tutte le colonne come TEXT, in modo da importare i dati così come sono, 
senza problemi di formattazione.*/

CREATE TABLE temp_ecological_data (
    country TEXT,
    region TEXT,
    sdgi TEXT,
    life_expectancy TEXT,
    hdi TEXT,
    per_capita_gdp TEXT,
    income_group TEXT,
    population_millions TEXT,
    cropland_footprint TEXT,
    grazing_footprint TEXT,
    forest_product_footprint TEXT,
    carbon_footprint TEXT,
    fish_footprint TEXT,
    built_up_land TEXT,
    total_ecological_footprint_consumption TEXT,
    cropland TEXT,
    grazing_land TEXT,
    forest_land TEXT,
    fishing_ground TEXT,
    built_up_land_capacity TEXT,
    total_biocapacity TEXT,
    ecological_deficit_or_reserve TEXT,
    number_of_earths_required TEXT,
    number_of_countries_required TEXT
);

/* Importo quindi la tabella tramite l'interfaccia grafica di pgadmin e creo la tabella definitiva con le tipologie corrette di dati,
rimuovendo le virgole e facendo il CAST dei valori numerici.*/

CREATE TABLE ecological_data_2023 AS
SELECT country,
    region,
    CAST(NULLIF(sdgi, ' ') AS DECIMAL(5, 2)) AS sdgi,
    CAST(NULLIF(life_expectancy, ' ') AS DECIMAL(5, 2)) AS life_expectancy,
    CAST(NULLIF(hdi, ' ') AS DECIMAL(5, 2)) AS hdi,
    CAST(NULLIF(REPLACE(REPLACE(per_capita_gdp, '$', ''), ',', ''), ' ') AS DECIMAL(15, 2)) AS per_capita_gdp,
    income_group,
    CAST(NULLIF(REPLACE(REPLACE(population_millions, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS population_millions,
    CAST(NULLIF(REPLACE(REPLACE(cropland_footprint, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS cropland_footprint,
    CAST(NULLIF(REPLACE(REPLACE(grazing_footprint, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS grazing_footprint,
    CAST(NULLIF(REPLACE(REPLACE(forest_product_footprint, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS forest_product_footprint,
    CAST(NULLIF(REPLACE(REPLACE(carbon_footprint, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS carbon_footprint,
    CAST(NULLIF(REPLACE(REPLACE(fish_footprint, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS fish_footprint,
    CAST(NULLIF(REPLACE(REPLACE(built_up_land, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS built_up_land,
    CAST(NULLIF(REPLACE(REPLACE(total_ecological_footprint_consumption, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS total_ecological_footprint_consumption,
    CAST(NULLIF(REPLACE(REPLACE(cropland, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS cropland,
    CAST(NULLIF(REPLACE(REPLACE(grazing_land, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS grazing_land,
    CAST(NULLIF(REPLACE(REPLACE(forest_land, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS forest_land,
    CAST(NULLIF(REPLACE(REPLACE(fishing_ground, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS fishing_ground,
    CAST(NULLIF(REPLACE(REPLACE(built_up_land_capacity, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS built_up_land_capacity,
    CAST(NULLIF(REPLACE(REPLACE(total_biocapacity, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS total_biocapacity,
    CAST(NULLIF(REPLACE(REPLACE(ecological_deficit_or_reserve, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS ecological_deficit_or_reserve,
    CAST(NULLIF(REPLACE(REPLACE(number_of_earths_required, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS number_of_earths_required,
    CAST(NULLIF(REPLACE(REPLACE(number_of_countries_required, ',', ''), '$', ''), ' ') AS DECIMAL(10, 2)) AS number_of_countries_required
FROM temp_ecological_data;

-- Una volta verificati i dati nella tabella ecological_data_2023, procedo ad elimare la tabella temporanea.

DROP TABLE temp_ecological_data;


/* 1) Classifica dei paesi con la maggior percentuale di energia rinnovabile

In questo caso, l'obiettivo è quello di identificare i paesi aventi accesso alla rete elettrica che utilizzano maggiormente 
energia rinnovabile. Andrò a filtrare i risultati facendo riferimento all'ultimo anno in cui sono disponibili dati utilizzabili,
ovvero il 2020. Utilizzerò poi un ulteriore filtro per escludere i paesi in cui non tutti i cittadini  hanno accesso alla rete 
elettrica. Infine, escluderò i record che non presentano dati in merito all'utilizzo di energie rinnovabili per l'anno 2020 */

SELECT entity AS country, year, renewables_percent_equivalent_primary_energy
FROM global_sustainable_energy_data
WHERE year = 2020
    AND access_to_electricity_percent = 100
    AND renewables_percent_equivalent_primary_energy IS NOT NULL
ORDER BY renewables_percent_equivalent_primary_energy DESC
LIMIT 11;

-- Otterremo la seguente tabella.

country               | year | renewables_percent_equivalent_primary_energy 
----------------------+------+----------------------------------------------
 Iceland              | 2020 |                                        86.84
 Norway               | 2020 |                                        70.96
 Sweden               | 2020 |                                        51.06
 Brazil               | 2020 |                                        49.47
 Austria              | 2020 |                                        38.26
 Denmark              | 2020 |                                        37.27
 Switzerland          | 2020 |                                        36.21
 Finland              | 2020 |                                        33.17
 Portugal             | 2020 |                                        31.72
 Colombia             | 2020 |                                        30.77
 Canada               | 2020 |                                        30.54

/* Da questi dati si evince con chiarezza come Islanda e Norvegia si distinguano dal resto delle nazioni mostrando percentuali di
rinnovabili davvero significative, rispettivamente di circa l'86% e del 71%. 
Svezia (51.06%), Austria (38.26%), Danimarca (37.27%), Svizzera (36.21%), Finlandia (33.17%), e Portogallo (31.72%) mostrano 
anch'essi percentuali notevoli relativamente all'utilizzo di energia rinnovabile. 
Oltre a Islanda, Norvegia e Svezia, in questa classifica spicca il Brasile con il 49,47% e, sempre per quanto riguarda l'America 
Latina, la Colombia con il 30,77%. Il Brasile, in particolare, ha una delle reti idroelettriche più grandi al mondo, che copre 
una porzione significativa del fabbisogno energetico nazionale.
Unico paese facente parte delle Americhe Centrali e Settentrionali è il Canada con il 30,54%. */


/* 2) Top 3 paesi con maggiori emissioni di CO2 dal 2017 al 2019 e confronto con i dati aggiornati al 2023.

Ora vado ad identificare i 3 paesi con maggiori emissioni di CO2 nel corso degli ultimi 3 anni (2019-2017). Per farlo utilizzerò una
CTE chiamata top_emissions.

Partiamo dalla top 3 paesi con maggiori emissioni di CO2 dal 2017 al 2019. */

WITH top_emissions AS (
    SELECT entity AS country,
        year,
        SUM(co2_emissions_kt) AS total_emissions,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY SUM(co2_emissions_kt) DESC) AS rn
    FROM global_sustainable_energy_data
    WHERE co2_emissions_kt IS NOT NULL
      AND year IN (2017, 2018, 2019)
    GROUP BY entity, year
)
SELECT country,
    ROUND(SUM(CASE WHEN year = 2017 THEN total_emissions / 1000000 END), 2) AS emissions_2017,
    ROUND(SUM(CASE WHEN year = 2018 THEN total_emissions / 1000000 END), 2) AS emissions_2018,
    ROUND(SUM(CASE WHEN year = 2019 THEN total_emissions / 1000000 END), 2) AS emissions_2019
FROM top_emissions
WHERE rn <= 3
GROUP BY country
ORDER BY emissions_2019 DESC;

/* Utilizzo la funzione ROW NUMBER() per assegnare un numero progressivo a ciascuna riga all’interno di ogni gruppo di year, 
numerando quindi i paesi separatamente per ogni anno.
ORDER BY emissions_2019 DESC ordina i paesi in ordine decrescente per l'ultimo anno considerato. Pertanto il paese con le emissioni 
più alte riceve rn = 1, il secondo rn = 2 e così via.
Ottengo quindi la seguente tabella: */

    country    | emissions_2017 | emissions_2018 | emissions_2019 
---------------+----------------+----------------+----------------
 China         |          10.10 |          10.50 |          10.71
 United States |           4.82 |           4.98 |           4.82
 India         |           2.32 |           2.45 |           2.46


/* Da questi dati emerge chiaramente che Cina, Stati Uniti e India sono i principali contribuenti alle emissioni globali di CO2 per
tutti e 3 gli anni presi in considerazione (2017, 2018, 2019). 
Nello specifico possiamo notare che: 

- la Cina è il maggior emetittore di CO2 con valori pari ad  oltre il doppio di quelli degli Stati Uniti e più di quattro volte 
rispetto a quelli dell’India;
- gli Stati Uniti mostrano un lieve calo nelle emissioni nel corso degli anni considerati, che potrebbe indicare una certa 
efficacia delle politiche di riduzione delle emissioni;
- l’India continua a vedere un aumento nelle emissioni, segno di una probabile crescente industrializzazione. 

Mi accingo adesso ad identificare i 3 paesi con maggiori emissioni di CO2 nel 2023, confrontando i risultati con i dati del triennio
2017-2019. */

SELECT country, co2_emissions AS co2_emissions_kt
FROM world_data_2023
WHERE co2_emissions IS NOT NULL
ORDER BY co2_emissions DESC LIMIT 3;

-- Ottengo i seguenti risultati: 

country        | co2_emissions_kt 
---------------+------------------
 China         |       9893038.00
 United States |       5006302.00
 India         |       2407672.00

/* Ora interpreto, paese per paese, i dati ottenuti, confrontando i risultati ed evidenziando eventuali fluttuazioni dei valori.

- Cina: il trend iniziale mostrava un incremento sostanziale, con le emissioni che sono cresciute da 10,09 milioni di kt CO2
equivalente (kt Co2 eq) nel 2017 a 10,70 milioni di kt CO2 equivalente nel 2019, segnando un aumento del 6% in due anni. Tuttavia, 
il dato del 2023 evidenzia una inversione di tendenza significativa, con una riduzione a 9,89 milioni di kt CO2 eq, inferiore ai 
livelli del 2017. Questa trasformazione suggerisce una probabile efficacia delle politiche di decarbonizzazione che il governo cinese
sta cominciando ad implementare (https://is.gd/Yx5Y34);

- Stati Uniti: il dato più recente del 2023, che segna il picco a 5 milioni di kt CO2 eq, solleva interrogativi sulla reale efficacia
delle politiche di contenimento delle emissioni implementate dagli USA.  È interessante notare come, nonostante tutti i discorsi sulla
transizione verde e gli accordi climatici, le emissioni americane continuino a crescere;

- India: manifesta un percorso di crescita più moderato. Partendo da 2,32 milioni di kt CO2 eq nel 2017, ha registrato un incremento 
significativo fino al 2019 (2,45 milioni di kt CO2 eq), seguito da una leggera flessione nel 2023 (2,40 milioni di kt CO2 eq). 
Questa evoluzione potrebbe riflettere il delicato equilibrio tra le esigenze di sviluppo economico e gli obiettivi di sostenibilità 
ambientale che caratterizza le economie emergenti.

Affinchè l'interpretazione dei dati sia più chiara, propongo un calcolo della variazione percentuale paese per paese dei dati relativi
al periodo 2017-2019 rispetto al periodo 2019-2023, applicando la seguente formula:

((Valore più recente - Valore meno recente) / Valore meno recente) × 100

Cina:

2017-2019: +6,05%
2019-2023: -7,60%

Stati Uniti:

2017-2019: -0,03%
2019-2023: +3,91%

India:

2017-2019: +5,86%
2019-2023: -1,98%


3) Variazione delle emissioni di CO2 e della percentuale di energie rinnovabili utilizzate dal 2000 al 2019.

Per ottenere il totale delle emissioni di CO2 per ogni anno dal 2000 al 2019 ed analizzarne le variazioni nel tempo, imposto la 
query in questo modo: */

SELECT 
    year,
    TO_CHAR(SUM(co2_emissions_kt) / 1000000, 'FM999999.00') AS emissions_in_millions
FROM global_sustainable_energy_data
WHERE year BETWEEN 2000 AND 2019
  AND co2_emissions_kt IS NOT NULL
GROUP BY year
ORDER BY year;

/* Nella funzione TO_CHAR, FM (Fill Mode) rimuove gli spazi iniziali e finali inutilizzati, mentre 999999 specifica la parte intera 
del numero. Ogni 9 rappresenta una cifra. In questo caso, sono consentite fino a 6 cifre nella parte intera. Se il numero è più piccolo, 
le cifre restanti non vengono riempite con zeri o spazi. Infine, 00 indica che devono essere mostrati esattamente due cifre decimali, 
anche se il numero è un intero.

Ottengo i seguenti risultati: */

year  | emissions_in_millions 
------+-----------------------
 2000 | 20.00
 2001 | 20.35
 2002 | 20.64
 2003 | 21.65
 2004 | 22.70
 2005 | 23.57
 2006 | 24.31
 2007 | 25.33
 2008 | 25.50
 2009 | 25.25
 2010 | 26.84
 2011 | 27.68
 2012 | 28.09
 2013 | 28.79
 2014 | 28.83
 2015 | 28.61
 2016 | 28.61
 2017 | 28.96
 2018 | 29.59
 2019 | 29.61


/* Questi dati rivelano un aumento significativo tra il 2000 e il 2019. Nel 2000, le emissioni totali erano pari a circa 20 milioni
di kt CO2 eq. Da quel momento, si è registrato un trend generalmente crescente, con un picco di quasi 30 milioni di kt CO2 eq nel
2019. Questo rappresenta un incremento del 50% in meno di due decenni. Un’interessante fase di stabilizzazione si osserva tra il 
2014 e il 2016, quando le emissioni si sono leggermente ridotte, passando da 28,8 milioni di kt CO2 eq nel 2014 a 28,6 milioni di 
kt CO2 qe nel 2016. Dopo il 2016, le emissioni hanno ripreso a crescere, raggiungendo nel 2019 il livello più alto mai registrato.


Imposto ora una query per calcolare il totale delle energie rinnovabili utilizzate nello stesso intervallo di tempo (2000-2019) */

SELECT year, SUM(electricity_from_renewables_twh) AS total_renewable_energy
FROM global_sustainable_energy_data
WHERE year BETWEEN 2000 AND 2019 AND electricity_from_renewables_twh IS NOT NULL
GROUP BY year
ORDER BY year;

-- In questo caso, ottengo i seguenti risultati:

year  | total_renewable_energy 
------+------------------------
 2000 |                2559.76
 2001 |                2487.22
 2002 |                2568.90
 2003 |                2595.82
 2004 |                2794.82
 2005 |                2928.52
 2006 |                3068.19
 2007 |                3179.29
 2008 |                3451.28
 2009 |                3527.05
 2010 |                3838.49
 2011 |                4024.22
 2012 |                4329.59
 2013 |                4614.94
 2014 |                4902.77
 2015 |                5125.79
 2016 |                5442.40
 2017 |                5794.04
 2018 |                6200.29
 2019 |                6551.52

/* Questi dati ci suggeriscono che dal 2000 al 2019 la produzione globale di energia rinnovabile ha registrato una crescita costante.
All’inizio del periodo considerato la produzione era relativamente limitata, con un incremento moderato fino al 2004. Tuttavia, 
a partire dal 2005, si può osservare un’accelerazione significativa, con una crescita sempre più pronunciata negli anni successivi.
Dal 2010 la crescita diventa ancora più evidente, con un notevole incremento della produzione che quasi raddoppia entro il 2019.

Confrontando i dati, appare chiaro come la produzione di energia rinnovabile sia cresciuta in modo notevole, ma, allo stesso tempo, 
sembra che questo aumento non sia ancora sufficiente a compensare il continuo aumento delle emissioni di CO2.

Confronto adesso i risultati relativi alle emissioni di CO2 e alle energie rinnovabili ottenuti strutturando una query per calcolare
le variazioni percentuali rispetto al primo anno considerato (il 2000 in entrambi i casi).
La variazione percentuale misura quanto un valore in un dato anno è aumentato o diminuito rispetto al valore iniziale relatival 2000.
Ho scelto di utilizzare questo metodo per avere un output con dei risultati facilmente collocabili e interpretabili all'interno di 
un grafico.
La formula alla base del calcolo che eseguo tramite query è la seguente:


Variazione percentuale = [(Valore anno corrente - Valore anno 2000) \ Valore anno 2000] * 100


Nella query, l’operazione si basa su FIRST_VALUE(), che seleziona il valore del primo anno (2000) come riferimento.*/

WITH base_values AS (
    SELECT year,
        SUM(electricity_from_renewables_twh) AS total_renewable_energy,
        SUM(co2_emissions_kt / 1000000) AS total_emissions_in_millions
    FROM global_sustainable_energy_data
    WHERE year BETWEEN 2000 AND 2019
    GROUP BY year
),
percent_changes AS (
    SELECT year,
        total_renewable_energy,
        total_emissions_in_millions,
        ((total_renewable_energy - FIRST_VALUE(total_renewable_energy) OVER ()) /
         FIRST_VALUE(total_renewable_energy) OVER ()) * 100 AS renewable_variation_percent,
        ((total_emissions_in_millions - FIRST_VALUE(total_emissions_in_millions) OVER ()) /
         FIRST_VALUE(total_emissions_in_millions) OVER ()) * 100 AS emissions_variation_percent
    FROM base_values
)
SELECT year,
    ROUND(renewable_variation_percent, 2) AS renewable_variation_percent,
    ROUND(emissions_variation_percent, 2) AS emissions_variation_percent
FROM percent_changes
ORDER BY year;

/* base_values aggrega i valori di energia rinnovabile (electricity_from_renewables_twh) e emissioni di CO₂ (co2_emissions_kt) per ogni anno,
mentre percent_changes calcola la variazione percentuale rispetto al valore dell’anno base (2000) usando FIRST_VALUE() come riferimento per 
i calcoli.

Ottengo quindi il seguente output: */

year  | renewable_variation_percent | emissions_variation_percent 
------+-----------------------------+-----------------------------
 2000 |                      -44.53 |                      -30.52
 2001 |                      -46.11 |                      -29.29
 2002 |                      -44.34 |                      -28.31
 2003 |                      -43.75 |                      -24.79
 2004 |                      -39.44 |                      -21.15
 2005 |                      -36.54 |                      -18.12
 2006 |                      -33.52 |                      -15.53
 2007 |                      -31.11 |                      -11.99
 2008 |                      -25.22 |                      -11.41
 2009 |                      -23.57 |                      -12.29
 2010 |                      -16.82 |                       -6.74
 2011 |                      -12.80 |                       -3.83
 2012 |                       -6.18 |                       -2.40
 2013 |                        0.00 |                        0.00
 2014 |                        6.24 |                        0.16
 2015 |                       11.07 |                       -0.60
 2016 |                       17.93 |                       -0.61
 2017 |                       25.55 |                        0.59
 2018 |                       34.35 |                        2.80
 2019 |                       41.96 |                        2.87


/*4) Correlazione tra impronta carbonica (carbon_footprint), biocapacità totale (total_biocapacity) e PIL pro capite (per_capita_gdp)

Adesso strutturo una query per evidenziare eventuali correlazioni tra carbon_footprint, total_biocapacity e per_capita_gdp.
Per facilitare l'interpretazione dei risultati ho creato ecological_balance, che costituisce, di fatto, differenza tra impronta carbonica e 
biocapacità. Un valore positivo indicherà quindi un deficit ecologico, mentre un valore positivo un surplus.
Inoltre, sempre per rendere più chiari e interpretabili i dati, fornisco di seguito una definizione di ogni parametro considerato:

Impronta carbonica (carbon_footprint): impronta ecologica delle emissioni di carbonio, misurata in ettari globali per persona.

Biocapacità totale (total_biocapacity): indicatore di sostenibilità ambientale applicabile ad un dato territorio per stimare i 
servizi ecosistemici che quel territorio è in grado di erogare, misurata in ettari globali per persona.

PIL pro capite (per_capita_gdp): Prodotto interno lordo pro capite. In questa analisi verrà utilizzato per definire quanto 
economicamente sviluppato sia un paese.

Di seguito la query, con un limite nei risultati fissato ai primi 20 per rendere più agevole l'analisi dei risultati. */

SELECT e.country, e.carbon_footprint, e.total_biocapacity, (e.carbon_footprint - e.total_biocapacity) AS ecological_balance, e.per_capita_gdp
FROM ecological_data_2023 e
WHERE e.carbon_footprint IS NOT NULL AND e.total_biocapacity IS NOT NULL AND e.per_capita_gdp IS NOT NULL
ORDER BY ecological_balance DESC
LIMIT 20;

-- Ottengo il seguente output:

country                    | carbon_footprint | total_biocapacity | ecological_balance | per_capita_gdp 
---------------------------+------------------+-------------------+--------------------+----------------
 Qatar                     |            11.60 |              1.04 |              10.56 |       96605.00
 Luxembourg                |             8.00 |              1.23 |               6.77 |      120505.00
 Bahrain                   |             6.80 |              0.56 |               6.24 |       49184.00
 United Arab Emirates      |             6.50 |              0.54 |               5.96 |       67026.00
 Kuwait                    |             6.40 |              0.81 |               5.59 |       43613.00
 Singapore                 |             4.40 |              0.10 |               4.30 |      112699.00
 Brunei Darussalam         |             6.80 |              2.62 |               4.18 |       64198.00
 Saudi Arabia              |             4.50 |              0.70 |               3.80 |       47423.00
 Korea, Republic of        |             4.20 |              0.65 |               3.55 |       45438.00
 Trinidad and Tobago       |             4.50 |              1.38 |               3.12 |       25596.00
 Oman                      |             4.90 |              1.80 |               3.10 |       30222.00
 Belgium                   |             3.60 |              1.16 |               2.44 |       52749.00
 Israel                    |             2.60 |              0.24 |               2.36 |       43000.00
 Japan                     |             2.90 |              0.63 |               2.27 |       41809.00
 China                     |             2.60 |              0.80 |               1.80 |       18299.00
 Iran, Islamic Republic of |             2.40 |              0.75 |               1.65 |       15702.00
 Barbados                  |             1.80 |              0.26 |               1.54 |       14910.00
 Germany                   |             2.70 |              1.61 |               1.09 |       54192.00
 United Kingdom            |             2.10 |              1.02 |               1.08 |       47366.00
 United States of America  |             4.80 |              3.72 |               1.08 |       65118.00

/* I risultati suggeriscono in modo molto evidente che i paesi del Golfo (Qatar, Kuwait, Emirati Arabi e Bahrain) condividono 
un’elevata impronta carbonica in rapporto alla biocapacità estremamente limitata. Questi valori sottolineano un’economia altamente 
insostenibile in termini ecologici. In particolare il Qatar ha un'impronta estremamente elevata (11.60) rispetto alla biocapacità 
(1.04). Questo squilibrio si traduce in un deficit ecologico di 10,56, il più elevato tra i paesi analizzati. Tuttavia, questa forte 
pressione ambientale si accompagna a un PIL pro capite estremamente alto (96.605 USD), suggerendo che il Qatar basa la sua ricchezza 
economica su settori ad alta intensità di risorse. 

Un caso simile è quello di Singapore, dove l’impronta carbonica è relativamente più contenuta (4,4), ma la biocapacità è quasi nulla 
(0,1). Questo rende il deficit ecologico (4,3) comunque elevato, soprattutto se confrontato con il PIL pro capite di 112.699 USD. 
La situazione di Singapore è emblematica delle sfide affrontate dai Paesi con scarse risorse naturali: la crescita economica è stata 
notevole, ma a un costo ambientale significativo.

In Europa, la situazione è più variegata. Lussemburgo ha un deficit ecologico di 6,77, uno dei più alti tra i Paesi europei, 
nonostante il PIL pro capite sia il più elevato dell’intero gruppo (120.505 USD). Questo suggerisce che, pur essendo un Paese 
economicamente avanzato, il Lussemburgo non riesce ancora a bilanciare il consumo di risorse con la sostenibilità ambientale. 
In contrasto, Paesi come Germania e Regno Unito mostrano un quadro più equilibrato: la Germania ha un deficit ecologico di 1,09 e il
Regno Unito di 1,08, con un PIL pro capite rispettivamente di 54.192 USD e 47.366 USD . Questi dati indicano che è possibile avere
pronunciati indici di sviluppo economico riducendo al minimo il consumo eccessivo di risorse naturali, probabilmente grazie a 
politiche ambientali più attente.

Un altro caso interessante è rappresentato dagli Stati Uniti. Con un’impronta carbonica di 4,8 e una biocapacità di 3,72, il bilancio 
ecologico è di 1,08, un valore inferiore rispetto a molti altri Paesi con un PIL pro capite simile (65.118 USD). Questo risultato 
relativamente positivo può essere attribuito alla vasta disponibilità di risorse naturali negli Stati Uniti, anche se il consumo di 
risorse rimane elevato in termini assoluti.

Infine, guardando alla Cina, notiamo che , nonostante un PIL pro capite relativamente basso (18.299 USD), la sua impronta carbonica 
è significativa (2,6), e la biocapacità di 0,8 porta a un deficit ecologico di 1,8. Questo suggerisce che la Cina, con una popolazione 
vastissima e un’economia in crescita, potrebbe affrontare sfide crescenti in termini di sostenibilità se non adotta politiche 
ambientali adeguate. 

In generale, i dati mostrano che i Paesi con alti PIL pro capite tendono ad avere un deficit ecologico maggiore, poiché la crescita 
economica è spesso legata a un maggiore consumo di risorse naturali. Tuttavia, Paesi come la Germania e il Regno Unito dimostrano che 
è possibile mantenere un’economia forte con un impatto ambientale relativamente contenuto. Questo sottolinea l’importanza di politiche 
energetiche e ambientali avanzate per bilanciare sviluppo economico e sostenibilità ambientale.


5)L’impatto dell’accesso ai combustibili puliti sulle emissioni di CO2 e sull’aspettativa di vita.

Questa analisi ha lo scopo di indagare la correlazione tra l’accesso a combustibili puliti per cucinare, le emissioni di CO₂ e la 
qualità della vita rappresentata dall’aspettativa di vita.

Ho notato che nei dataset considerati vi era una discrepanza riguardante gli Stati Uniti: in "Global Ecological Footprint 2023" sono
indicati come United States of America, mentre in "Global Data on Sustainable Energy (2000-2020)" come United States.
Per ovviare a questo problema ho utilizzato l'espressione condizionale CASE, che mi ha consentito quindi di far corrispondere i due
nomi nelle tabelle global_sustainable_energy_data e ecological_data_2023.

Per rendere i dati più chiari e leggibili, prenderò in considerazione i primi e gli ultimi 10 paesi, ordinati in base alle emissioni
di CO2.

Strutturo la query come di seguito: */

SELECT g.entity AS country,
       g.access_to_clean_fuels_for_cooking AS clean_fuels_access_percent,
       g.co2_emissions_kt AS total_co2_emissions,
       e.life_expectancy AS life_expectancy
FROM global_sustainable_energy_data g
JOIN ecological_data_2023 e
ON
    CASE 
        WHEN g.entity = 'United States' THEN 'United States of America'
        ELSE g.entity
    END = e.country
WHERE g.year = 2019
    AND g.access_to_clean_fuels_for_cooking IS NOT NULL
    AND g.co2_emissions_kt IS NOT NULL
    AND e.life_expectancy IS NOT NULL
ORDER BY g.co2_emissions_kt DESC
LIMIT 10;


SELECT g.entity AS country,
       g.access_to_clean_fuels_for_cooking AS clean_fuels_access_percent,
       g.co2_emissions_kt AS total_co2_emissions,
       e.life_expectancy AS life_expectancy
FROM global_sustainable_energy_data g
JOIN ecological_data_2023 e
ON
    CASE 
        WHEN g.entity = 'United States' THEN 'United States of America'
        ELSE g.entity
    END = e.country
WHERE g.year = 2019
    AND g.access_to_clean_fuels_for_cooking IS NOT NULL
    AND g.co2_emissions_kt IS NOT NULL
    AND e.life_expectancy IS NOT NULL
ORDER BY g.co2_emissions_kt ASC
LIMIT 10;

-- Ecco il risultato della prima query con i primi 10 paesi in base alle emissioni di CO2:

country        | clean_fuels_access_percent | total_co2_emissions | life_expectancy 
---------------+----------------------------+---------------------+-----------------
 China         |                      77.60 |         10707219.73 |           78.00
 United States |                     100.00 |          4817720.22 |           76.00
 India         |                      63.90 |          2456300.05 |           67.00
 Japan         |                     100.00 |          1081569.95 |           84.00
 Germany       |                     100.00 |           657400.02 |           81.00
 Indonesia     |                      81.85 |           619840.03 |           68.00
 Canada        |                     100.00 |           580210.02 |           83.00
 Saudi Arabia  |                     100.00 |           523780.03 |           77.00
 Mexico        |                      84.90 |           449269.99 |           70.00
 South Africa  |                      86.30 |           439640.01 |           62.00

 -- Di seguito invece il risultato della seconda query con gli ultimi 10 paesi, sempre in base alle emissioni di CO2:

 country                  | clean_fuels_access_percent | total_co2_emissions | life_expectancy 
--------------------------+----------------------------+---------------------+-----------------
 Sao Tome and Principe    |                       3.00 |              150.00 |           68.00
 Tonga                    |                      82.10 |              160.00 |           71.00
 Dominica                 |                      89.30 |              170.00 |           73.00
 Vanuatu                  |                       8.00 |              210.00 |           70.00
 Central African Republic |                       0.70 |              240.00 |           54.00
 Samoa                    |                      35.30 |              300.00 |           73.00
 Comoros                  |                       7.80 |              320.00 |           63.00
 Guinea-Bissau            |                       1.00 |              330.00 |           60.00
 Grenada                  |                      89.60 |              330.00 |           75.00
 Solomon Islands          |                       9.20 |              360.00 |           70.00

 
 /* Partendo dai paesi con le maggiori emissioni di CO₂, emerge che, nonostante l’alto impatto ambientale, molti di questi stati
garantiscono un accesso quasi totale ai combustibili puliti. Gli Stati Uniti, ad esempio, con il 100% della popolazione che accede 
a combustibili puliti, emettono oltre 4.8 milioni kt CO2 equivalente, mentre l’aspettativa di vita si attesta sui 76 anni. 
Questo può indicare che, nei paesi sviluppati, le alte emissioni sono spesso il risultato di modelli di consumo intensivo e di
industrializzazione piuttosto che della mancanza di infrastrutture energetiche sostenibii.

La Cina e l’India, con emissioni rispettivamente di 10.7 e 2.4 milioni di kt CO2 equivalente, mostrano invece un quadro diverso. La 
Cina garantisce un accesso ai combustibili puliti al 77.60% della popolazione, mentre l’India si ferma al 63.90%. Questi dati 
sottolineano che una quota significativa della popolazione in entrambi i paesi utilizza ancora fonti energetiche non pulite, 
contribuendo ulteriormente all’impatto ambientale.

Guardando ai paesi con emissioni più basse, troviamo situazioni decisamente diverse. La Repubblica Centrafricana, con emissioni 
quasi trascurabili di 240 kt CO2 equivalente, registra un accesso ai combustibili puliti pari a solo lo 0.70% della popolazione e 
 un’aspettativa di vita di appena 54 anni. In questi casi, l’impatto ambientale è minimo, ma ciò riflette più una mancanza di sviluppo 
economico e infrastrutturale piuttosto che una reale sostenibilità ambientale. Allo stesso modo, paesi come Guinea-Bissau (1% di 
accesso ai combustibili puliti, 330 kt CO2 equivalente) e Comore (7.80% di accesso, 320 kt CO2 equivalente) mostrano che basse 
emissioni non significano necessariamente un impatto ambientale positivo, ma piuttosto una ridotta industrializzazione.

Un altro punto interessante emerge negli stati insulari Grenada e Dominica, che, pur avendo emissioni trascurabili (330 e 170 
kt CO2 equivalente), offrono un accesso ai combustibili puliti rispettivamente all’89.60% e all’89.30% della popolazione. Entrambi 
questi paesi godono di aspettative di vita relativamente alte (75 e 73 anni), suggerendo che, nonostante il basso livello di 
emissioni, un buon accesso all’energia pulita può mitigare gli effetti negativi di un sistema industriale limitato.

In sintesi, dai dati emerge che la complessità dell'impatto ambientale va oltre la semplice misurazione delle emissioni di anidride 
carbonica. Consideriamo ad esempio paesi industrializzati come Stati Uniti, Giappone e Germania: qui le elevate emissioni convivono 
con tecnologie avanzate e politiche ambientali che garantiscono un'alta qualità della vita.
Nei paesi in via di sviluppo, invece, bassi livelli di emissioni spesso celano carenze infrastrutturali e limitato accesso a energie 
pulite, con conseguenze dirette sul benessere della popolazione.
I piccoli stati insulari offrono un modello interessante: dimostrano che è possibile mantenere bassi livelli di emissioni e, al 
contempo, garantire un'elevata qualità della vita attraverso probabili scelte energetiche sostenibili e una gestione efficace delle 
risorse.

Questi dati ci invitano a considerare l'impatto ambientale come un sistema complesso nel quale emissioni, sviluppo tecnologico e 
contesto sociale si intrecciano in modo inscindibile.


- Conclusioni

Le analisi proposte offrono panoramica parziale - ma piuttosto chiara - delle sfide ambientali ed economiche del nostro tempo. I dati 
evidenziano come i modelli di sviluppo economico, l’accesso all’energia pulita e la gestione delle risorse naturali siano strettamente 
interconnessi e influenzino non solo le emissioni di CO2, ma anche la qualità della vita e la sostenibilità a lungo termine.

I paesi industrializzati come Cina, Stati Uniti e Germania mostrano che l’industrializzazione avanzata può convivere con politiche 
ambientali efficaci, ma solo quando sostenuta da un impegno concreto verso la transizione energetica. Al contrario, nei paesi in via 
di sviluppo, bassi livelli di emissioni spesso celano disuguaglianze sociali e infrastrutturali che penalizzano l’accesso alle risorse 
essenziali, come i combustibili puliti, con impatti negativi sulla qualità della vita.

È interessante notare come piccoli stati insulari e alcuni paesi europei dimostrino che un modello di sviluppo più sostenibile è 
possibile, bilanciando un’alta qualità della vita con una ridotta pressione ecologica. 
Tuttavia, la predominanza di paesi con deficit ecologici marcati ci ricorda che le attuali strategie di sviluppo globale non sono 
ancora allineate con gli obiettivi di sostenibilità.

Questa analisi sottolinea la necessità di un approccio sistemico per affrontare le sfide climatiche: non è sufficiente ridurre le 
emissioni di CO₂ o aumentare la quota di energia rinnovabile, ma occorre una trasformazione globale che integri economia, sviluppo
economico e sostenibilità in una visione comune. 
