
-- 3
SELECT  o.empid, o.firstName, o.lastname
FROM HR.Employees o
WHERE o.empid NOT IN (
    SELECT i.empid
    FROM Sales.Orders i 
    WHERE orderdate >= '20160501'
);

-- 4
SELECT DISTINCT o.country
FROM Sales.Customers o
WHERE o.country NOT IN (
    SELECT i.country
    FROM HR.Employees i
);


-- 5
SELECT o.custid, o.orderid, o.orderdate, o.empid
FROM Sales.Orders o 
WHERE o.orderdate =
(
    SELECT MAX(i.orderdate)
    FROM Sales.Orders i 
    WHERE o.custid = i.custid
)

-- 6

SELECT o.custid, o.companyname
FROM Sales.Customers o 
WHERE EXISTS 
(
    SELECT * 
    FROM Sales.Orders AS i1 
    WHERE i1.custid = o.custid
        AND i1.orderdate >= '20150101'
        AND i1.orderdate < '20160101'
)
AND NOT EXISTS 
(
    SELECT * 
    FROM Sales.Orders AS i1 
    WHERE i1.custid = o.custid
        AND i1.orderdate >= '20160101'
        AND i1.orderdate < '20170101'
)


--7

WITH aa AS(
SELECT DISTINCT o.custid
FROM Sales.Orders o 
WHERE o.orderid IN (
        SELECT od.orderid
        FROM Sales.OrderDetails od
        WHERE od.productid = 12
    ) 
), 
bb AS(
    SELECT custid, companyname
    FROM Sales.Customers
)
SELECT bb.custid, companyname FROM bb 
RIGHT JOIN aa
on aa.custid = bb.custid
ORDER BY companyname;


--7 

SELECT custid, companyname
FROM Sales.Customers AS C
WHERE EXISTS
    (SELECT *
    FROM Sales.Orders AS O
    WHERE O.custid = C.custid 
    AND EXISTS 
        (SELECT *
            FROM Sales.OrderDetails AS OD
            WHERE OD.orderid = O.orderid AND OD.ProductID = 12));


-- 8: Running total
WITH aa AS (
    SELECT OD.orderid, OD.qty, o.orderdate, o.custid,
        datefromparts(year(o.orderdate), month(o.orderdate), 1) as ordermonth
    FROM Sales.OrderDetails OD
    LEFT JOIN Sales.Orders O
    on OD.orderid = o.orderid
) 
SELECT 
    custid,
    ordermonth,
    sum(qty) as qty
FROM aa 
GROUP BY custid, ordermonth
ORDER BY custid, ordermonth


--8

SELECT custid, ordermonth, qty, 
    (
        SELECT SUM(O2.qty)
        FROM Sales.CustOrders AS O2
        WHERE O2.custid = O1.custid 
            AND O2.ordermonth <= O1.ordermonth
    ) AS runqty
FROM Sales.CustOrders AS O1
ORDER BY custid, ordermonth;

-- 10

SELECT custid, orderdate, orderid, diff 
FROM 
(
    SELECT 
        custid,
        orderdate,
        orderid,
        lag(orderdate) over (order by custid, orderdate) as lag,
        datediff(day, lag(orderdate) over (partition by custid order by orderdate), orderdate) as diff
    FROM Sales.Orders AS o1

) aa
ORDER BY custid, orderdate;


--10

SELECT custid, orderdate, orderid,
DATEDIFF
(
    day,
    (
        SELECT TOP(1) o2.orderdate
        FROM Sales.Orders AS o2
        WHERE o2.custid = o1.custid
            AND
            (
                o2.orderdate = o1.orderdate 
                AND o2.orderid < o1.orderid
                OR  o2.orderdate < o1.orderdate
            )
        ORDER BY o2.orderdate DESC, o2.orderid DESC
    ), 
    orderdate) AS diff
FROM Sales.Orders AS o1
ORDER BY custid, orderdate, orderid;

















