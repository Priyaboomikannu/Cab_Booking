create database cab_booking;
use cab_booking;

-- SELECT + WHERE

-- 1.	Select all rides where fare is greater than 200
select * from ride;
select fare from ride where fare>200;
-- 2.	Retrieve users who signed up after '2023-01-01'
select * from user;
select signup_date from user where signup_date>'2023-01-01';
-- 3.	Select drivers with rating greater than 4.5
select * from driver;
select rating from driver where rating>4.5;
-- 4.	Get rides where distance is between 5 and 15 km
select distance_km from ride where distance_km between 5 and 15;
-- 5.	Retrieve rides where status = 'completed' and fare > 100
select status,fare from ride where status='completed'and fare>100;
-- 6.	Select users from Chennai or Bangalore
select city from user where city='Chennai' or city='Bangalore';
-- 7.	Get drivers whose name starts with 'A'
select driver_name from driver where driver_name like 'A%';
-- 8.	Select rides where payment method is 'UPI' (using JOIN)
select * from payment;
select ride_id,payment_method from payment where payment_method='UPI';
-- 9.	Retrieve rides where fare is not equal to 0
select fare from ride where fare !=0;
-- 10.	Select users who signed up in the month of January
select signup_date from user where month(signup_date)='1';

-- SELECT + WHERE + JOINS

-- 11.	Select user name and ride fare where fare > 200
select user.user_name,ride.fare from ride join user on ride.user_id=user.user_id where fare>200;
-- 12.	Get driver name and ride distance where distance > 10
select driver.driver_name,ride.distance_km from driver join ride on driver.driver_id=ride.driver_id where distance_km>10;
-- 13.	Retrieve rides where payment status = 'failed' with user name
select user.user_name,payment.payment_status from user join payment on user_id=payment_id where payment_status='failed';
-- 14.	Select users who booked rides (based on driver city different from user city)
select user.user_name,ride.ride_id from user join ride on user.user_id=ride.user_id join driver on ride.driver_id=driver.driver_id where user.city!=driver.city;
-- 15.	Get completed rides with user and driver details
select ride.status,ride.fare,user.user_name,driver.driver_name,ride.ride_id from ride join user on ride.user_id=user.user_id join driver on ride.driver_id=driver.driver_id where ride.status='completed'; 
-- 16.	Select rides where driver rating > 4.5
select driver.driver_name,driver.rating from ride join driver where rating>4.5;
-- 17.	Retrieve rides where payment method = 'Cash'
select payment.payment_method,payment.payment_id,payment.ride_id,payment.payment_status from payment join ride where payment_method='cash';
-- 18.	Select rides where both user and driver belong to same city
select user.city,driver.driver_name,user.user_name,ride.ride_id from ride join user on ride.user_id=user.user_id join driver on driver.driver_id=ride.driver_id where user.city=driver.city;
-- 19.	Get rides where payment failed but ride is completed
select payment.payment_id,payment.payment_status,ride.ride_id,ride.status from payment join ride on payment.ride_id=ride.ride_id where payment.payment_status='failed' and ride.status='completed';
-- 20.	Select users who have taken rides with fare > 500
select user.user_id,ride.fare,user.user_name from user join ride on ride.user_id=user.user_id where fare>500;

-- SELECT + WHERE + GROUP BY

-- 21.	Find total rides per user where total rides > 2
select count(ride_id),user_name from ride join user on user.user_id=ride.user_id group by user_name having count(ride_id)>2;
-- 22.	Get total earnings per driver where earnings > 1000
select sum(fare),driver_id from ride group by driver_id having sum(fare)>1000;
-- 23.	Calculate average fare per user city where avg fare > 150
select avg(fare),user.city from ride join user on user.user_id=ride.user_id group by user.city having avg(fare)>150;
-- 24.	Count rides per day where rides > 5
select count(ride_id),ride_date from ride group by ride_date having count(ride_id)>5;
-- 25.	Find users with total distance traveled > 50 km
select user_id,sum(distance_km) from ride group by user_id having sum(distance_km)>50;
-- 26.	Get drivers with more than 3 completed rides 
select driver_id,count(status) from ride where status='completed' group by driver_id having count(status)>3;
-- 27.	Find payment methods used more than 2 times
select payment_id,count(payment_method) from payment group by payment_id having count(payment_id)>2;
-- 28.	Get cities with more than 10 users
select city,sum(user_id) from user group by city having sum(user_id)>10;
-- 29.	Find drivers with rating > 4.2 (instead of avg)
select driver_id,avg(rating) from driver where rating>4.2 group by driver_id;
-- 30.	Count cancelled rides per user where count > 1
select user_id,count(status) from ride where status='cancelled' group by user_id having count(status)>1; 

-- SELECT + ORDER BY + LIMIT

-- 31.	Select top 5 rides with highest fare
select * from ride order by fare DESC limit 5; 
-- 32.	Get lowest 3 distance rides
select * from ride order by distance_km asc limit 3;
-- 33.	Retrieve top 5 users based on total spending
select user_id,sum(fare) from ride group by user_id order by sum(fare) desc limit 5;
-- 34.	Select top 3 drivers with highest rating
select * from driver order by rating desc limit 3;
-- 35.	Get 2nd highest fare ride using LIMIT OFFSET
select * from ride order by fare desc limit 1 offset 1;

-- SELECT + SUBQUERIES

-- 36.	Select users whose total spending is greater than average spending
select user_id,sum(fare) as total_spending from ride group by user_id having sum(fare)>(select avg(fare) from ride);
-- 37.	Get drivers earning more than average driver earning
select driver_id,sum(fare) as driver_earning from ride group by driver_id having sum(fare)>(select avg(fare) from ride);
-- 38.	Retrieve rides where fare > average fare
select * from ride where fare>(select avg(fare) from ride);
-- 39.	Select users who have no rides
select * from user where user_id not in (select user_id from ride); 
-- 40.	Get drivers who have no completed rides
select * from driver where driver_id not in  (select driver_id from ride where status='complete');
-- 41.	Select rides with maximum fare
select * from ride where fare = (select max(fare) from ride);
-- 42.	Retrieve users with highest number of rides
select u.* ,r.ride_id from user as u join ride as r on r.user_id=u.user_id where ride_id = (select ride_id from ride group by ride_id order by count(ride_id) limit 1);
-- 43.	Select second highest earning driver
select * from driver where driver_id=(select driver_id from ride group by driver_id order by sum(fare) limit 1 offset 1);
-- 44.	Get rides where fare > user’s average fare
select * from ride where fare > (select avg(fare) from ride);
-- 45.	Select users who made only one ride
select * from ride where user_id in (select user_id from ride group by user_id having count(*)=1);

--  UPDATE / DELETE

-- 46.	Update ride status to 'completed' where payment status = 'success'
update ride,payment set ride.status='completed'  where payment.payment_status='success';
-- 47.	Delete rides where status = 'cancelled' and fare = 0
delete from ride where status='cancelled' and fare=0;
-- 48.	Update driver rating where rating < 3
update driver set rating=3 where rating<3;

-- STORED PROCEDURE

-- 49.	Create a stored procedure to select rides of a user where fare > given amount
delimiter $$
create procedure get_ride(in amount int)
begin
	select * from ride where fare > amount;
end $$
call get_ride(200);
delimiter $$
-- 50.	Create a stored procedure to get drivers where rating > given value
create procedure get_drivers(in given_value decimal(2,1))
begin
	select * from driver where rating > given_value;
end $$
call get_drivers(4.2);

	








