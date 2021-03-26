CREATE TRIGGER after_update_evenement AFTER UPDATE
ON evenement 
FOR EACH ROW


BEGIN
DECLARE
    ticket_remboursement CHAR(5);
    ticket_remboursement = (SELECT t.remboursement FROM ticket AS t, specatcle AS s, evenement AS e
    WHERE s.id_evenement=e.id_evenement AND e.id_specatacle=s.id_specatcle) ;
    IF NEW.statut='annullé' THEN
    SET ticket_remboursement = 'oui';
    END IF;
END;
