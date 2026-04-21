-- File: tiktok_ads.sql
-- Purpose: Create platform-specific daily dataset (TikTok)
-- Input: utility.global_ads_performance_dataset
-- Output: model_input_v2.tiktok_ads
-- Notes: Standardizes schema and applies country → state mapping for demo purposes

create or replace view model_input_v2.tiktok_ads as (
select date
	, case when country = 'USA' then 'NY'
		when country = 'Canada' then 'MA'
		when country = 'UK' then 'CT'
		when country = 'UAE' then 'ME'
		when country = 'India' then 'NH'
		when country = 'Germany' then 'VT'
		when country = 'Australia' then 'RI'
	  end as state
	, campaign_type
	, sum(coalesce(clicks,0)) as clicks
	, sum(coalesce(impressions,0)) as impressions
	, sum(coalesce(ad_spend,0)) as cost
from utility.global_ads_performance_dataset
where platform = 'TikTok Ads'
group by 1,2,3
order by 1 desc
);