/* Type of SQL : Oracle */

-- Write a single SQL command to increase all book costs by 6%.  
UPDATE BOOK 
SET BOOK_COST = BOOK_COST * 1.06;


-- Write a query that will display all the Books that were published in 2016.
-- Display the book year, book title, book subject, author last name, 
-- and author first.  Sort the records by book title.  
SELECT BOOK_YEAR, BOOK_TITLE, BOOK_SUBJECT, AU_LNAME, AU_FNAME
from BOOK 
Left join Writes on book.book_num = writes.book_num
Left join author on writes.au_id = author.au_id
where book.book_year = 2016
order by book.book_title


-- Write a query to display the book title, book year, book subject , 
-- and book cost for all books that are either Database or Programming books 
-- and that have a replacement cost that is greater than $50.  Sort the results 
-- in ascending order by Subject then cost.
SELECT BOOK_TITLE, BOOK_YEAR, BOOK_SUBJECT, BOOK_COST
from book
where book_subject = 'Database' or book_subject = 'Programming' 
group by BOOK_TITLE, BOOK_YEAR, BOOK_SUBJECT, BOOK_COST
having book_cost > 50
order by book_subject, book_cost ASC


-- Write a query to show the min, max, and average 
-- replacement cost for all books.
select min(book_cost),max(book_cost),avg(book_cost)
from book

-- Write a query to display the book subject and the number of books 
-- in each subject, order by the subject.
select book_subject, count(book_num)
from book
group by book_subject
order by book_subject


-- Write a query to display the patron type and the number of patrons 
-- in each type, order by the number of patrons in descending order.  
select pat_type, count(pat_id)
from patron
group by pat_type
order by count(pat_id) DESC


-- Write a query to display books that have the word “database” 
-- in the title regardless of how it is capitalized.
select book_title
from book
where UPPER(book_title) like '%DATABASE%';

-- Write a query to display the total number of books.
select count(book_num)
from book;

