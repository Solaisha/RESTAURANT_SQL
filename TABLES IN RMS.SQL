TABLES

1)FOOD_SESSION_DETAILS:
***********************

CREATE TABLE FOOD_SESSION_DETAILS(FOOD_ID INT PRIMARY KEY AUTO_INCREMENT,SESSIONS VARCHAR(20),FOODS_AVAILABLE_FROM TIME,FOODS_CLOSED_AT TIME);

INSERT INTO FOOD_SESSION_DETAILS (
  SESSIONS,
  FOODS_AVAILABLE_FROM,
  FOODS_CLOSED_AT
) 
VALUES
  (
    'BreakFast',
    '08:00:00',
    '11:00:00'
  ),
  ('Lunch', '11:15:00', '15:00:00'),
  (
    'Refreshment',
    '15:15:00',
    '23:00:00'
  ),
  ('Dinner', '19:00:00', '23:00:00') ;


*******************************************************************************************************************************************************
2)FOOD_SCHEDULE_DETAILS:
************************

CREATE TABLE SEAT_ALLOCATION(SEAT_ID INT PRIMARY KEY AUTO_INCREMENT,SEAT_NUMBER VARCHAR(20),SEAT_AVAILABILITY VARCHAR(30));

INSERT INTO SEAT_ALLOCATION (SEAT_NUMBER,SEAT_AVAILABILITY) 
VALUES
  ('A1','Empty Seat'),
  ('A2','Empty Seat'),
  ('A3','Empty Seat'),
  ('A4','Empty Seat'),
  ('A5','Empty Seat'),
  ('A6','Empty Seat'),
  ('A7','Empty Seat'),
  ('A8','Empty Seat'),
  ('A9','Empty Seat'),
  ('A10','Empty Seat') ;



**********************************************************************************************************************************

3) FOOD_TRANSACTION_RECORDS:
****************************


CREATE TABLE FOOD_TRANSACTION_RECORDS (
  FOOD_ORDER_ID INT PRIMARY KEY AUTO_INCREMENT,
  SEAT_NUMBER VARCHAR(20),
  FOOD_ORDERED VARCHAR(20),
  QUANTITY_OF_FOOD VARCHAR(20),
  FOOD_PRICE INT,
  ORDER_DATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOOD_ORDER_STATUS VARCHAR (20)
) ; 


******************************************************************************************************************************************
4)ITEMS_DETAILS:
****************


CREATE TABLE ITEMS_DETAILS (ID INT PRIMARY KEY AUTO_INCREMENT,
ITEMS VARCHAR (20),
ITEMS_PRICE INT);

INSERT INTO ITEMS_DETAILS (ITEMS,ITEMS_PRICE) 
VALUES
  ('Idly', 10),
  ('Vada', 5),
  ('Dosa', 15),
  ('Poori', 20),
  ('Pongal',15),
  ('SouthIndian Meals', 30),
  ('NorthIndian Meals',40),
  ('Vareity Rice',35),
  ('Coffee',10),
  ('Tea',10) ,
   ('Snacks',20),
  ('Fried Rice',40),
  ('Chapathi',30),
  ('Chat Items',25) ;


***********************************************************************************************************************************************
5)FOOD_SCHEDULE_DETAILS:
************************


CREATE TABLE FOOD_SCHEDULE_DETAILS (
  ID INT PRIMARY KEY AUTO_INCREMENT,
  FOOD_ITEMS VARCHAR(20),
  FOOD_ITEMS_ID INT,
  TOTAL_FOOD_QUANTITY INT,
  CONSTRAINT fk_food_items_id FOREIGN KEY (FOOD_ITEMS_ID) REFERENCES FOOD_SESSION_DETAILS(FOOD_ID)
) ;

INSERT INTO FOOD_SCHEDULE_DETAILS (
  FOOD_ITEMS,
  FOOD_ITEMS_ID,
  TOTAL_FOOD_QUANTITY
) 
VALUES
  ('Idly', 1, 100),
  ('Vada', 1, 100),
  ('Dosa', 1, 100),
  ('Poori', 1, 100),
  ('Pongal', 1, 100),
  ('coffee', 1, 100),
  ('Tea', 1, 100),
  ('SouthIndian Meals', 2, 75),
  ('NorthIndian Meals', 2, 75),
  ('Vareity Rice', 2, 75),
  ('Coffee', 3, 200),
  ('Tea', 3, 200),
  ('Snacks', 3, 200),
  ('Fried Rice', 4, 100),
  ('Chapathi', 4, 100),
  ('Chat Items', 4, 100);


*******************************************************************************************************************************************************
6)STOCK_DETAILS:
****************


CREATE TABLE STOCK_DETAILS (
  ID INT PRIMARY KEY AUTO_INCREMENT,
  ITEMS VARCHAR(20),
  ITEMS_ID INT,
  TOTAL_QUANTITY INT,
  STOCK INT DEFAULT 0
) ;

INSERT INTO STOCK_DETAILS (
  ITEMS,
  ITEMS_ID,
  TOTAL_QUANTITY
) 
VALUES
  ('Idly', 1, 100),
  ('Vada', 1, 100),
  ('Dosa', 1, 100),
  ('Poori', 1, 100),
  ('Pongal', 1, 100),
  ('coffee', 1, 100),
  ('Tea', 1, 100),
  ('SouthIndian Meals', 2, 75),
  ('NorthIndian Meals', 2, 75),
  ('Vareity Rice', 2, 75),
  ('Coffee', 3, 200),
  ('Tea', 3, 200),
  ('Snacks', 3, 200),
  ('Fried Rice', 4, 100),
  ('Chapathi', 4, 100),
  ('Chat Items', 4, 100);

*************************************************************************************************************************************************************

