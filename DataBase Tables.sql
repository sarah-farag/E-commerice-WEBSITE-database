CREATE TABLE  Users(
username     ​VARCHAR(20) ,
first_name   ​VARCHAR(20) , 
last_name    ​VARCHAR(20) , 
password ​    VARCHAR(20) ,
email        ​VARCHAR(50) ,
primary key (username)
);
CREATE TABLE  User_mobile_numbers( ​
mobile_number VARCHAR(14),
username      VARCHAR(20),
foreign  key(username) references Users ON DELETE CASCADE ON UPDATE CASCADE, --------------update do not change????for address too,
primary key(username,mobile_number)
);

CREATE TABLE User_Addresses(
address  varchar(100),
username varchar(20) ,
foreign  key(username) references Users ON DELETE CASCADE ON UPDATE CASCADE,
primary key( address ,username)
);

CREATE TABLE Customer( ​
username VARCHAR(20), 
points   INTEGER not null default 0,
foreign  key(username) references Users ON DELETE CASCADE ON UPDATE CASCADE,
primary key(username)
);

CREATE TABLE Admin( 
username varchar(20),
foreign key(username) references Users ON DELETE CASCADE ON UPDATE CASCADE,
primary key (username)
);


CREATE TABLE Vendor(
username        VARCHAR(20),​ 
activated       BIT   NOT NULL default 0,
company_name    varchar(20)    NOT NULL,
bank_acc_no     varchar(20) UNIQUE NOT NULL ,
admin_username  VARCHAR(20)   ,
foreign  key(username)       references Users  ON DELETE CASCADE ON UPDATE CASCADE ,
foreign  key(admin_username) references Admin ON DELETE NO ACTION ON UPDATE NO ACTION ,--------------------should be set null
PRIMARY KEY (username)
);


CREATE TABLE Delivery_Person ( ​
is_activated BIT NOT NULL default 0,
username  VARCHAR(20), 
PRIMARY KEY(username),
foreign key(username) references Users on DELETE cascade on update cascade, 
);
create table Credit_Card 
(
number  ​    varchar(20), 
expiry_date datetime NOT NULL, 
cvv_code    varchar(4) NOT NULL,
primary key(number)
);
create table Delivery( 
id            int identity PRIMARY KEY,
Type          VARCHAR(20) NOT NULL,
time_duration INT not null, 
fees          decimal(5,3) not null , 
username      varchar(20),
foreign key(username) references Admin on delete cascade on update cascade
);


CREATE TABLE Orders (
order_no            INT PRIMARY KEY IDENTITY,
order_date          datetime not null,
total_amount        decimal(10,2),
cash_amount         decimal(10,2),
credit_amount       decimal (10,2),
payment_type        varchar(10),
order_status        varchar(50) default 'not processed' not null,
remaining_days      INTEGER ,
time_limit          DATETIME ,
Gift_Card_code_used varchar(10) ,
customer_name       varchar(20),
delivery_id         int,
creditCard_number   varchar(20)  ,
foreign key(customer_name)       references Customer on delete CASCADE on update NO ACTION,
foreign key(delivery_id)         references Delivery on delete NO ACTION ON UPDATE NO ACTION,
foreign key(creditCard_number)  references Credit_Card on delete set NULL on update cascade,
foreign key(Gift_Card_code_used) references Giftcard on delete NO ACTION on Update no ACTION


);



CREATE TABLE Admin_Delivery_Order(
delivery_username varchar(20) not null,
order_no ​                 int not null,
admin_username             varchar(20)not null,
delivery_window            varchar(50),
foreign key   (delivery_username) references Delivery_person ON DELETE no Action  ON UPDATE NO ACTION,
foreign key (order_no)          references orders  on delete cascade on update cascade,
foreign  key (admin_username)    references Admin ON DELETE NO ACTION  ON UPDATE NO ACTION,
primary key (delivery_username,order_no)
);


CREATE TABLE Product(
serial_no            int IDENTITY primary key  ,
product_name         varchar(20) not null,
category             varchar(20) not null,
product_description  text not null,
price                decimal(10,2) not null,
final_price          decimal(10,2) not null, -- will be altered after discount 
color                varchar (20) not null,
available            bit not null,
rate                 INT default null,
vendor_username      varchar(20) not null ,
customer_username    varchar(20),
customer_order_id    int ,
foreign key (customer_order_id) references Orders on delete set null on UPDATE CASCADE,
foreign key(vendor_username)    references Vendor on delete NO ACTION on update NO ACTION,
foreign key(customer_username)  references Customer on delete NO ACTION on update NO ACTION
);





CREATE TABLE Customer_CreditCard(
customer_name VARCHAR(20) not null, 
cc_number     varchar(20) not null,
foreign   key (customer_name) references Customer  on delete cascade on update cascade,
foreign   key (cc_number)  References Credit_Card  on delete cascade on update cascade,
PRIMARY KEY(customer_name,cc_number)
);
CREATE TABLE CustomerAddstoCartProduct (
serial_no     int not null,
customer_name varchar (20) not null ,
foreign key (serial_no)     references Product on delete cascade on update cascade ,
foreign key (customer_name) references Customer ON DELETE NO ACTION  ON UPDATE NO ACTION,
primary key(serial_no,customer_name)
);

CREATE TABLE Todays_Deals(
deal_id        int IDENTITY primary key ,
deal_amount    decimal default 0,
admin_username varchar(20),
expiry_date    DATETIME not null ,
foreign key (admin_username)references Admin on delete cascade 
);


CREATE TABLE Todays_Deals_Product (
deal_id    int ,
serial_no  int ,
foreign key (deal_id)   references Todays_Deals on delete cascade on update cascade,
foreign key (serial_no) references Product  ON DELETE NO ACTION  ON UPDATE NO ACTION,
primary key (deal_id,serial_no)
);



CREATE TABLE offer(
offer_id     int PRIMARY KEY IDENTITY,
offer_amount decimal  default 0,
expiry_date DATETIME not null
);




CREATE TABLE offersOnProduct(
offer_id   int not null ,
serial_no  int not null,
foreign key (offer_id) references  offer on delete cascade on update cascade , 
foreign key (offer_id) references  Product on delete cascade on update cascade,
primary key(offer_id,serial_no)
);




CREATE TABLE Customer_Question_Product(
serial_no     int not null ,
question      text ,
answer        text,
customer_name varchar (20) not null ,
foreign key (serial_no) references Product on delete cascade on update cascade,
foreign key (customer_name) references Customer ON DELETE NO ACTION  ON UPDATE NO ACTION,
PRIMARY KEY (serial_no,customer_name)
);




create table Wishlist(
username varchar(20) not null ,
name     varchar (20)	,
foreign key  (username) references Customer on delete cascade on update cascade,
PRIMARY KEY (username,name)
);	



CREATE TABLE Giftcard(
code           varchar(10) PRIMARY KEY ,
expiry_date    DATETIME , 
amount int default 0 NOT NULL,
username       varchar(20), 
foreign key (username) references Admin on delete cascade on update cascade
);



create table Wishlist_Product(
username   varchar(20) not null,
wish_name  varchar (20) not null ,
serial_no  int ,
foreign key (username,wish_name) references Wishlist on delete cascade on update cascade,
foreign key (serial_no) references Product ON DELETE NO ACTION  ON UPDATE NO ACTION,
PRIMARY KEY (username,wish_name,serial_no)
);




 create table Admin_Customer_Giftcard(
code            varchar(10) not null,
customer_name   varchar (20), 
admin_username  varchar (20) not null,
remaining_points INT  ,
foreign key  (customer_name)  references Customer on delete NO ACTION on update NO ACTION ,
foreign  key (code)          references Giftcard on delete NO ACTION on update NO ACTION ,
foreign  key  (admin_username) references Admin on delete NO ACTION on update NO ACTION ,
PRIMARY KEY (code,customer_name,admin_username)

);



--execute this after executing post product in the tests
-- so that  product 2 will be added
insert into Wishlist_Product(username,wish_name,serial_no)
values('ammar.yasser', 'fashion',2)
insert into Wishlist_Product(username,wish_name,serial_no)
values('ammar.yasser', 'fashion',2)


--sama.walid is not in the admins table
--,(4 ,10, 'sama.walid', 2019-11-12 )



INSERT INTO Users (username,first_name,last_name,password,email)
VALUES('nada.sharaf','nada','sharaf','pass7','nada.sharaf@guc.edu.eg')
INSERT INTO Users (username,first_name,last_name,password,email)
VALUES('hadeel.adel','hadeel','adel','pass13','hadeel.adel@guc.edu.eg')
INSERT INTO Users (username,first_name,last_name,password,email)
VALUES('mohamed.tamer','mohamed','tamer','pass16','mohamed.tamer@guc.edu.eg')
INSERT INTO Users (username,first_name,last_name,password,email)
VALUES('hana.aly','hana','aly','pass1','hana.aly@guc.edu.eg')
INSERT INTO Users (username,first_name,last_name,password,email)
VALUES('ammar.yasser','ammar','yasser','pass4','ammar.yasser@guc.edu.eg')
INSERT INTO Admin(username)
VALUES('nada.sharaf'),('hana.aly')
INSERT INTO Customer(username,points)
values('ammar.yasser',15)
INSERT into user_mobile_numbers(mobile_number,username)
values('01111111111','hana.aly'),('1211555411','hana.aly')
INSERT into User_Addresses(address,username)
values('New Cairo','hana.aly'),('Heliopolis','hana.aly')
INSERT INTO Vendor(username,activated,company_name,bank_acc_no,admin_username)
VALUES('hadeel.adel',1,'Dello',47449349234,'hana.aly')
INSERT INTO Credit_Card(number,expiry_date,cvv_code)
values('4444-5555-6666-8888',2028-10-19,'232')

INSERT INTO Delivery_Person(is_activated,username)
VALUES(0,'mohamed.tamer')
Insert into Delivery(type,time_duration,fees)
values('pick-up', 7,10),
('regular' ,14, 30),
('speedy', 1 ,50)
insert into Product(product_name,category,product_description,price,final_price,color,available,rate,vendor_username)
Values
('Bag', 'Fashion', 'backbag', 100, 100 ,'yellow', 1, null ,'hadeel.adel'),
('blue pen', 'stationary', 'useful pen', 10 ,10 ,'Blue',1,null ,'hadeel.adel')
INSERT INTO Customer_CreditCard(customer_name,cc_number)
values('ammar.yasser','4444-5555-6666-8888')
INSERT INTO Todays_Deals(deal_amount,admin_username,expiry_date)
values(30, 'hana.aly', 2019-11-30 ),
(40, 'hana.aly', 2019-11-18 ),
( 50, 'hana.aly' ,2019-12-12)
insert into Giftcard(code,expiry_date,amount)
values('G101',18/11/2019,100)
insert into offer(offer_amount,expiry_date)
values(50,30/11/2019)