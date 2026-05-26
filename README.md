# E-commerce Funnel Analysis with BigQuery and Tableau

## Executive Summary

This project analyzes an e-commerce customer journey from first website visit to final purchase using Google BigQuery for SQL analysis and Tableau for data visualization.

The analysis focuses on five key areas:

- Overall funnel drop-off across the purchase journey
- Conversion rates between funnel stages
- Marketing channel performance by traffic source
- Average time users take to convert
- Revenue outcomes across the funnel

The final results show that 3,282 users entered the funnel through a page view, while 541 completed a purchase, resulting in an overall conversion rate of 16.48%.

Among marketing channels, **email** delivered the strongest conversion efficiency, with a 63.06% cart conversion rate and a 34.17% purchase conversion rate, while **social** generated relatively high traffic volume but the weakest conversion performance.

From a timing perspective, converted users moved quickly through the funnel, taking an average of 11 minutes from view to cart, 13 minutes from cart to purchase, and 24 minutes from first view to final purchase.

Revenue analysis showed 541 buyers generated total revenue of 58,322.19, with an average order value of 107.80 and revenue per visitor of 17.77.

## Project Objective

The goal of this project is to evaluate customer funnel performance and identify which marketing channels are most effective at driving conversions and revenue.

The project answers the following business questions:

- How many users move through each funnel stage?
- Where are the largest conversion drop-offs?
- Which traffic sources produce the strongest funnel performance?
- How long does conversion typically take?
- How much revenue does the funnel generate overall?

## Tools Used

- **Google BigQuery** for SQL querying and transformation
- **Tableau Public** for dashboard creation and storytelling
- **GitHub** for project documentation and portfolio presentation
- **CSV exports** from BigQuery views for Tableau Public compatibility

## Dataset Overview

The dataset contains user-level event records from an e-commerce funnel. The analysis uses the following fields:

- `user_id`
- `event_type`
- `event_date`
- `traffic_source`
- `amount`

The main funnel events analyzed are:

- `page_view`
- `add_to_cart`
- `checkout_start`
- `payment_info`
- `purchase`

To match the tutorial window and ensure reproducible results, the analysis was limited to the fixed date range:

- `2026-01-11` to `2026-02-10`

## Key Results

### Funnel Stage Volume

The funnel counts show a clear drop-off from initial engagement to purchase:

| Funnel Stage | Users |
|-------------|------:|
| Page View | 3,282 |
| Add to Cart | 1,043 |
| Checkout Start | 741 |
| Payment Info | 585 |
| Purchase | 541 |

This means that only 541 of the 3,282 users who entered the funnel completed a purchase.

### Funnel Conversion Rates

The conversion-rate output highlights where the biggest losses occur:

| Conversion Step | Rate |
|----------------|-----:|
| View to Cart | 31.78% |
| Cart to Checkout | 71.05% |
| Checkout to Payment | 78.95% |
| Payment to Purchase | 92.48% |
| Overall Conversion | 16.48% |

The weakest step is the transition from **page view to add to cart**, suggesting the largest drop-off happens early in the journey. By contrast, the strongest step is **payment to purchase**, which suggests that once users reach the payment stage, they are highly likely to complete the transaction.

### Marketing Channel Performance

Traffic-source analysis shows strong differences in both volume and quality:

| Traffic Source | Views | Carts | Purchases | Cart Conversion Rate | Purchase Conversion Rate | Cart-to-Purchase Rate |
|---------------|------:|------:|----------:|---------------------:|-------------------------:|----------------------:|
| Organic | 1,326 | 449 | 226 | 33.86% | 17.04% | 50.33% |
| Paid Ads | 630 | 239 | 132 | 37.94% | 20.95% | 55.23% |
| Email | 360 | 227 | 123 | 63.06% | 34.17% | 54.19% |
| Social | 966 | 128 | 60 | 13.25% | 6.21% | 46.88% |

Key observations:

- **Organic** brings the highest number of views and purchases overall.
- **Email** is the most efficient converting channel by a wide margin.
- **Paid Ads** performs well and delivers balanced conversion quality.
- **Social** underperforms significantly in both cart and purchase conversion.

This suggests that traffic volume alone does not guarantee business value. The best-performing acquisition channels are the ones that produce qualified users, not just visits.

### Time to Conversion

The time-to-conversion output shows that converted users move through the funnel relatively quickly:

| Metric | Value |
|--------|------:|
| Converted Users | 541 |
| Avg View to Cart | 11 minutes |
| Avg Cart to Purchase | 13 minutes |
| Avg Total Journey | 24 minutes |

This indicates that users who convert generally make purchase decisions within a short time frame. That may suggest low-friction checkout behavior for high-intent visitors.

### Revenue Funnel Performance

The revenue view connects behavioral funnel performance to monetary outcomes:

| Revenue Metric | Value |
|---------------|------:|
| Total Visitors | 3,282 |
| Total Buyers | 541 |
| Total Orders | 541 |
| Total Revenue | 58,322.19 |
| Avg Order Value | 107.80 |
| Revenue per Buyer | 107.80 |
| Revenue per Visitor | 17.77 |

Because total buyers and total orders are equal, each buyer appears to have made one order during the selected period.

## Business Insights

Based on the analysis, the strongest takeaways are:

- The largest funnel loss happens between **page view and add to cart**, making top-of-funnel engagement the most important area for optimization.
- **Email** is the most effective channel in terms of conversion efficiency, even though it does not generate the most traffic.
- **Organic** is the largest source of purchases by volume and remains an important acquisition driver.
- **Social** brings traffic but converts poorly, suggesting weak audience targeting, low purchase intent, or poor traffic quality.
- Users who eventually purchase do so quickly, which means remarketing and conversion strategies may be most effective within a short decision window.
- Revenue performance is driven more by conversion quality than by raw traffic volume.

## Tableau Story Structure

The Tableau story for this project is organized into five main views:

1. **Overall Funnel Counts**  
   A stage-by-stage chart showing how many users reached each point in the purchase journey.

2. **Funnel Conversion Rates**  
   A chart highlighting the strongest and weakest step conversions.

3. **Traffic Source Funnel Performance**  
   A comparison of views, carts, and purchases across marketing channels.

4. **Traffic Source Conversion Efficiency**  
   A focused view comparing purchase conversion and cart-to-purchase efficiency by channel.

5. **Time and Revenue KPIs**  
   Summary KPI views showing average time-to-conversion and revenue outcomes.

This structure supports a clear business story: volume enters the funnel, users drop off at different stages, channels behave differently, conversion speed matters, and all of this ultimately affects revenue.

## SQL Outputs Used

The following BigQuery views were created and exported as CSV files for use in Tableau Public:

- `v_funnel_counts.csv`
- `v_funnel_rates.csv`
- `v_funnel_by_source.csv`
- `v_time_to_conversion.csv`
- `v_revenue_funnel.csv`

These files act as the bridge between BigQuery and Tableau Public, since Tableau Public does not support a direct BigQuery connection.

## Skills Demonstrated

This project demonstrates the ability to:

- Write SQL queries in BigQuery
- Build multi-step funnel analysis using conditional aggregation
- Calculate conversion rates across funnel stages
- Segment performance by traffic source
- Analyze time-to-conversion using timestamp logic
- Connect behavioral analysis to revenue metrics
- Prepare SQL outputs for BI visualization
- Build a business-facing story in Tableau

## Repository Structure

Suggested repository structure:

```text
├── README.md
├── sql/
│   ├── funnel_analysis.sql
│   └── create_views.sql
├── data/
│   ├── v_funnel_counts.csv
│   ├── v_funnel_rates.csv
│   ├── v_funnel_by_source.csv
│   ├── v_time_to_conversion.csv
│   └── v_revenue_funnel.csv
├── tableau/
│   ├── funnel_analysis.twb
│   └── screenshots/
└── images/
```

## Conclusion

This project transforms raw event-level e-commerce data into a structured funnel analysis workflow using BigQuery and Tableau.

The results show that the funnel performs strongest in later-stage conversion, while the biggest loss occurs at the first major behavioral step from page view to add to cart. Channel analysis further reveals that email is the most efficient traffic source, organic is the strongest driver of purchase volume, and social underperforms on conversion quality.

Overall, the project demonstrates how SQL-based funnel analysis can be turned into a clear visual business story that supports marketing, conversion, and revenue decision-making.
