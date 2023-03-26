USE oyo;
SELECT * FROM oyohotels;
SELECT COUNT(DISTINCT(hotel_id)) FROM oyohotels;

/* Distinct cities that have oyo hotels */

SELECT DISTINCT(City) FROM oyohotels;

/* No. of hotels in each city */

SELECT COUNT(Hotel_id) AS No_of_cities,City FROM oyohotels 
GROUP BY City;

/* New column price added.Amount is money paid by customer. Price is actual price of room without discount.*/

ALTER TABLE oyosql 
ADD price FLOAT;
UPDATE oyosql SET price=amount+discount;
SELECT amount,discount,price FROM oyosql;

/* New column for number of nights stayed. */

ALTER TABLE oyosql 
ADD no_of_nights INT;
UPDATE oyosql SET no_of_nights=DATEDIFF(check_out,check_in);
SELECT no_of_nights FROM oyosql;

/* Price per room */
ALTER TABLE oyosql
ADD rate FLOAT;
UPDATE oyosql SET rate=IF(no_of_rooms=1,price/no_of_nights,price/(no_of_nights*no_of_rooms));

SELECT ROUND(AVG(rate),2),city AS avg_rate_by_city FROM oyosql o,oyohotels h
WHERE o.hotel_id=h.hotel_id
GROUP BY city;

/* No. of bookings made in each month */

SELECT MONTH(check_in) AS MONTH,COUNT(booking_id) AS no_of_bookings FROM oyosql 
GROUP BY 1 
ORDER BY 1;

/* How many days prior bookings are made */

SELECT COUNT(*) total_bookings, DATEDIFF(check_in,date_of_booking) AS days_prior FROM oyosql
GROUP BY 2
ORDER BY 2;

/* Gross revenue per city */

CREATE VIEW gross AS
SELECT city,SUM(amount) AS gross_revenue FROM oyosql o, oyohotels h 
WHERE o.hotel_id=h.hotel_id
GROUP BY 1 
ORDER BY 2 DESC;

/* Total gross revenue */

SELECT SUM(gross_revenue) AS total_gross FROM gross;

/* Net revenue per city */

CREATE VIEW net AS
SELECT city,SUM(amount) AS net_revenue FROM oyosql o, oyohotels h 
WHERE o.hotel_id=h.hotel_id AND (o.status='Stayed' OR o.status='No Show')
GROUP BY 1 
ORDER BY 2 DESC;

/* Total net revenue */

SELECT SUM(net_revenue) AS total_net FROM net;

/* Total no. of bookings and Cancellations per city */

SELECT city, COUNT(booking_id) AS total_bookings, SUM(IF(o.status='Cancelled',1,0)) AS cancelled 
FROM oyosql o,oyohotels h 
WHERE o.hotel_id=h.hotel_id
GROUP BY city;

/* No. of bookings where people didnt show */

SELECT city, COUNT(*) AS no_of_times_people_didnot_show from oyosql o,oyohotels h
WHERE o.hotel_id=h.hotel_id AND status='No Show'
GROUP BY city;

/* Adding Discount percentage column */

ALTER TABLE oyosql
ADD discount_percent FLOAT;
UPDATE oyosql SET discount_percent= (discount/price)*100;

/* Average discount per city */

CREATE VIEW discounts AS
SELECT city, ((SUM(discount_percent))/COUNT(booking_id)) AS discount FROM oyosql o,oyohotels h
WHERE o.hotel_id=h.hotel_id
GROUP BY city;

/* Total Discount */

SELECT ROUND(SUM(discount)/COUNT(discount),2) AS Total_Avg_Discount FROM discounts;










