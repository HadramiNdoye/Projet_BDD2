
-- -----------------------------------------------------
-- Creation du premier trigger
-- -----------------------------------------------------

DELIMITER //
CREATE TRIGGER after_update_evenement AFTER UPDATE
ON evenement FOR EACH ROW

BEGIN
    DECLARE ticket_remboursement CHAR(5);
    -- On recupere l'attribut remboursement --
    SET ticket_remboursement = (SELECT t.remboursement FROM ticket t,spectacle s WHERE t.id_spectacle=s.id_spectacle
         AND s.id_evenement=new.id_evenement);
    IF (NEW.statu='annullé') THEN
      SET ticket_remboursement='oui';
      UPDATE ticket t ,spectacle s SET t.remboursement=ticket_remboursement WHERE new.id_evenement=s.id_evenement 
      AND t.id_spectacle=s.id_spectacle;
    END IF;
END//
DELIMITER ;

