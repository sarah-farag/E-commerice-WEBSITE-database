create proc customerRegister
@username varchar(20),@first_name varchar(20), @last_name varchar(20),@password varchar(20),@email varchar(50)
AS
INSERT INTO Users
values(@username,@first_name,@last_name,@password ,@email)
INSERT INTO Customer
values(@username,0)

---------------------------------------------------------------------------------------------
GO

create proc  vendorRegister
@username varchar(20),@first_name varchar(20), @last_name varchar(20),@password varchar(20),@email varchar(50),
@company_name varchar(20), @bank_acc_no varchar(20)
AS
INSERT INTO Users
values(@username,@first_name,@last_name,@password ,@email)
INSERT INTO Vendor(username,activated,company_name,bank_acc_no)
values(@username,0,@company_name,@bank_acc_no)
 
 ---------------------------------------------------------------------------------------------
GO
create proc userLogin 
@username varchar(20), @password varchar(20),
@success bit output, @type int output 
AS
BEGIN
if (Exists (SELECT * FROM Users u where  u.username=@username AND u.password=@password))
BEGIN
set @success=1;
if (Exists (SELECT * FROM Customer c where c.username=@username))
BEGIN
set @type=0
END
else if(Exists (SELECT * FROM Vendor v where v.username=@username ))
BEGIN
set @type=1
END
else if(Exists (SELECT * FROM Admin a where a.username=@username ))
BEGIN
set @type=2
END
else
BEGIN
set @type=3
END
END
ELSE
BEGIN
set @success=0
set @type=-1
END

END
----------------------------------------------------------------------------------
GO
CREATE PROC addMobile 
@username varchar(20), @mobile_number varchar(20)
AS
INSERT INTO User_mobile_numbers
values(@mobile_number,@username)
--------------------------------------------------------------------------------------
GO
CREATE PROC addAddress
@username varchar(20), @address varchar(100)
AS
INSERT INTO User_Addresses
values(@address,@username)

------------------------------------------------------------------------------------------
CREATE PROC showProducts
AS
SELECT product_name,product_description,price,final_price,color FROM PRODUCT
where available=1
---------------------------------------------------------------------------------------
CREATE PROC ShowProductsbyPrice
AS
SELECT serial_no,product_name,product_description,price,color FROM PRODUCT  where available=1 ORDER BY final_price-----------------------------------------------------------------------------------------------------------
GO
CREATE PROC searchbyname
@text varchar(20)
AS
select product_name,product_description,price,final_price,color FROM Product P WHERE  p.product_name  like '%'+@text+'%' AND available=1 

---------------------------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROC AddQuestion
@serial int, @customer varchar(20), @Question varchar(50)
AS
INSERT INTO Customer_Question_Product
values(@serial,@Question,null,@customer)
--------------------------------------------------------------------------------------------------------------------------------------------
GO 
CREATE PROC addToCart
@customername varchar(20), @serial int
AS
Insert INTO CustomerAddstoCartProduct
values(@serial,@customername)

-------------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROC removefromCart
@customername varchar(20), @serial int
AS
DELETE FROM  CustomerAddstoCartProduct 
WHERE(CustomerAddstoCartProduct.serial_no=@serial AND CustomerAddstoCartProduct.customer_name=@customername);
-----------------------------------------------------------------------------------------------------------------------------
GO 
CREATE PROC createWishlist
@customername varchar(20), @name varchar(20)
AS
INSERT INTO Wishlist 
values(@customername,@name);
---------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROC AddtoWishlist
@customername varchar(20), @wishlistname varchar(20), @serial int
AS
Insert INTO Wishlist_Product
values(@customername,@wishlistname,@serial);
---------------------------------------------------------------------------------
GO
CREATE PROC removefromWishlist
@customername varchar(20), @wishlistname varchar(20), @serial int
AS
DELETE FROM Wishlist_Product  

WHERE Wishlist_Product .username=@customername AND Wishlist_Product.serial_no =@serial AND Wishlist_Product.wish_name=@wishlistname
----------------------------------------------------------------------------------------------------------------------------------------

GO
CREATE PROC showWishlistProduct
@customername varchar(20), @name varchar(20)
AS
SELECT P.product_name,p.product_description,p.price,p.final_price,p.color FROM 
Wishlist_Product WP , PRODUCT P 
WHERE WP.serial_no=P.serial_no AND WP.username=@customername AND WP.wish_name=@name

----------------------------------------------------------------------------------------------------------------------------------------
GO 
CREATE PROC viewMyCart
@customer varchar(20)
AS
SELECT P.product_name,P.product_description,P.price,P.final_price,P.color FROM 
CustomerAddstoCartProduct CP , PRODUCT P 
WHERE CP.serial_no=P.serial_no AND CP.customer_name=@customer 
------------------------------------------------------------------------------------------------------------------------------------------

GO 
CREATE PROC calculatepriceOrder
@customer varchar(20) ,@sum decimal(10,2) OUTPUT
AS
SELECT @sum=sum(P.final_price) FROM 
CustomerAddstoCartProduct CP , PRODUCT P 
WHERE CP.serial_no=P.serial_no AND CP.customer_name=@customer AND p.available=1

-----------------------------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROC productsinorder
@customername varchar(20), @orderID int
AS 
UPDATE product 
SET customer_order_id=@orderID,customer_username=@customername,available=0
WHERE product.serial_no IN (
select p.serial_no 
from CustomerAddstoCartProduct cp ,Product P
where cp.customer_name= @customername AND p.serial_no=cp.serial_no and p.available=1)

DELETE FROM CustomerAddstoCartProduct
where CustomerAddstoCartProduct.customer_name<>@customername AND (CustomerAddstoCartProduct.serial_no IN (
select p.serial_no 
from CustomerAddstoCartProduct cp ,Product P
where cp.customer_name= @customername AND p.serial_no=cp.serial_no))
-------------------------------------------------------------------------------------------------------------

GO 
CREATE PROC emptyCart 
@customername varchar(20)
AS
DELETE FROM CustomerAddstoCartProduct  
WHERE CustomerAddstoCartProduct.customer_name=@customername 
---------------------------------------------------------
CREATE PROC makeOrder
@customername varchar(20),@order_number int output,@total_amount decimal(10,2) output
AS
DECLARE @finalp DECIMAL(10,2)
EXEC calculatepriceOrder @customername,@finalp output
if(@finalp is not null)
begin
INSERT INTO Orders (order_date,total_amount,customer_name)
values(CURRENT_TIMESTAMP,@finalp,@customername)
declare @orderid INT
select @orderid=max(order_no) From Orders
EXEC productsinorder @customername,@orderid
EXEC emptyCart @customername
update Orders
set orders.Gift_Card_code_used=Admin_Customer_Giftcard.code from orders  INNER JOIN Admin_Customer_Giftcard On Orders.customer_name=Admin_Customer_Giftcard.customer_name AND Admin_Customer_Giftcard.customer_name=@customername
where order_no=(select max(order_no) from orders)
select @total_amount= (select total_amount from Orders where Orders.order_no=(select max(order_no) From Orders));
select @order_number=max(order_no) From Orders;
print @total_amount
end
----------------------------------------------------------------------------------------------------------------------
--HELPER METHOD CHECK POINTS IN GIFT CARD
GO 
CREATE PROC checkGiftCard 
@orderid int , @ok bit output
AS
DECLARE @ex_date DATETIME
SET @ex_date=(SELECT g.expiry_date from Orders o,Customer c, Giftcard g where o.order_no=@orderid AND o.customer_name =c.username AND c.username=g.username)

if(@ex_date>=CURRENT_TIMESTAMP)
SET @ok=1
ELSE
SET @ok=0

-------------------------------------------------
GO
CREATE PROC cancelOrder --- when are the points not valid ??? if points in gift card is experied 
@orderid INT
AS 
begin

if(((select O.order_status from orders o where o.order_no =@orderid )='not processed' )OR(select O.order_status from orders o where o.order_no =@orderid )='in process'  )
begin
DECLARE @ok2 bit
EXEC checkGiftCard @orderid , @ok2 output
if (@ok2=1)
begin
if ((select orders.payment_type from orders where orders.order_no=@orderid)='cash' )
begin
DECLARE @return_points int
SET @return_points =(select (o.total_amount -(o.cash_amount))from  orders o where o.order_no=@orderid)

DECLARE @re int 
set @re= (select g.remaining_points from Admin_Customer_Giftcard g where g.code=(select o.Gift_Card_code_used from orders o where o.order_no=@orderid))

update Admin_Customer_Giftcard
set Admin_Customer_Giftcard.remaining_points = @re+(select (o.total_amount -(o.cash_amount))from  orders o where o.order_no=@orderid)
where Admin_Customer_Giftcard.code=(select o.Gift_Card_code_used from orders o where o.order_no=@orderid)and 
Admin_Customer_Giftcard.customer_name=(select o.customer_name from orders o where o.order_no=@orderid)

update Customer 
SET Customer.points=Customer.points+@return_points
where Customer.username=(select o.customer_name from Orders o where @orderid =o.order_no)
end 
update Product
set Product.customer_order_id=null,Product.customer_username=null,Product.available=1
where Product.serial_no in (select p.serial_no from orders o ,Product p where o.order_no=@orderid and p.customer_order_id=o.order_no)

DELETE FROM Orders
where Orders.order_no=@orderid AND (Orders.order_status='not processed' OR Orders.order_status='in process' )
end
else
begin
DECLARE @return_points2 int
SET @return_points2 =(select (o.total_amount -(o.credit_amount))from  orders o where o.order_no=@orderid)

DECLARE @re2 int 
set @re2= (select g.remaining_points from Admin_Customer_Giftcard g where g.code=(select o.Gift_Card_code_used from orders o where o.order_no=@orderid))

update Admin_Customer_Giftcard
set Admin_Customer_Giftcard.remaining_points = @re2+(select (o.total_amount -(o.credit_amount))from  orders o where o.order_no=@orderid)
where Admin_Customer_Giftcard.code=(select o.Gift_Card_code_used from orders o where o.order_no=@orderid)and 
Admin_Customer_Giftcard.customer_name=(select o.customer_name from orders o where o.order_no=@orderid)
update Customer 
SET Customer.points=Customer.points+@return_points
where Customer.username=(select o.customer_name from Orders o where @orderid =o.order_no)
end 
update Product
set Product.customer_order_id=null,Product.customer_username=null,Product.available=1
where Product.serial_no in (select p.serial_no from orders o ,Product p where o.order_no=@orderid and p.customer_order_id=o.order_no)

DELETE FROM Orders
where Orders.order_no=@orderid AND (Orders.order_status='not processed' OR Orders.order_status='in process' )
end
end

 ----------------------------------------------------------


GO

create proc returnProduct
@order_id int ,@serial_no int
as

declare @total_amount decimal(10,2)
declare @cash_amount decimal(10,2)
declare @credit_amount  decimal(10,2)

set @total_amount=(select o.total_amount from orders o where o.order_no=@order_id
)
set @cash_amount=(select o.cash_amount from orders o where o.order_no=@order_id
)
set @credit_amount=(select o.credit_amount from orders o where o.order_no=@order_id
)

if(@cash_amount=null) set @cash_amount=0
if(@credit_amount=null) set @credit_amount=0
if (@total_amount<>(@cash_amount+@credit_amount)) -----with gift card points 
begin
if((select g.expiry_date from orders o , Giftcard g where o.Gift_Card_code_used=g.code and o.order_no=@order_id)>CURRENT_TIMESTAMP)
begin

DECLARE @re int 
set @re= (select g.remaining_points from Admin_Customer_Giftcard g where g.code=(select o.Gift_Card_code_used from orders o where o.order_no=@order_id))

update Admin_Customer_Giftcard
set Admin_Customer_Giftcard.remaining_points = @re +(@total_amount-(@cash_amount+@credit_amount))
where( Admin_Customer_Giftcard.code=(select o.Gift_Card_code_used from orders o where o.order_no=@order_id))and 
(Admin_Customer_Giftcard.customer_name=(select o.customer_name from orders o where o.order_no=@order_id))


update Customer
set Customer.points=Customer.points+(@total_amount-(@cash_amount+@credit_amount))
where Customer.username=(select o.customer_name from orders o where o.order_no=@order_id)

end
end
--------------------generally with three cases
declare @final_price decimal(10,2)
set  @final_price= (select p.final_price  from product p where p.serial_no=@serial_no)
update orders
set orders.total_amount = orders.total_amount - @final_price
where orders.order_no=@order_id
update product
set product.customer_order_id=null,product.customer_username=null,product.available=1
where product.serial_no=@serial_no


--------------------------------------------------------------------------------
GO
CREATE PROC ShowproductsIbought
@customername varchar(20)
AS
SELECT p.serial_no,p.product_name,p.category,p.product_description,p.price,p.final_price,p.color
FROM Product p , orders o
WHERE p.customer_order_id=o.order_no AND p.customer_username=@customername and p.available=0
-------------------------------------------------------------
--asuming that every customer that bought the product will rate 
GO
CREATE PROC rate
@serialno int, @rate int , @customername varchar(20)
AS
UPDATE Product 
set product.rate=@rate 
where  product.serial_no=@serialno AND product.customer_username=@customername  

--------------------------------------------
CREATE PROC SpecifyAmount
@customername varchar(20), @orderID int, @cash decimal(10,2), @credit decimal(10,2)
AS
 update orders 
 set orders.cash_amount=@cash ,orders.credit_amount=@credit
 where orders.order_no=@orderID


 

 -----------------------------------------
 GO
 CREATE PROC AddCreditCard
@creditcardnumber varchar(20), @expirydate datetime , @cvv varchar(4), @customername varchar(20)
AS
INSERT INTO Credit_Card
values(@creditcardnumber,@expirydate,@cvv)


insert into Customer_CreditCard
values(@customername,@creditcardnumber)
-------------------------------------------------
GO
CREATE PROC ChooseCreditCard
@creditcard varchar(20), @orderid int
AS
UPDATE Orders
set Orders.creditCard_number=@creditcard
where orders.order_no=@orderid
------------------------------------------

--------------------------------------
GO
CREATE PROC vewDeliveryTypes
AS
SELECT Type,time_duration,fees
FROM Delivery
----------------------------------
--assuming the deliveryID means choosing the delivery type
GO
Create proc specifydeliverytype
@orderID int, @deliveryID int
AS
-- remaing days = todaysdate -(orderdate+duration)
update orders
set orders.delivery_id=@deliveryID
where Orders.order_no=@orderID
update Orders
set orders.remaining_days=(SELECT DATEDIFF(DAY,CURRENT_TIMESTAMP,(SELECT DATEADD(DAY,(SELECT d.time_duration  from Delivery d where d.id=@deliveryID), orders.order_date )))) --if negative values ,, switch date1 date2 )
where Orders.order_no=@orderID

update Orders
set orders.total_amount=orders.total_amount+(SELECT d.fees  from Delivery d where d.id=@deliveryID)
where Orders.order_no=@orderID
------------------------------------------

GO
CREATE PROC trackRemainingDays
@orderid int, @customername varchar(20) , @days INT OUTPUT 
AS 
update Orders
set orders.time_limit=(SELECT DATEADD(DAY,(SELECT d.time_duration  from Delivery d ,orders o where o.delivery_id=d.id and o.order_no=@orderid ), orders.order_date))


--update Orders
--set orders.time_limit=(SELECT DATEADD(DAY,(SELECT d.time_duration  from Delivery d ,orders o where o.delivery_id=d.id and o.order_no=@orderid ), orders.order_date))
update orders
set orders.remaining_days =(DATEDIFF(DAY,CURRENT_TIMESTAMP,(SELECT orders.time_limit  from orders  where orders.order_no=@orderid)))
WHERE (Orders.order_no=@orderid AND Orders.customer_name=@customername)

SELECT @days=o.remaining_days
FROM Orders o
where o.order_no=@orderid


--------------------------f------------------
GO
CREATE PROC recommmend
@customername varchar(20)

AS
--DECLARE @customername varchar(20)='@customername'

select top 3 psecond.serial_no into tmp
from Wishlist_Product wpsecond INNER JOIN Product psecond on psecond.serial_no=wpsecond.serial_no 

where psecond.category IN 

(select top 3 category  AS X
from product pfirst INNER JOIN CustomerAddstoCartProduct capfirst ON pfirst.serial_no=capfirst.serial_no  AND capfirst.customer_name=@customername
group by category 
order by count(*) desc )

group by psecond.serial_no 
order by count (*) DESC

--selecing a coulmn from first 3 products 


--DECLARE @customer varchar(20) ='@customername'
 select top 3 pfourth.serial_no  into tmp2 from 
product pfourth inner join Wishlist_Product wpfourth on pfourth.serial_no=wpfourth.serial_no where wpfourth.username in
(
select top 3 cthird.customer_name
from CustomerAddstoCartProduct  cthird inner join Product pthird
on  cthird.serial_no= pthird.serial_no 
where pthird.serial_no in (select p1third.serial_no from CustomerAddstoCartProduct  c1third inner join Product p1third
on  c1third.serial_no= p1third.serial_no
where c1third.customer_name=@customername and cthird.customer_name<>@customername)
group by cthird.customer_name
order by COUNT(*) desc
)


group by pfourth.serial_no
order by count(*) desc


select serial_no from tmp 
union all 
select serial_no from tmp2

drop table tmp 
drop table tmp2

------------------------------------------------
GO 
create proc postProduct
@vendorUsername varchar(20),@product_name varchar(20),@category varchar(20), @product_description text , @price decimal(10,2), @color varchar(20)
as
insert into Product
values(@product_name,@category,@product_description,@price,@price,@color,1,null,@vendorUsername,null,null)
----------------------------------------
go
CREATE PROC vendorviewProducts
@vendorname varchar(20)
as
select * from  product p
where p.vendor_username=@vendorname

------------------------------------------
go 
create proc EditProduct
@vendorname varchar(20), @serialnumber int, @product_name varchar(20) ,@category varchar(20),@product_description text , @price decimal(10,2), @color varchar(20)
as
if ((select p.vendor_username from Product p where p.serial_no=@serialnumber)=@vendorname)
begin
          update Product 
		  set product.product_name =@product_name, product.category=@category,product.product_description=@product_description,product.price=@price,product.color=@color
		  where Product.serial_no=@serialnumber
end
else
print 'its not ur product'
----------------------------------------
go
create proc deleteProduct
@vendorname varchar(20), @serialnumber int
as
if ((select p.vendor_username from Product p where p.serial_no=@serialnumber)=@vendorname)
begin
          delete from product 
		  where Product.serial_no=@serialnumber
end
else
print 'its not ur product'
-------------------------------------------------------
go
create proc viewQuestions
@vendorname varchar(20)
as 
select cqp.serial_no,cqp.customer_name,cqp.question,cqp.answer
from Product p , Customer_Question_Product  cqp where  p.vendor_username=@vendorname and cqp.serial_no=p.serial_no

---------------------------------------------------------------------------------------

go
create proc  answerQuestions
@vendorname varchar(20), @serialno int, @customername varchar(20), @answer text
as
if ((select p.vendor_username from Product p where p.serial_no=@serialno)=@vendorname)
begin
update Customer_Question_Product
set  Customer_Question_Product.answer=@answer
where Customer_Question_Product.serial_no=@serialno and Customer_Question_Product.customer_name=@customername
end 
else 
print 'its not ur product'

-----------------------------------------------
go
create proc addOffer
@offeramount int, @expiry_date datetime
 as
 insert into offer values(@offeramount,@expiry_date)
 -------------------------------------------------
 go
 create proc checkOfferonProduct
 @serial int,@activeoffer bit output
 as
 if(exists(select op.serial_no from offersOnProduct op where op.serial_no=@serial))
set @activeoffer=1
else
set @activeoffer=0
--------------------------------------
go
create proc checkandremoveExpiredoffer
@offerid int
as
if((select o.expiry_date from offer o where o.offer_id=@offerid)<CURRENT_TIMESTAMP )
begin
delete from offer where offer.offer_id=@offerid

 update product
   set product.final_price =Product.price 
   where Product.serial_no in(
   select product.serial_no from offersOnProduct , Product where Product.serial_no=offersOnProduct.serial_no AND offersOnProduct.offer_id=@offerid)

delete from offersOnProduct where offersOnProduct.offer_id=@offerid


end

-------------------------------------------------------------

go
create proc applyOffer
@vendorname varchar(20), @offerid int, @serial int
as
begin
if ((select p.vendor_username from Product p where p.serial_no=@serial)=@vendorname)
begin
if(exists (select offer.offer_id from  offer where offer.offer_id=@offerid))
begin 
declare @activeoffer bit 
exec checkOfferonProduct @serial , @activeoffer output
if (@activeoffer=0)
   begin 
   insert  into offersOnProduct values(@offerid,@serial)
   update product
   set product.final_price =Product.price-(Product.price*((select o.offer_amount from offer o where o.offer_id=@offerid)/100))
   where Product.serial_no=@serial
   end
  ------------
else -- it has an existing offer  (  i will check if it's expired if so  i will add the new one , else i will leave the old one) 
begin 
DECLARE @offer INT
  select @offer=onp.offer_id from offersOnProduct  onp where onp.serial_no=@serial

  EXEC checkandremoveExpiredoffer @offer --the existing offer is not expired 
   if(exists (select offer.offer_id from  offer where offer.offer_id=@offerid))

   print 'there is an offer on this product'
   ---------------------
   else 
   begin 
   insert  into offersOnProduct values(@offerid,@serial)
   update product
   set product.final_price =Product.price-(Product.price*((select o.offer_amount from offer o where o.offer_id=@offerid)/100))
     where Product.serial_no=@serial

   end
   -------------------
end
end 
end
else
begin
print 'it is not ur product'
end
end
  -------------
GO

create proc activateVendors
@admin_username varchar(20),@vendor_username varchar(20)
As
update vendor
set vendor.activated=1,vendor.admin_username=@admin_username
where vendor.username=@vendor_username

GO
create proc inviteDeliveryPerson 
@delivery_username varchar(20) , @delivery_email varchar(50)
As
insert into Users(username,email)
values(@delivery_username,@delivery_email)
insert into Delivery_Person(username)
values (@delivery_username)
  ------------------
GO
create proc reviewOrders 
As 
select * from Orders
---------------------
go
CREATE PROC updateOrderStatusInProcess
@order_no int 
as
update Orders
set orders.order_status= 'in process'
where Orders.order_no=@order_no
------------------------
Go
create proc addDelivery
@delivery_type varchar(20),@time_duration int,@fees decimal(5,3),@admin_username varchar(20)
AS
insert into Delivery
values (@delivery_type,@time_duration,@fees,@admin_username)
--------------------------------
GO 
CREATE PROC assignOrdertoDelivery
@delivery_username varchar(20),@order_no int,@admin_username varchar(20)
AS
insert into Admin_Delivery_Order 
values (@delivery_username,@order_no,@admin_username,null)
-------------------------------


GO
CREATE PROC createTodaysDeal
@deal_amount int,@admin_username varchar(20),@expiry_date datetime
AS
insert into Todays_Deals
values (@deal_amount,@admin_username,@expiry_date)
------------------------
GO
CREATE PROC  checkTodaysDealOnProduct
@serial_no INT,
@activeDeal BIT output
AS
if(EXISTS( select p.serial_no from Todays_Deals_Product p  where p.serial_no=@serial_no))
set @activeDeal=1
else 
set @activeDeal=0

--------------------------------------------
GO
CREATE PROC addTodaysDealOnProduct
@deal_id int, @serial_no int 
AS
DECLARE @ok bit
DECLARE @ok2 bit

EXEC checkTodaysDealOnProduct @serial_no ,@ok output
if(@ok=0)
begin
insert into Todays_Deals_Product
values(@deal_id,@serial_no)

update Product 
set product.final_price=Product.price-(Product.price *(( select td.deal_amount from Todays_Deals td where td.deal_id=@deal_id)/100))
where Product.serial_no=@serial_no
end
else  -- if it has a tead on it 
begin
EXEC removeExpiredDeal @deal_id -- i will check if this deal is expired 
EXEC checkTodaysDealOnProduct @serial_no ,@ok2 output -- if it's expired .. i will remove it and i will add this new one

if(@ok2=0)
begin
insert into Todays_Deals_Product
values(@deal_id,@serial_no)

update Product 
set product.final_price=Product.price-(Product.price *(( select td.deal_amount from Todays_Deals td where td.deal_id=@deal_id)/100))
where Product.serial_no=@serial_no
end

else 
print 'this product has a deal on it'
end
-------------------------------
GO 
CREATE PROC  removeExpiredDeal
@deal_iD int
AS
if((select td.expiry_date from Todays_Deals td where td.deal_id=@deal_iD)< CURRENT_TIMESTAMP)

update Product 
set product.final_price=Product.price
where Product.serial_no= (select td.serial_no from Todays_Deals_Product td where td.deal_id=@deal_iD)

delete from Todays_Deals where Todays_Deals.deal_id=@deal_iD
delete from Todays_Deals_Product where Todays_Deals_Product.deal_id=@deal_iD
-----------------------------------------------

GO
CREATE PROC createGiftCard
@code varchar(10),@expiry_date datetime,@amount int,@admin_username varchar(20)
AS

INSERT INTO Giftcard 
values(@code,@expiry_date,@amount,@admin_username)

-----------------------------------------------------
Go
CREATE PROC removeExpiredGiftCard
@code varchar(10)
As
if((select g.expiry_date from Giftcard g where g.code=@code)<current_timeStamp)
BEGIN
update customer
set customer.points=customer.points-(select Giftcard.amount from Giftcard where Giftcard.code=@code) 
where Customer.username=(select Customer.username  from Customer ,Admin_Customer_Giftcard 
where Customer.username=Admin_Customer_Giftcard.customer_name AND Admin_Customer_Giftcard.code=@code)

update Customer
set customer.points=0
where Customer.points<0

DELETE FROM Admin_Customer_Giftcard where Admin_Customer_Giftcard.code=@code
DELETE from Giftcard  where Giftcard.code=@code
END


-----------------------------
GO
create proc checkGiftCardOnCustomer----------------هنعمل بيها ايه الله اعلم 
@code varchar(10), @activeGiftCard BIT Output
AS
if(exists (select * from Admin_Customer_Giftcard where Admin_Customer_Giftcard.code=@code))
set @activeGiftCard=1
else
set @activeGiftCard=0

-----------------------------------------
GO
CREATE PROC giveGiftCardtoCustomer
@code varchar(10),@customer_name varchar(20),@admin_username varchar(20)
AS
INSERT INTO Admin_Customer_Giftcard(code,admin_username,customer_name,remaining_points)
values(@code,@admin_username,@customer_name,(select g.amount from Giftcard g where g.code=@code))
if ((select customer.points from customer where Customer.username=@customer_name ) is null)
update Customer
set points=(select g.amount from Giftcard g where g.code=@code AND Customer.username=@customer_name)
where Customer.username=@customer_name
else
update Customer
set points=points+(select g.amount from Giftcard g where g.code=@code AND Customer.username=@customer_name)
where Customer.username=@customer_name
--------------------------------------------------------------------
GO
CREATE PROC acceptAdminInvitation
@delivery_username varchar(20)
As
Update Delivery_Person
set Delivery_Person.is_activated=1  where Delivery_person.username=@delivery_username
--------------------------------------------------------------------

GO
CREATE PROC deliveryPersonUpdateInfo
@username varchar(20),@first_name varchar(20),@last_name varchar(20),@password varchar(20),@email varchar(50)
As
update Users 
set first_name=@first_name , last_name=@last_name , password=@password , email=@email
where username=@username
---------------------------------------------------------------------
GO
CREATE PROC viewmyorders
@deliveryperson varchar(20)
AS
select o.* from 
Orders o,Admin_Delivery_Order A 
where o.order_no=A.order_no AND A.delivery_username=@deliveryperson
-------------------------------------------------------------------------
GO
--Specify a delivery window for each customer order.
CREATE PROC specifyDeliveryWindow
@delivery_username varchar(20),@order_no int,@delivery_window varchar(50)

AS

update Admin_Delivery_Order
set Admin_delivery_order.delivery_window=@delivery_window
where Admin_Delivery_order.delivery_username=@delivery_username AND Admin_Delivery_Order.order_no=@order_no

------------------------------------------------------------------------
--Update the status of an order when it’s out for delivery.
GO
CREATE PROC updateOrderStatusOutforDelivery
@order_no int

AS
Update Orders
set order_status='Out for Delivery' where order_no=@order_no

---------------------------------------------------------------------------
GO
--Update the status of an order when it gets delivered.
CREATE PROC updateOrderStatusDelivered
@order_no int
AS

Update Orders
set order_status='Delivered' where order_no=@order_no

--------------------------------------------------------------------------
GO






