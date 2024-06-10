USE Sakila;
-- 1
SELECT 
    f.title,
    COUNT(i.inventory_id) AS number_of_copies
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
WHERE 
    f.title = 'Hunchback Impossible'
GROUP BY 
    f.title;

-- 2
SELECT 
    title,
    length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film)
ORDER BY 
    length DESC;

-- 3
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name
FROM 
    actor a
WHERE 
    a.actor_id IN (
        SELECT 
            fa.actor_id
        FROM 
            film_actor fa
        JOIN 
            film f ON fa.film_id = f.film_id
        WHERE 
            f.title = 'Alone Trip'
    );

-- Bonus
-- 4
SELECT 
    f.film_id,
    f.title
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family'
ORDER BY 
    f.title;

-- 5
-- Joins
SELECT 
    c.first_name,
    c.last_name,
    c.email
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id
WHERE 
    co.country = 'Canada'
ORDER BY 
    c.last_name, c.first_name;

-- Subqueries
SELECT 
    c.first_name,
    c.last_name,
    c.email
FROM 
    customer c
WHERE 
    c.address_id IN (
        SELECT 
            a.address_id
        FROM 
            address a
        WHERE 
            a.city_id IN (
                SELECT 
                    ci.city_id
                FROM 
                    city ci
                WHERE 
                    ci.country_id = (
                        SELECT 
                            co.country_id
                        FROM 
                            country co
                        WHERE 
                            co.country = 'Canada'
                    )
            )
    )
ORDER BY 
    c.last_name, c.first_name;

-- 6
SELECT 
    a.actor_id, 
    a.first_name, 
    a.last_name, 
    COUNT(fa.film_id) AS film_count
FROM 
    actor a
JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
GROUP BY 
    a.actor_id, a.first_name, a.last_name
ORDER BY 
    film_count DESC
LIMIT 1;

SELECT 
    f.film_id, 
    f.title
FROM 
    film f
JOIN 
    film_actor fa ON f.film_id = fa.film_id
WHERE 
    fa.actor_id = (
        SELECT 
            a.actor_id
        FROM 
            actor a
        JOIN 
            film_actor fa ON a.actor_id = fa.actor_id
        GROUP BY 
            a.actor_id
        ORDER BY 
            COUNT(fa.film_id) DESC
        LIMIT 1
    )
ORDER BY 
    f.title;

-- 7
SELECT 
    p.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_payments
FROM 
    payment p
JOIN 
    customer c ON p.customer_id = c.customer_id
GROUP BY 
    p.customer_id, c.first_name, c.last_name
ORDER BY 
    total_payments DESC
LIMIT 1;

SELECT 
    f.film_id,
    f.title
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.customer_id = (
        SELECT 
            p.customer_id
        FROM 
            payment p
        GROUP BY 
            p.customer_id
        ORDER BY 
            SUM(p.amount) DESC
        LIMIT 1
    )
ORDER BY 
    f.title;

-- 8
SELECT 
    p.customer_id,
    SUM(p.amount) AS total_amount_spent
FROM 
    payment p
GROUP BY 
    p.customer_id
HAVING 
    SUM(p.amount) > (
        SELECT 
            AVG(total_amount)
        FROM (
            SELECT 
                SUM(amount) AS total_amount
            FROM 
                payment
            GROUP BY 
                customer_id
        ) AS subquery
    )
ORDER BY 
    total_amount_spent DESC;
