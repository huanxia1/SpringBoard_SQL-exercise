/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT facid, name
FROM Facilities
WHERE membercost >0

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( membercost ) 
FROM Facilities
WHERE membercost =0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT  facid,  name ,  membercost ,  monthlymaintenance 
FROM  Facilities
WHERE (membercost / monthlymaintenance) < 0.2 AND membercost >0

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * 
FROM Facilities 
WHERE facid = 1 or facid=5


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, 
CASE WHEN monthlymaintenance >100
THEN  'expensive'
WHEN monthlymaintenance <100
THEN  'cheap'
END AS  'Price_Label'
FROM Facilities


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT * 
FROM  Members 
ORDER BY  Members.joindate DESC 


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT Facilities.name, 
CONCAT( Members.surname,  ',', Members.firstname ) AS Membername
FROM Bookings
LEFT JOIN Members ON Bookings.memid = Members.memid
LEFT JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Bookings.facid =1 OR Bookings.facid =0
ORDER BY Membername



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT DISTINCT Facilities.name, CONCAT( Members.surname,  ',', Members.firstname ) AS Membername, 
CASE WHEN Bookings.memid >0
THEN Bookings.slots * Facilities.membercost *2
WHEN Bookings.memid =0
THEN Bookings.slots * Facilities.guestcost *2
END AS Cost
FROM Bookings
LEFT JOIN Members ON Bookings.memid = Members.memid
LEFT JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Bookings.starttime between '2012-09-14' and '2012-09-15'
HAVING cost >30
ORDER BY cost DESC 


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT sub.* 
from (SELECT DISTINCT Facilities.name, CONCAT( Members.surname,  ',', Members.firstname ) AS Membername, 
CASE WHEN Bookings.memid >0
THEN Bookings.slots * Facilities.membercost *2
WHEN Bookings.memid =0
THEN Bookings.slots * Facilities.guestcost *2
END AS Cost
FROM Bookings
LEFT JOIN Members ON Bookings.memid = Members.memid
LEFT JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Bookings.starttime between '2012-09-14' and '2012-09-15') sub
HAVING sub.cost >30
ORDER BY sub.cost DESC 


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

Select name, sum(Revenue) as Total_Revenue 

from ( SELECT Bookings.*, Facilities.name,
CASE WHEN Bookings.memid >0
THEN Bookings.slots * Facilities.membercost *2
WHEN Bookings.memid =0
THEN Bookings.slots * Facilities.guestcost *2
END AS Revenue
FROM Bookings
LEFT JOIN Members ON Bookings.memid = Members.memid
LEFT JOIN Facilities ON Bookings.facid = Facilities.facid) sub
group by name
having Total_Revenue<1000
Order by Total_Revenue DESC
