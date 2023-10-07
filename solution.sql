WITH
sales_cnt AS (
    SELECT
        s.shop_id,
        s.product_id,
        s.date,
        sd.sales_cnt
    FROM sales AS s
    INNER JOIN shop_dns AS sd
        ON sd.product_id = s.product_id
        AND sd.date = s.date
        AND s.shop_id = 1
    UNION ALL
    SELECT
        s.shop_id,
        s.product_id,
        s.date,
        sm.sales_cnt
    FROM sales AS s
    INNER JOIN shop_mvideo AS sm
        ON sm.product_id = s.product_id
        AND sm.date = s.date
        AND s.shop_id = 2
    UNION ALL
    SELECT
        s.shop_id,
        s.product_id,
        s.date,
        ss.sales_cnt
    FROM sales AS s
    INNER JOIN shop_sitilink AS ss
        ON ss.product_id = s.product_id
        AND ss.date = s.date
        AND s.shop_id = 3
),
sales_by_month AS (
	SELECT
           s.shop_id,
	       s.product_id,
		   TO_CHAR(s.date, 'YYYY-MM') AS period,
	       SUM(s.sales_cnt) AS sales_fact,
	       MAX(s.sales_cnt) AS max_sales_cnt
	FROM sales_cnt AS s
	GROUP BY s.shop_id, s.product_id, TO_CHAR(s.date, 'YYYY-MM')
    ORDER BY s.shop_id, s.product_id, TO_CHAR(s.date, 'YYYY-MM')
)
SELECT
       s.period,
       sh.shop_name,
       pr.product_name,
       s.sales_fact,
       sp.plan_cnt AS sales_plan,
       ROUND(s.sales_fact::DECIMAL / sp.plan_cnt, 2) AS "sf/sp",
       s.sales_fact * pr.price AS income_fact,
       sp.plan_cnt * pr.price AS income_plan,
       ROUND((s.sales_fact * pr.price) / (sp.plan_cnt * pr.price), 2) AS "if/ip",
       ROUND(s.sales_fact / (DATE_PART('days', DATE_TRUNC('month', NOW())
            + '1 MONTH'::INTERVAL
            - '1 DAY'::INTERVAL))::DECIMAL, 2) AS sales_per_day,
       s.max_sales_cnt
FROM sales_by_month AS s
INNER JOIN plan AS sp
    ON sp.shop_id = s.shop_id
    AND sp.product_id = s.product_id
    AND TO_CHAR(sp.plan_date, 'YYYY-MM') = s.period
INNER JOIN products AS pr
    ON pr.product_id = s.product_id
INNER JOIN shops AS sh
    ON sh.shop_id = s.shop_id
ORDER BY s.shop_id, s.product_id, s.period
