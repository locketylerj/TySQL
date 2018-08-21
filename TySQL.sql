use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name
from actor;

-- 1b. Display the first and last name of each actor in a single column 
-- in upper case letters. Name the column Actor Name.
select first_name  as 'Actor Name'
from actor
union 
select last_name 
from actor;

/* 2a. You need to find the ID number, first name, and last name of an actor, 
of whom you know only the first name, "Joe." What is one query would you use 
to obtain this information?
*/
select * from actor;

select actor_id, first_name, last_name
from actor
where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:

select actor_id, first_name, last_name
from actor 
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order: 
select last_name, first_name
from actor 
where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following 
-- countries: Afghanistan, Bangladesh, and China:
select * from country;

select country_id, country
from country 
where country in ('Afghanistan', 'Bangladesh', 'China');

/* 3a. You want to keep a description of each actor. You don't think you will be 
performing queries on a description, so create a column in the table actor named 
description and use the data type BLOB (Make sure to research the type BLOB, as 
the difference between it and VARCHAR are significant).
*/
alter table actor
add Description blob;

/* 3b. Very quickly you realize that entering descriptions for each actor is too
 much effort. Delete the description column.*/
 
 alter table actor
 drop Description;
  -- 4a. List the last names of actors, as well as how many actors have that last name.
  
  select first_name, last_name, count(*) 
  from actor
  group by last_name;
  
  -- 4b. List last names of actors and the number of actors who have that last name, but 
  -- only for names that are shared by at least two actors
  select * from actor;
  select last_name, count(*)
  from actor
  group by last_name
  having count(*) <= 2;
  
  -- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
  -- Write a query to fix the record.
  
  select first_name, last_name
  from actor
  where first_name = "Groucho";
  
  update actor
  set first_name = "Harpo"
  where first_name = "Groucho" and last_name = "Williams";
  
  -- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the 
  -- correct name after all! In a single query, if the first name of the actor is currently HARPO, 
  -- change it to GROUCHO.
    select first_name, last_name
  from actor
  where first_name = "Harpo";
  set sql_safe_updates = 0
  
  update actor 
  set first_name = "GROUCHO"
  where first_name = "Harpo";
  set sql_safe_updates = 1
  
  -- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
  show create table address;
  
  
  -- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
  -- Use the tables staff and address:
  select * from address;
 
select staff.first_name, staff.last_name, address.address
from staff
inner join address on staff.address_id = address.address_id;

 -- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
 -- Use tables staff and payment. 
 select * from payment;
 
 select staff.first_name, staff.last_name, sum(payment.amount) as 'Total Amount Rung Up'
 from staff
 inner join payment on staff.staff_id = payment.staff_id
 where payment_date like '2005-08%'
 group by first_name, last_name;
 
 -- 6c. List each film and the number of actors who are listed for that film. Use tables 
 -- film_actor and film. Use inner join.
 select * from film;
  select * from film_actor;
  
  select film.title as 'Film Title', count(film_actor.actor_id) as 'Number of Actors'
  from film
  inner join
  film_actor on film.film_id = film_actor.film_id
  group by film.title;
  
  -- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
  select * from inventory;
  select * from film;
-- title from film where title = "Hunchback Impossible"
  select title, (select count(*) from inventory where inventory.film_id = film.film_id) as 'Number of Copies' 
  from film
  where title = "Hunchback Impossible";
  
  -- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
  -- List the customers alphabetically by last name
  select * from customer;
  select * from payment;
  
  select customer.first_name, customer.last_name, sum(payment.amount) as 'Total Paid'
  from customer
  inner join payment on payment.customer_id = customer.customer_id
  group by first_name, last_name
  order by last_name;
  
  -- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended 
  -- consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to
  -- display the titles of movies starting with the letters K and Q whose language is English.
select * from film;
select * from language;

select title
from film 
where title like 'K%' or 'Q%' and language_id = 1;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from film;
select * from film_actor;
select * from actor;

select first_name, last_name
from actor
where actor_id in (
	select actor_id
    from film_actor
    where film_id in (
		select film_id
        from film
        where title = "Alone Trip")
        );
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email 
-- addresses of all Canadian customers. Use joins to retrieve this information. 
use sakila;

select * from customer;
select * from address;
select * from city;
select * from country;
-- name, email and address_id from customer, address_id connects to country through country_id.
select customer.first_name, customer.last_name, customer.email, country.country
from customer
inner join address on address.address_id = customer.address_id
inner join city on city.city_id = address.city_id
inner join country on country.country_id = city.country_id
where country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a 
-- promotion. Identify all movies categorized as family films.

select * from film;
select * from film_category;
select * from category;

select title as "Family Film Titles"
from film 
where film_id in(
	select film_id
    from film_category
    where category_id in (
		select category_id 
        from category
        where name = "Family")
	);
-- 7e. Display the most frequently rented movies in descending order.
-- EER rental_id to inventory_id to film_id tables. 
select * from rental;

select title, count(rental_id) as "Rental Count"
from film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
group by title
order by count(rental_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from store;
select * from customer;
select * from payment;

select store.store_id, sum(payment.amount) as '$ Brought In'
from store
inner join customer on store.store_id = customer.store_id
inner join payment on customer.store_id = payment.customer_id
group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
-- store to address to city to country

select store.store_id, city.city, country.country
from store 
inner join address on store.address_id = address.address_id
inner join city on city.city_id = address.city_id
inner join country on city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you
-- may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category;

select category.name as 'Category Name', sum(payment.amount) as 'Gross Revenue'
from category
inner join film_category on film_category.category_id = category.category_id
inner join inventory on inventory.film_id = film_category.film_id
inner join rental on rental.inventory_id = inventory.inventory_id
inner join payment on payment.rental_id = rental.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres 
-- by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, 
-- you can substitute another query to create a view.
create view TopGenres as (
select category.name as 'Category Name', sum(payment.amount) as 'Gross Revenue'
from category
inner join film_category on film_category.category_id = category.category_id
inner join inventory on inventory.film_id = film_category.film_id
inner join rental on rental.inventory_id = inventory.inventory_id
inner join payment on payment.rental_id = rental.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5);

-- 8b. How would you display the view that you created in 8a?
select * from topgenres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view topgenres;