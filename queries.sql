-- Analytical queries for the airbnbdb data mart (MySQL 8)
-- Run after importing schema_and_data.sql:  mysql -u root -p airbnbdb < queries.sql
USE airbnbdb;

-- ---------------------------------------------------------------
-- Q1. Revenue by country and city (confirmed and completed bookings)
-- ---------------------------------------------------------------
SELECT co.country_name,
       ci.city_name,
       COUNT(b.booking_id)          AS bookings,
       SUM(b.total_price)           AS revenue_eur
FROM Booking b
JOIN Property p  ON p.property_id = b.property_id
JOIN Location l  ON l.location_id = p.location_id
JOIN City ci     ON ci.city_id    = l.city_id
JOIN Country co  ON co.country_id = ci.country_id
WHERE b.status IN ('confirmed', 'completed')
GROUP BY co.country_name, ci.city_name
ORDER BY revenue_eur DESC;

-- ---------------------------------------------------------------
-- Q2. Booking status breakdown and cancellation rate
-- ---------------------------------------------------------------
SELECT status,
       COUNT(*)                                        AS bookings,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS share_pct
FROM Booking
GROUP BY status
ORDER BY bookings DESC;

-- ---------------------------------------------------------------
-- Q3. Top 5 properties by revenue, with nights booked and average nightly rate
-- ---------------------------------------------------------------
SELECT p.title,
       p.property_type,
       SUM(DATEDIFF(b.check_out_date, b.check_in_date))                      AS nights_booked,
       SUM(b.total_price)                                                    AS revenue_eur,
       ROUND(SUM(b.total_price) / SUM(DATEDIFF(b.check_out_date, b.check_in_date)), 2) AS avg_rate_per_night
FROM Booking b
JOIN Property p ON p.property_id = b.property_id
WHERE b.status IN ('confirmed', 'completed')
GROUP BY p.property_id, p.title, p.property_type
ORDER BY revenue_eur DESC
LIMIT 5;

-- ---------------------------------------------------------------
-- Q4. Average rating and number of reviews per property type
-- ---------------------------------------------------------------
SELECT p.property_type,
       COUNT(r.review_id)      AS reviews,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM Review r
JOIN Booking b  ON b.booking_id  = r.booking_id
JOIN Property p ON p.property_id = b.property_id
GROUP BY p.property_type
ORDER BY avg_rating DESC;

-- ---------------------------------------------------------------
-- Q5. Platform economics per booking: what the guest pays (invoice),
--     what the host receives (payout) and what the platform keeps
-- ---------------------------------------------------------------
SELECT b.booking_id,
       b.total_price                                  AS booking_price,
       i.total_amount                                 AS guest_invoice,
       po.amount                                      AS host_payout,
       i.total_amount - po.amount                     AS platform_margin,
       ROUND(100 * (i.total_amount - po.amount) / i.total_amount, 1) AS margin_pct
FROM Booking b
JOIN Invoice i ON i.booking_id  = b.booking_id
JOIN Payout po ON po.booking_id = b.booking_id
WHERE b.status IN ('confirmed', 'completed')
ORDER BY platform_margin DESC
LIMIT 10;

-- ---------------------------------------------------------------
-- Q6. Payment methods: volume, share and failure count
-- ---------------------------------------------------------------
SELECT payment_method,
       COUNT(*)                                           AS payments,
       SUM(amount)                                        AS volume_eur,
       ROUND(100 * SUM(amount) / SUM(SUM(amount)) OVER (), 1) AS volume_share_pct,
       SUM(status = 'failed')                             AS failed
FROM Payment
GROUP BY payment_method
ORDER BY volume_eur DESC;

-- ---------------------------------------------------------------
-- Q7. Monthly revenue by check-in month, with a running total
-- ---------------------------------------------------------------
SELECT DATE_FORMAT(check_in_date, '%Y-%m')                               AS month,
       SUM(total_price)                                                   AS revenue_eur,
       SUM(SUM(total_price)) OVER (ORDER BY DATE_FORMAT(check_in_date, '%Y-%m')) AS running_total_eur
FROM Booking
WHERE status IN ('confirmed', 'completed')
GROUP BY month
ORDER BY month;

-- ---------------------------------------------------------------
-- Q8. Guest ranking: top spenders within each membership level
-- ---------------------------------------------------------------
SELECT *
FROM (
    SELECT g.member_level,
           CONCAT(u.first_name, ' ', u.last_name) AS guest,
           g.total_spent,
           RANK() OVER (PARTITION BY g.member_level ORDER BY g.total_spent DESC) AS rank_in_level
    FROM Guest g
    JOIN User u ON u.user_id = g.user_id
) ranked
WHERE rank_in_level <= 2
ORDER BY FIELD(member_level, 'Platinum', 'Gold', 'Silver', 'Basic'), rank_in_level;

-- ---------------------------------------------------------------
-- Q9. Most common amenities and the average nightly price of properties that offer them
-- ---------------------------------------------------------------
SELECT a.amenity_name,
       COUNT(pa.property_id)          AS properties,
       ROUND(AVG(p.price_per_night), 2) AS avg_price_per_night
FROM Amenity a
JOIN PropertyAmenity pa ON pa.amenity_id = a.amenity_id
JOIN Property p         ON p.property_id = pa.property_id
GROUP BY a.amenity_name
ORDER BY properties DESC, avg_price_per_night DESC;

-- ---------------------------------------------------------------
-- Q10. Search: active properties available on 2026-05-01 for 4+ guests,
--      with city and primary photo
-- ---------------------------------------------------------------
SELECT p.title,
       ci.city_name,
       p.price_per_night + ac.price_modifier AS price_that_night,
       p.max_guests,
       ph.photo_url
FROM Property p
JOIN AvailabilityCalendar ac ON ac.property_id = p.property_id
JOIN Location l              ON l.location_id  = p.location_id
JOIN City ci                 ON ci.city_id     = l.city_id
LEFT JOIN PropertyPhoto ph   ON ph.property_id = p.property_id AND ph.is_primary = 1
WHERE ac.date = '2026-05-01'
  AND ac.is_available = 1
  AND p.is_active = 1
  AND p.max_guests >= 4
ORDER BY price_that_night;

-- ---------------------------------------------------------------
-- Q11. Data-quality check: Booking.host_id is stored for fast lookups.
--      This lists bookings where it no longer matches the property's host.
-- ---------------------------------------------------------------
SELECT b.booking_id,
       b.host_id  AS host_on_booking,
       p.host_id  AS host_of_property,
       p.title
FROM Booking b
JOIN Property p ON p.property_id = b.property_id
WHERE b.host_id <> p.host_id;
