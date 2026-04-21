-- File: daily_dist.sql
-- Purpose: Build unified daily dataset across Google, Meta, TikTok
-- Input: platform-specific views
-- Output: model_input_v2.daily_dist
-- Notes: Includes country-to-state mapping (simplified for demo)

create or replace view model_input_v2.daily_dist as (
with base as (	
	select generate_series(
		'2024-01-01'::date
		, '2024-12-31'::date
		, interval '1 day'
	)::date as date
		, location_code as state_code
		, location_name as state
	from utility.location_map
	where location_code in ('NY','MA','CT','ME','NH','VT','RI')
), facebook as (
	select b.date
		, b.state
		, f.campaign_type
		, sum(coalesce(f.clicks,0)) as clicks
		, sum(coalesce(f.impressions,0)) as impressions
		, sum(coalesce(f.cost,0)) as cost
	from base b
	left join model_input_v2.facebook_ads f
	on b.date = f.date and b.state_code = f.state
	group by 1,2,3
	order by 1 desc, 2
), google as (
	select b.date
		, b.state
		, g.campaign_type
		, sum(coalesce(g.clicks,0)) as clicks
		, sum(coalesce(g.impressions,0)) as impressions
		, sum(coalesce(g.cost,0)) as cost
	from base b
	left join model_input_v2.google_ads g
	on b.date = g.date and b.state_code = g.state
	group by 1,2,3
	order by 1 desc, 2
), tiktok as (
	select b.date
		, b.state
		, t.campaign_type
		, sum(coalesce(t.clicks,0)) as clicks
		, sum(coalesce(t.impressions,0)) as impressions
		, sum(coalesce(t.cost,0)) as cost
	from base b
	left join model_input_v2.tiktok_ads t
	on b.date = t.date and b.state_code = t.state
	group by 1,2,3
	order by 1 desc, 2
)
select b.date
	, b.state
	-- META
	, sum(coalesce(fdis.clicks,0)) as clicks_meta_display
	, sum(coalesce(fdis.impressions,0)) as imps_meta_display
	, sum(coalesce(fdis.cost,0)) as cost_meta_display
	, sum(coalesce(fsho.clicks,0)) as clicks_meta_shopping
	, sum(coalesce(fsho.impressions,0)) as imps_meta_shopping
	, sum(coalesce(fsho.cost,0)) as cost_meta_shopping
	, sum(coalesce(fsrc.clicks,0)) as clicks_meta_search
	, sum(coalesce(fsrc.impressions,0)) as imps_meta_search
	, sum(coalesce(fsrc.cost,0)) as cost_meta_search
	, sum(coalesce(fvid.clicks,0)) as clicks_meta_video
	, sum(coalesce(fvid.impressions,0)) as imps_meta_video
	, sum(coalesce(fvid.cost,0)) as cost_meta_video
	-- GOOGLE
	, sum(coalesce(gdis.clicks,0)) as clicks_ggl_display
	, sum(coalesce(gdis.impressions,0)) as imps_ggl_display
	, sum(coalesce(gdis.cost,0)) as cost_ggl_display
	, sum(coalesce(gsho.clicks,0)) as clicks_ggl_shopping
	, sum(coalesce(gsho.impressions,0)) as imps_ggl_shopping
	, sum(coalesce(gsho.cost,0)) as cost_ggl_shopping
	, sum(coalesce(gsrc.clicks,0)) as clicks_ggl_search
	, sum(coalesce(gsrc.impressions,0)) as imps_ggl_search
	, sum(coalesce(gsrc.cost,0)) as cost_ggl_search
	, sum(coalesce(gvid.clicks,0)) as clicks_ggl_video
	, sum(coalesce(gvid.impressions,0)) as imps_ggl_video
	, sum(coalesce(gvid.cost,0)) as cost_ggl_video
	-- TIKTOK
	, sum(coalesce(tdis.clicks,0)) as clicks_ttk_display
	, sum(coalesce(tdis.impressions,0)) as imps_ttk_display
	, sum(coalesce(tdis.cost,0)) as cost_ttk_display
	, sum(coalesce(tsho.clicks,0)) as clicks_ttk_shopping
	, sum(coalesce(tsho.impressions,0)) as imps_ttk_shopping
	, sum(coalesce(tsho.cost,0)) as cost_ttk_shopping
	, sum(coalesce(tsrc.clicks,0)) as clicks_ttk_search
	, sum(coalesce(tsrc.impressions,0)) as imps_ttk_search
	, sum(coalesce(tsrc.cost,0)) as cost_ttk_search
	, sum(coalesce(tvid.clicks,0)) as clicks_ttk_video
	, sum(coalesce(tvid.impressions,0)) as imps_ttk_video
	, sum(coalesce(tvid.cost,0)) as cost_ttk_video
	-- POPULATION
	, round(avg(p.population::integer),0) as population
from base b

left join facebook fdis on b.date = fdis.date and b.state = fdis.state and fdis.campaign_type = 'Display'
left join facebook fsho on b.date = fsho.date and b.state = fsho.state and fsho.campaign_type = 'Shopping'
left join facebook fsrc on b.date = fsrc.date and b.state = fsrc.state and fsrc.campaign_type = 'Search'
left join facebook fvid on b.date = fvid.date and b.state = fvid.state and fvid.campaign_type = 'Video'

left join google gdis on b.date = gdis.date and b.state = gdis.state and gdis.campaign_type = 'Display'
left join google gsho on b.date = gsho.date and b.state = gsho.state and gsho.campaign_type = 'Shopping'
left join google gsrc on b.date = gsrc.date and b.state = gsrc.state and gsrc.campaign_type = 'Search'
left join google gvid on b.date = gvid.date and b.state = gvid.state and gvid.campaign_type = 'Video'

left join tiktok tdis on b.date = tdis.date and b.state = tdis.state and tdis.campaign_type = 'Display'
left join tiktok tsho on b.date = tsho.date and b.state = tsho.state and tsho.campaign_type = 'Shopping'
left join tiktok tsrc on b.date = tsrc.date and b.state = tsrc.state and tsrc.campaign_type = 'Search'
left join tiktok tvid on b.date = tvid.date and b.state = tvid.state and tvid.campaign_type = 'Video'

left join utility.population_us p on date_part('year', b.date) = p.year::integer and b.state = p.location_name
group by 1,2
order by 1 desc, 2
);