-- File: weekly_dist.sql
-- Purpose: Aggregate daily data to weekly level and calculate GRP proxy metrics
-- Input: model_input_v2.daily_dist
-- Output: model_input_v2.weekly_dist
-- Notes: GRP = impressions per 1,000 population (proxy; no reach data)

create or replace view model_input_v2.weekly_dist as (
with weekly_dist as (
select date_trunc('week', date)::date as week
	, state
	, sum(coalesce(clicks_meta_display,0)) as clicks_meta_display
	, sum(coalesce(imps_meta_display,0)) as imps_meta_display
	, sum(coalesce(cost_meta_display,0)) as cost_meta_display
	, sum(coalesce(clicks_meta_shopping,0)) as clicks_meta_shopping
	, sum(coalesce(imps_meta_shopping,0)) as imps_meta_shopping
	, sum(coalesce(cost_meta_shopping,0)) as cost_meta_shopping
	, sum(coalesce(clicks_meta_search,0)) as clicks_meta_search
	, sum(coalesce(imps_meta_search,0)) as imps_meta_search
	, sum(coalesce(cost_meta_search,0)) as cost_meta_search
	, sum(coalesce(clicks_meta_video,0)) as clicks_meta_video
	, sum(coalesce(imps_meta_video,0)) as imps_meta_video
	, sum(coalesce(cost_meta_video,0)) as cost_meta_video
	, sum(coalesce(clicks_ggl_display,0)) as clicks_ggl_display
	, sum(coalesce(imps_ggl_display,0)) as imps_ggl_display
	, sum(coalesce(cost_ggl_display,0)) as cost_ggl_display
	, sum(coalesce(clicks_ggl_shopping,0)) as clicks_ggl_shopping
	, sum(coalesce(imps_ggl_shopping,0)) as imps_ggl_shopping
	, sum(coalesce(cost_ggl_shopping,0)) as cost_ggl_shopping
	, sum(coalesce(clicks_ggl_search,0)) as clicks_ggl_search
	, sum(coalesce(imps_ggl_search,0)) as imps_ggl_search
	, sum(coalesce(cost_ggl_search,0)) as cost_ggl_search
	, sum(coalesce(clicks_ggl_video,0)) as clicks_ggl_video
	, sum(coalesce(imps_ggl_video,0)) as imps_ggl_video
	, sum(coalesce(cost_ggl_video,0)) as cost_ggl_video
	, sum(coalesce(clicks_ttk_display,0)) as clicks_ttk_display
	, sum(coalesce(imps_ttk_display,0)) as imps_ttk_display
	, sum(coalesce(cost_ttk_display,0)) as cost_ttk_display
	, sum(coalesce(clicks_ttk_shopping,0)) as clicks_ttk_shopping
	, sum(coalesce(imps_ttk_shopping,0)) as imps_ttk_shopping
	, sum(coalesce(cost_ttk_shopping,0)) as cost_ttk_shopping
	, sum(coalesce(clicks_ttk_search,0)) as clicks_ttk_search
	, sum(coalesce(imps_ttk_search,0)) as imps_ttk_search
	, sum(coalesce(cost_ttk_search,0)) as cost_ttk_search
	, sum(coalesce(clicks_ttk_video,0)) as clicks_ttk_video
	, sum(coalesce(imps_ttk_video,0)) as imps_ttk_video
	, sum(coalesce(cost_ttk_video,0)) as cost_ttk_video
	, max(population) as population
from model_input_v2.daily_dist
group by 1,2
)
select *
	, imps_meta_display::numeric / nullif(population,0) * 1000 as grps_meta_display
	, imps_meta_shopping::numeric / nullif(population,0) * 1000 as grps_meta_shopping
	, imps_meta_search::numeric / nullif(population,0) * 1000 as grps_meta_search
	, imps_meta_video::numeric / nullif(population,0) * 1000 as grps_meta_video
	, imps_ggl_display::numeric / nullif(population,0) * 1000 as grps_ggl_display
	, imps_ggl_shopping::numeric / nullif(population,0) * 1000 as grps_ggl_shopping
	, imps_ggl_search::numeric / nullif(population,0) * 1000 as grps_ggl_search
	, imps_ggl_video::numeric / nullif(population,0) * 1000 as grps_ggl_video
	, imps_ttk_display::numeric / nullif(population,0) * 1000 as grps_ttk_display
	, imps_ttk_shopping::numeric / nullif(population,0) * 1000 as grps_ttk_shopping
	, imps_ttk_search::numeric / nullif(population,0) * 1000 as grps_ttk_search
	, imps_ttk_video::numeric / nullif(population,0) * 1000 as grps_ttk_video
from weekly_dist
order by week desc, state
);