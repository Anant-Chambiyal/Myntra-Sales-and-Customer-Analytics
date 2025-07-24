<div>
  <h1 align="center">Myntra Sales and Customer Analytics</h1>
</div>

<div align="center">
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/myntra_logo.png" width="350"/>
</div>

### Table of Contents

- [Project Background](#project-background)
- [Data Structure and Initial Checks](#data-structure-and-initial-checks)
- [Executive Summary](#executive-summary)
- [Insights Deep-Dive](#insights-deep-dive)
  - [Sales Trends and Growth Rates](#sales-trends-and-growth-rates)
  - [Product Performance](#product-performance)
  - [Customer Growth and Repeat Purchase Trends](#customer-growth-and-repeat-purchase-trends)
  - [Refund Rate Trends](#refund-rate-trends)
- [Recommendations](#recommendations)
- [Assumptions and Caveats](#assumptions-and-caveats)

***

## Project Background

Myntra, a major Indian e-commerce platform founded in 2007, specializes in selling fashion, lifestyle and beauty products via its website and mobile app.

The company has significant amounts of data on its customers, sales, delivery processes, product listings and ratings, financial transactions and return or refund activities. This project thoroughly analyzes this data in order to uncover critical insights that will improve Myntra's commercial success.

Insights and recommendations are provided on the following key areas:

- **Sales Trends Analysis:** Evaluation of 2023 and 2024 sales patterns, focussing on Revenue, Order Count and Average Order Value (AOV).
- **Product Performance:** An analysis of Myntra's various product lines, understanding their impact on sales.
- **Customer Analysis:** Understanding customer purchasing behaviour based on order frequency, demographic and geographic attributes, while also analyzing differences between new and repeat customers.
- **Refund Rate Overview:** Highlighting key return reasons, offering insights into post-purchase behaviour and potential areas for improvement.

An interactive Excel dashboard can be downloaded [here](https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/excel_dashboard/myntra_dashboard.xlsx).

The SQL queries utilized to clean, organize and prepare data for the analysis and dashboard can be found [here](https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/cleaning_and_analysis_using_sql/data_cleaning_using_sql.sql).

SQL queries regarding various business problems can be found [here](https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/cleaning_and_analysis_using_sql/data_analysis_using_sql.sql).

Visualization based on the SQL query results can be explored [here](https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/excel_dashboard/static_visualizations.xlsx).

## Data Structure and Initial Checks

Myntra's database structure consists of seven tables: customers, products, transactions, orders, ratings, returns_refund and delivery with a total row count of 52,005 records.

- **customers:** Each unique record provides information about customers, their demographics, geographic attributes and personal details.
- **products:** Each entry corresponds to a product listed on the platform, its category, brand and price details.
- **transactions:** Records financial activity for each order including payment method used.
- **orders:** Represent each purchase made by customers with product references, quantity purchased, delivery partner, applied coupon and discount amount.
- **ratings:** Includes customer feedback in the form of numerical product ratings and delivery ratings.
- **returns_refund:** Tracks returned or refunded orders, showing which orders were affected, reasons for return, refund status and associated dates.
- **delivery:** Contains details of delivery partners including their names, ratings and commission percentage.

<div align="center">
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/myntra_dataset_erd.png" alt="Myntra Dataset ERD"/>
  <br>
  <p>
    <em>
      Myntra Dataset ERD
    </em>      
  </p>
</div>
<br>

The image below summarizes data cleaning steps taken across the dataset, including column renaming, handling of missing values and various data enhancements.

<div align="center">
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/data_cleaning_log.png" alt="Data Cleaning Issue Log"/>
  <br>
  <p>
    <em>
      Summary of data quality issues, affected columns and how each was resolved across all tables
    </em>
  </p>
</div>

📁 [Download Data Cleaning Full Issue Log (Excel)](https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/cleaning_and_analysis_using_sql/data_cleaning_full_issue_log.xlsx)

## Executive Summary

Myntra's sales analysis of 52k records across 2023-2024 shows quarterly revenue stabilizing at ₹17.5 lakhs with Maharashtra, Gujarat, Uttar Pradesh and Madhya Pradesh contributing 60% of sales. All categories and brands contributing almost equally to sales. Repeat purchase rate has continuously increased in each quarter. Though, customer acquisition is a concern as total new customers have declined by over 50%. More than one-third of customers have yet to make a single purchase. One in ten orders is sent back, affecting operational efficiency and signals customer dissatisfaction.

Mnytra can benefit by revisiting its marketing strategy, testing new channels, fresh influencer partnerships, regional campaigns or app-exclusive offers. With stable customer retention, Myntra can enhance loyalty through deeper personalization and more engaging reward programs. To reduce return rate, myntra can offer exchanges, analyze key return reasons, ensure accurate order fulfillment and timely delivery.

<img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/dashboard_screenshot.png" alt="Executive Summary"/>

## Insights Deep-Dive

### Sales Trends and Growth Rates

- Myntra averages ₹17.5 lakhs in sales with 1,250 orders per quarter.
- Q3 2023 was the worst-performing quarter. Sales were reduced by 9%, total orders declined by more than 6% and average order value dropped by almost 3%. However, the immediate quarter saw a strong recovery.
- Across both years, sales peaked in January and November and dipped in February.
- Maharashtra, Gujarat, Uttar Pradesh and Madhya Pradesh contribute 60% of sales and order count, with the Maharashtra alone accounting for 20%.
- 67% of total sales and orders are generated by customers aged 35 and above.
- Night time accounts for 37% of total sales and orders.

<img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/sales_metrics_by_quarter.png" width="725"/>

<p>
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/total_sales_by_month.png" width="31%" height="235"/>
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/order_count_by_month.png" width="31%" height="235"/>
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/aov_by_month.png" width="31%" height="235"/>
</p>
<p>
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/sales_growth_by_month.png" width="31%" height="235"/>
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/order_count_growth_by_month.png" width="31%" height="235"/>
  <img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/aov_growth_by_month.png" width="31%" height="235"/>
</p>

### Product Performance

- All products contribute almost equally to total sales, indicating a balanced product portfolio without significant outliers in performance.
- Some product categories have shown sharp quarter-wise spikes (>20%) or dips (<20%). Jacket sales saw the highest growth at 67.64% in Q1 2024, while shirts experienced the lowest growth with a decline of 35.69% in the same quarter.
- As mentioned earlier, Q3 2023 saw the lowest sales growth. A deeper look at category-wise trends explain this downturn. Several categories such as blazer, hoodie, jacket and jeans saw notable declines during this period. However, not all categories perform poorly — T-shirt recorded a 24.55% increase in sales.
- The overall recovery in Q4 2023 was strongly supported by a great demand in various product categories. Blazers and Jeans rebounded sharply with a 32% increase, while shirts sales rose by 44.38%. Although shorts sales declined by 20.74%.

<img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/sales_growth_by_category_and_quarter.png" width="850"/>

### Customer Growth and Repeat Purchase Trends

- Myntra's new customers consistently decreased from 2023 to 2024, dropping by over 50% from 1187 in Q1 2023 to 495 in Q4 2024, indicating challenges in acquiring new customers.
- The increase in the number of repeat customers and repeat purchase rate suggest a core base of loyal customers who consistently make multiple purchases.
- While the repeat purchase rate steadily increased, the overall customer retention rate remained almost constant over the two-year period. This highlights that customers are returning but not frequently.
- Around 37% of customers have never placed a single order. This shows a significant gap between sign-ups and actual conversions.

<img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/customer_count_and_rate.png" width="700"/>

<img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/repeat_and_retention_rate.png" width="550"/>

### Refund Rate Trends

- Shirts and Sweaters have the maximum return rate, around 11-12%. In Q3 and Q4 2024, shirts have faced the highest two-year return rate of 17%.
- Jacket and Jeans have stabilised return rates with a little bit of fluctuations.
- High return rates (>11%) of Karnataka, Andhra Pradesh, Delhi and Bihar suggest potential issues with product quality, customer dissatisfaction or logistics.
- Female adults have the highest return rate, while male youth have the lowest.

<img src="https://github.com/Anant-Chambiyal/Myntra-Sales-and-Customer-Analytics/blob/main/images_and_visualizations/return_rate_by_customer_demographics.png" width="550"/>

## Recommendations

Sales Growth Strategies

- **Optimize Seasonal Sales Patterns:** Introduce February-specific promotions such as Valentine's Day offers to improve sales during the low period. Boost inventory in January and November to maximize high demand.
- **Leverage High-contributing Markets and Customer Segments:** Run localized campaigns in top-performing states using regional languages and festivals. Personalize product recommendations for customers aged 35 and above. Improve delivery time and post-purchase support to strengthen customer loyalty.

***

Maximize Product Portfolio Balance

- **Maintain Category Balance:** Continue monitoring the performance of all categories to maintain a balanced portfolio. Avoid over-dependency on a single product category to reduce risks and ensure conistent sales from a wide range of products. Take advantage of night-time buying behaviour by scheduling push notifications and targeted ads during this period.

***

Customer Growth and Retention

- **Boost New Customer Aacquisition:** Launch referral and influencer-driven campaigns. Offer first-time incentives such as exclusive deals or discounts. Refine Myntra's messaging to attract new customers.
- **Improve Signup to Conversion Funnel:** Send personalized product suggestions. Offer first-order rewards like cashback or loyalty points. Improve the onboarding experience for better engagement.
- **Increase Customer Purchase Frequency:** Target customers with personalized reengagement campaigns and introduce loyalty tiers with various benefits and rewards. Send personalized recommendations to inactive buyers.

***

Maintain Low Return Rates

- **Sustain Successful Practices:** Continue using high-quality images, accurate product descriptions and fit guides to help customers choose correctly. Ensure strict quality check before dispatch. Regularly monitor customer feedback and return data to catch early trends. Promote low return products as reliable options.

## Assumptions and Caveats

- **Multiple ratings:** 26.74% of records in the `ratings` table represent multiple ratings for a single order. It is assumed that the customer might give another rating, and Myntra's database stores all the previous ratings.
- **Multiple transactions:** 26.32% of records in the `transactions` table represent multiple transactions for a single order. It is considered that the customer have opt for EMI to pay for the corresponding order.
- **Unknown Transaction Mode:** In `transactions` table, 33 records represent `NULL` transaction_mode. For the analysis, these records are kept as it is but there is a possibility that these records represent Cash on Delivery payment method. The Data Engineering team can help validate this lack of data.
- **Refund Records:**
  - Around 1k (50.15%) records of `returns_refund` table show that the order date is later than the return date. For this issue, there are 2 possibilities - the first one is that order date and return date got swapped with each other and the second one simply signifies an incorrect return date. For the analysis, the return date for these records is taken as `NULL`.
  - There are multiple refund records for a single order. Although this is understandable as customer might have applied again for a refund even after the rejection. But in 11 different `order_id`s, it is seen that the rejected return dates are later than the approved return date. Both these issues have to be validated by the Data Engineering team. For the analysis, this issue is kept as it is.
