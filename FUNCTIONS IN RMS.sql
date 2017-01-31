FUNCTIONS

1)FOOD_ITEM_CHECK:
******************

DELIMITER $$

CREATE FUNCTION FN_food_item_check(food_item VARCHAR (20)) 
RETURNS TEXT 

BEGIN
  
IF EXISTS 
(SELECT 
ITEMS 
FROM
 ITEMS_DETAILS  WHERE ITEMS = food_item) 
THEN 
RETURN 'Item Found';
  
ELSE 
RETURN 'Item Not Found';
  
  
END IF ;
  
  

END$$

DELIMITER ;


*******************************************************************************************************************************************************

2)TIME_SCHEDULE_CHECK:
**********************

DELIMITER $$

CREATE FUNCTION FN_time_schedule_check(food_item VARCHAR(50))
    RETURNS INT
    BEGIN
    DECLARE food_time INT;
SELECT FOOD_ID INTO food_time FROM FOOD_SESSION_DETAILS WHERE FOODS_AVAILABLE_FROM<=CURTIME() AND FOODS_CLOSED_AT>=CURTIME();
IF EXISTS (SELECT FOOD_ITEMS FROM FOOD_SCHEDULE_DETAILS WHERE FOOD_ITEMS_ID=food_time AND FOOD_ITEMS=food_item)THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
    END$$

DELIMITER ;


**********************************************************************************************************************************

3) CHECK_ITEM_LIMIT:
********************

DELIMITER$$

CREATE FUNCTION FN_check_item_limit (seat_no VARCHAR (50)) RETURNS INT 
BEGIN
  IF 
  (SELECT COUNT(DISTINCT (FOOD_ORDERED))FROM FOOD_TRANSACTION_RECORDS WHERE SEAT_NUMBER = seat_no AND FOOD_ORDER_STATUS = 'Ordered' OR 'Cancelled') <(SELECT MAX_LIMIT FROM ORDERS WHERE NAME = 'Item Limit') THEN
  RETURN 1 ;
  ELSE RETURN 0 ;
  END IF ;
END $$

DELIMITER ;

******************************************************************************************************************************************
4)SEAT_AVAIL_CHECK:
*******************


DELIMITER $$

CREATE FUNCTION FN_seat_avail_check(seat_no VARCHAR(10)) 
RETURNS TEXT 

BEGIN

IF EXISTS(SELECT SEAT_NUMBER FROM SEAT_ALLOCATION WHERE SEAT_NUMBER=seat_no AND SEAT_AVAILABILITY='Empty Seat 'THEN

RETURN 'Available';

ELSE

RETURN 'UnAvailable';

END IF;
    
END$$

DELIMITER ;


***********************************************************************************************************************************************
5)CHECK_SESSION_ID:
*******************

DELIMITER $$

CREATE FUNCTION FN_check_session_id() 
RETURNS INT

BEGIN
    
DECLARE sessions_id INT;

SELECT FOOD_ID INTO sessions_id FROM FOOD_SESSION_DETAILS WHERE FOODS_AVAILABLE_FROM<=CURTIME() AND FOODS_CLOSED_AT>=CURTIME();
    
RETURN sessions_id;
    
END$$

DELIMITER ;

**************************************************************************************************************************************************

