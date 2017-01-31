PROCEDURES


1)SINGLE FOOD ORDERING:
***********************


DELIMITER $$


DROP PROCEDURE IF EXISTS PRO_food_ordering$$
CREATE PROCEDURE PRO_food_ordering(IN seat_no VARCHAR(20),IN food_item VARCHAR(20),IN quantity VARCHAR(20),OUT Message VARCHAR(89))

BEGIN
   
DECLARE price INT; 
   
DECLARE order_status VARCHAR(20); 
   
DECLARE quantity_number INT;
  

IF (FN_seat_avail_check(seat_no)='Available')THEN


IF (FN_time_schedule_check(food_item)=1)THEN


SELECT TOTAL_FOOD_QUANTITY INTO quantity_number FROM FOOD_SCHEDULE_DETAILS WHERE FOOD_ITEMS = food_item AND (SELECT FN_check_session_id () =FOOD_ITEMS_ID) ;


IF ((quantity>0) AND (quantity<=quantity_number))THEN

IF (FN_check_item_limit(seat_no)=1) THEN

SELECT 'Your food is Ready';
SELECT FOOD_ORDER_STATUS INTO order_status FROM FOOD_TRANSACTION_RECORDS WHERE FOOD_ORDER_STATUS=order_status;
SELECT ITEMS_PRICE INTO price FROM ITEMS_DETAILS WHERE ITEMS=food_item;
INSERT INTO FOOD_TRANSACTION_RECORDS(SEAT_NUMBER,FOOD_ORDERED,QUANTITY_OF_FOOD,FOOD_PRICE,FOOD_ORDER_STATUS) VALUES(seat_no,food_item,quantity,(price*quantity),'Ordered');
UPDATE STOCK_DETAILS SET STOCK=TOTAL_QUANTITY-quantity WHERE ITEMS=food_item;

ELSE
SET Message= 'Sorry Your order has been reached the Maximum level';
END  IF;

ELSE 

SET Message= 'Please give the Valid Quantity of your Food';

END IF;


ELSE

SET Message='Sorry NO SERVICE at improper time';

END IF;


ELSE

SET Message= 'Sorry this Seat is Already Occupied';

END IF;

END$$

DELIMITER ;

*******************************************************************************************************************************************************

2)MULTIPLE FOODS ORDERING:
**************************


DELIMITER $$
DROP PROCEDURE IF EXISTS PR_food_items_ordering $$
CREATE PROCEDURE PR_food_items_ordering(IN seat_no VARCHAR(10),IN food_items MEDIUMTEXT,IN quantities MEDIUMTEXT,OUT Error_Message VARCHAR(100))

BEGIN

DECLARE food_item TEXT DEFAULT NULL ;

DECLARE food_item_length INT DEFAULT NULL;

DECLARE next_food_item TEXT DEFAULT NULL;        


DECLARE quantity TEXT DEFAULT NULL ;         

DECLARE quantity_length INT DEFAULT NULL;        

DECLARE next_quantity TEXT DEFAULT NULL;


iterator :
 LOOP            


IF LENGTH(TRIM(food_items)) = 0 OR food_items IS NULL OR LENGTH(TRIM(quantities)) = 0 OR quantities IS NULL THEN

LEAVE iterator;

END IF;
               


SET food_item = SUBSTRING_INDEX(food_items,',',1);
SET food_item_length = LENGTH(food_item);             

SET next_food_item = TRIM(food_item);
                                 


SET quantity = SUBSTRING_INDEX(quantities,',',1);                

SET quantity_length = LENGTH(quantity);

SET next_quantity = TRIM(quantity);
                                  


CALL PRO_food_ordering(seat_no,food_item,quantity,@message);
                          


SET food_items = INSERT(food_items,1,food_item_length + 1,'');              

SET quantities = INSERT(quantities,1,quantity_length + 1,'');

END LOOP;

IF (SELECT COUNT(FOOD_ORDER_STATUS)FROM FOOD_TRANSACTION_RECORDS WHERE FOOD_ORDER_STATUS='Ordered')<>0 THEN

UPDATE SEAT_ALLOCATION SET SEAT_AVAILABILITY='Seat Occupied' WHERE SEAT_NUMBER=seat_no;

END IF;

SET Error_Message=@message;
SELECT Error_Message; 
END$$

DELIMITER ;


**********************************************************************************************************************************

3)SINGLE FOOD CANCELLING:
************************


DELIMITER $$


DROP PROCEDURE IF EXISTS `PR_cancellation_of_food`$$

CREATE PROCEDURE `PR_cancellation_of_food`(IN order_id INT,IN food_item VARCHAR(50),IN quantity INT)

BEGIN
    
DECLARE seat_no VARCHAR(20);
    

IF (SELECT FOOD_ORDER_STATUS FROM FOOD_TRANSACTION_RECORDS WHERE  FOOD_ORDER_ID=order_id AND FOOD_ORDERED=food_item)='Cancelled'THEN 

SELECT 'Your Order Already Cancelled';

END IF;
   
 

SELECT SEAT_NUMBER INTO seat_no FROM FOOD_TRANSACTION_RECORDS WHERE FOOD_ORDER_ID=order_id AND FOOD_ORDERED=food_item;


IF (SELECT FOOD_ORDER_STATUS FROM FOOD_TRANSACTION_RECORDS WHERE  FOOD_ORDER_ID=order_id AND FOOD_ORDERED=food_item)='Ordered'THEN 

UPDATE FOOD_TRANSACTION_RECORDS SET FOOD_ORDER_STATUS='Cancelled' WHERE FOOD_ORDER_ID=order_id AND FOOD_ORDERED=food_item;
UPDATE STOCK_DETAILS SET STOCK=STOCK+quantity WHERE ITEMS=food_item;

UPDATE SEAT_ALLOCATION SET SEAT_AVAILABILITY='Empty Seat' WHERE SEAT_NUMBER=seat_no;

END IF;


IF (SELECT FOOD_ORDER_STATUS FROM FOOD_TRANSACTION_RECORDS WHERE FOOD_ORDER_ID=order_id AND FOOD_ORDERED=food_item)='Bill Paid'THEN 

SELECT 'Paid Order cant be Cancelled anymore';

END IF;


IF (SELECT COUNT(FOOD_ORDER_STATUS)FROM FOOD_TRANSACTION_RECORDS WHERE FOOD_ORDER_STATUS='Cancelled' AND SEAT_NUMBER=seat_no)<>0 THEN

UPDATE SEAT_ALLOCATION SET SEAT_AVAILABILITY='Seat Occupied' WHERE SEAT_NUMBER=seat_no;

END IF;    
  
END$$

DELIMITER ;

******************************************************************************************************************************************
4)MULTIPLE FOODS CANCELLING:
****************************


DELIMITER $$

CREATE PROCEDURE PR_food_items_cancelling(IN order_ids MEDIUMTEXT,IN seat_no VARCHAR(10),IN food_items LONGTEXT,IN quantities MEDIUMTEXT)
 BEGIN
DECLARE food_item TEXT DEFAULT NULL ;
DECLARE food_item_length INT DEFAULT NULL;
DECLARE next_food_item TEXT DEFAULT NULL;  
      
DECLARE quantity TEXT DEFAULT NULL ;         
DECLARE quantity_length INT DEFAULT NULL;        
DECLARE next_quantity TEXT DEFAULT NULL;

DECLARE order_id TEXT;
DECLARE order_id_length TEXT;
DECLARE next_order_id TEXT;


iterator :
 LOOP            
IF LENGTH(TRIM(food_items)) = 0 OR food_items IS NULL OR LENGTH(TRIM(quantities)) = 0 OR quantities IS NULL OR LENGTH(TRIM(order_ids)) = 0 OR order_ids IS NULL THEN
LEAVE iterator;
END IF;
               
SET food_item = SUBSTRING_INDEX(food_items,',',1);
SET food_item_length = LENGTH(food_item);             
SET next_food_item = TRIM(food_item);
                                 
SET quantity = SUBSTRING_INDEX(quantities,',',1);                
SET quantity_length = LENGTH(quantity);
SET next_quantity = TRIM(quantity);

SET order_id = SUBSTRING_INDEX(order_ids,',',1);
SET order_id_length = LENGTH(order_id);
SET next_order_id = TRIM(order_id);
                                  
CALL PR_cancellation_of_food(order_id,food_item,quantity);
CALL PR_daily_stock(food_item);   
                            
SET food_items = INSERT(food_items,1,food_item_length + 1,'');              
SET quantities = INSERT(quantities,1,quantity_length + 1,'');
SET order_ids = INSERT(order_ids,1,order_id_length +1,'');
END LOOP;

IF (SELECT COUNT(FOOD_ORDER_STATUS)FROM FOOD_TRANSACTION_RECORDS WHERE FOOD_ORDER_STATUS='Ordered' AND SEAT_NUMBER=seat_no)=0 THEN
UPDATE SEAT_ALLOCATION SET SEAT_AVAILABILITY='Empty Seat' WHERE SEAT_NUMBER=seat_no;

END IF;    
    END$$

DELIMITER ;


***********************************************************************************************************************************************
5)SINGLE FOOD BILLING:
**********************

DELIMITER $$


DROP PROCEDURE IF EXISTS `PR_billingStatus`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PR_billingStatus`(IN orderid INT,IN seatno VARCHAR(30) )

BEGIN
    

SELECT SEAT_NUMBER INTO seatno FROM FOOD_TRANSACTION_RECORDS WHERE FOOD_ORDER_ID=orderid AND SEAT_NUMBER=seatno;
    


IF (SELECT FOOD_ORDER_STATUS FROM FOOD_TRANSACTION_RECORDS WHERE  FOOD_ORDER_ID=orderid AND SEAT_NUMBER=seatno)='Ordered'THEN 

UPDATE FOOD_TRANSACTION_RECORDS SET FOOD_ORDER_STATUS='Bill Paid' WHERE FOOD_ORDER_ID=orderid AND SEAT_NUMBER=seatno;

UPDATE SEAT_ALLOCATION SET SEAT_AVAILABILITY='Empty Seat' WHERE SEAT_NUMBER=seatno;

END IF;


IF (SELECT FOOD_ORDER_STATUS FROM FOOD_TRANSACTION_RECORDS WHERE  FOOD_ORDER_ID=orderid AND SEAT_NUMBER=seatno)='Cancelled'THEN 

SELECT 'Paid Bill cant be Cancelled anymore';

END IF;
    
    
END$$

DELIMITER ;

**************************************************************************************************************************************************
6)MULTIPLE FOODS BILLING
************************

DELIMITER $$


DROP PROCEDURE IF EXISTS `PR_food_items_billing`$$

CREATE PROCEDURE PR_food_items_billing(IN order_ids MEDIUMTEXT,IN seat_no VARCHAR(10),IN food_items MEDIUMTEXT)

BEGIN

DECLARE food_item TEXT DEFAULT NULL ;

DECLARE food_item_length INT DEFAULT NULL;

DECLARE next_food_item TEXT DEFAULT NULL;  
      

DECLARE order_id TEXT;

DECLARE order_id_length TEXT;

DECLARE next_order_id TEXT;


iterator :
 LOOP            

IF LENGTH(TRIM(food_items)) = 0 OR food_items IS NULL OR LENGTH(TRIM(order_ids)) = 0 OR order_ids IS NULL THEN

LEAVE iterator;

END IF;
  
             

SET food_item = SUBSTRING_INDEX(food_items,',',1);

SET food_item_length = LENGTH(food_item);             

SET next_food_item = TRIM(food_item);

                               

SET order_id = SUBSTRING_INDEX(order_ids,',',1);

SET order_id_length = LENGTH(order_id);

SET next_order_id = TRIM(order_id);
 
                                 

CALL PR_billingStatus(Order_id,seat_no);
   
                             

SET food_items = INSERT(food_items,1,food_item_length + 1,'');              

SET order_ids = INSERT(order_ids,1,order_id_length +1,'');


END LOOP;    


IF (SELECT COUNT(FOOD_ORDER_STATUS)FROM FOOD_TRANSACTION_RECORDS WHERE FOOD_ORDER_STATUS='Ordered' AND SEAT_NUMBER=seat_no)=0 THEN

UPDATE SEAT_ALLOCATION SET SEAT_AVAILABILITY='Empty Seat' WHERE SEAT_NUMBER=seat_no;

END IF;
    
END$$


DELIMITER ;

**************************************************************************************************************************************************
