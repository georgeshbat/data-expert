# flights_dbt

dbt project that builds a data warehouse (schema `dwh`) from the `flights_demo` database (schema `stg`) in neon.

## Models

| Model | Type | Source tables |
|---|---|---|
| dim_airport | table | airports_data |
| dim_aircraft | table | aircrafts_data + seats |
| dim_date | table | generated |
| fact_flights | incremental | flights |
| fact_boarding_passes | incremental | ticket_flights + boarding_passes |
| fact_tickets | incremental | tickets + bookings |

## Environments

The profile `flights_demo` has two targets:

- `dev` - neon branch `development` (default)
- `prod` - neon branch `production`

## Run

```
dbt deps
dbt build                 # dev
dbt build --target prod   # production
```

## What is used

- Macros: `json_value`, `duration_hours`, `date_key`, `dbt_run_time`, `log_model`
- dbt_utils: `generate_surrogate_key`, `unique_combination_of_columns`
- Hooks: on-run-start / on-run-end (shd.dbt_logs), pre-hook / post-hook (shd.dbt_model_logs, -1 row in the dimensions)
- Indexes on the keys of every model
- Tests: generic tests in the schema.yml files and sql tests in the `tests` folder
