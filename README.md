# Marketing MMM GRP Project

## Goal
Build a weekly, model-ready marketing dataset with population-normalized metrics from multi-source data.

## Overview
This project transforms multi-platform marketing data into a unified dataset, aggregates it to a weekly level, and normalizes impressions using population data to create GRP-based metrics.

The focus is on:
- multi-source data structuring
- temporal aggregation (daily → weekly)
- population normalization for modeling inputs

---

## Key Concepts Demonstrated
- Structuring data from multiple platforms (Google, Meta, TikTok)
- Creating consistent schemas across sources
- Building a unified daily dataset
- Aggregating data to weekly granularity
- Normalizing metrics using population-based scaling

---

## Data Sources
- Multi-platform marketing dataset (Google, Meta, TikTok)
- State population dataset

---

## Methodology

### Source Separation
Although the original dataset contains multiple platforms in a single table, separate views were created for Google, Meta, and TikTok.

This step was included to demonstrate a common real-world workflow where:
- data originates from different systems
- each source is transformed independently
- sources are later combined into a unified structure

---

### Geographic Transformation
The dataset includes country-level data. For this project, countries were mapped to U.S. states to enable population-based normalization.

This mapping is a simplification used for demonstration purposes.

---

### Daily Data Construction
A unified daily dataset was created by:
- aligning schemas across platforms
- combining all sources into a single structure
- standardizing key fields (date, state, metrics)

---

### Weekly Aggregation
Daily data was aggregated to a weekly level to:
- align with common MMM input requirements
- reduce volatility in daily metrics

The final weekly dataset is available as: model_input_v2.weekly_dist

---

### Population Normalization (GRP Proxy)
Impressions were normalized using state population to create a GRP-like metric:

> GRP (proxy) = (impressions / population) * 1000

This represents impressions per 1,000 people.

Because reach and frequency are not available, this serves as an **impression-based proxy for GRPs**, rather than a true GRP calculation.

---

## Assumptions & Limitations
- State-level geography is derived from a simplified country-to-state mapping.
- GRPs are based on impressions and do not account for reach or frequency.
- Smaller population states may exhibit higher normalized values due to scaling.
- The dataset structure was adapted for demonstration purposes and does not reflect true platform-level distributions.

---

## Output
The final output is a weekly dataset at the state level with:
- standardized metrics across platforms
- population-normalized GRP proxy metrics
- structure suitable for marketing mix modeling

---

## Reproducibility
SQL scripts for data transformation and aggregation are available in the `/sql` directory.