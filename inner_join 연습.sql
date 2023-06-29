    SELECT e.lastname, e. firstname, count(distinct c.customername) 'Number of Acquired Customers', 
    count(distinct o.ordernumber) 'Number of Sucessful Sales', 
    sum(quantityordered*priceEach) 'Sales Performance by Employee'
	FROM customers c
	INNER JOIN orders o
	ON o.customernumber = c.customernumber
	INNER JOIN orderdetails od
    on od.ordernumber = o.ordernumber
    INNER JOIN employees e
    on e.employeenumber = c.salesRepEmployeeNumber
    group by e.employeenumber
    order by sum(quantityordered*priceEach) DESC limit 10;