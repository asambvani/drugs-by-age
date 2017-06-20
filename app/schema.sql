CREATE TABLE IF NOT EXISTS cohorts (id INTEGER PRIMARY KEY, age TEXT, n INTEGER);

CREATE TABLE IF NOT EXISTS usages (id INTEGER PRIMARY KEY, usage REAL, cohort_id INTEGER, drug_id INTEGER);

CREATE TABLE IF NOT EXISTS frequencies (id INTEGER PRIMARY KEY, frequency REAL, cohort_id INTEGER, drug_id INTEGER);

CREATE TABLE IF NOT EXISTS drugs (id INTEGER PRIMARY KEY, name TEXT);
