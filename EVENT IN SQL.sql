EVENTS

*****************************************************
1)DAY UPDATE:
*************
DELIMITER $$

SET GLOBAL event_scheduler = ON$$     
CREATE EVENT EV_day_update

ON SCHEDULE EVERY 1 DAY 
DO
	BEGIN
	   UPDATE STOCK_DETAILS SET STOCK=0;
	END$$

DELIMITER ;
**************************************************