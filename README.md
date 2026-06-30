# Priority PAH Source & Health Table

Lookup table and query that map detected **polycyclic aromatic hydrocarbons (PAHs)**
to their common environmental sources and associated health information, used to
generate participant-facing report-back materials (RBRR). Content is maintained in
**English and Spanish**.

## Repository contents

| File | Description |
|------|-------------|
| `priority_pah_data.csv` | Source data table — one row per priority PAH with source/health fields in English and Spanish |
| `format_pah_table.sql` | Query that joins/filters the data table and produces the formatted output |
| `pah_source_health_table.<ext>` | Formatted final table as used in reports |

## Data dictionary (`priority_pah_data.csv`)

| Column | Type | Description |
|--------|------|-------------|
| `pah_name` | text | Compound name |
| `cas_rn` | text | CAS Registry Number |
| `priority_flag` | bool | Whether the PAH is on the current priority list |
| `source_en` / `source_es` | text | Common sources (English / Spanish) |
| `health_en` / `health_es` | text | Associated health information (English / Spanish) |

> Replace the rows above with your actual column names and types.

## How the formatted table is built

`format_pah_table.sql` reads the data table and renders the report-ready table:

    -- paste format_pah_table.sql here, e.g.:
    SELECT pah_name, source_en, health_en
    FROM priority_pah_data
    WHERE priority_flag = 1
    ORDER BY pah_name;

Run against {{your database / engine}}:

    {{psql -f format_pah_table.sql, or your run command}}

## Bilingual content

Each source/health field has paired `_en` and `_es` columns so the same table can
render English or Spanish reports. To add a language, add a parallel column set and
extend the query's SELECT list.

## Updating the table

1. Edit `priority_pah_data.csv` (add/remove a priority PAH, update source or health text).
2. Re-run `format_pah_table.sql` to regenerate the formatted table.
3. Commit both the data and regenerated output.

## Citation

If you use this resource, please cite:

> Barton ML, Rohlman D. *Using software to automate and advance report back of research
> results (RBRR) to participants and communities in research studies.* {{Journal,
> year}}.

## License

MIT

## Contact

{{Name / lab / email}}
