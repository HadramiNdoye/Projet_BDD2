
-- -----------------------------------------------------
-- Creation des triggers
-- -----------------------------------------------------

/* 1. Un événement peut-être annulé, mais il ne peut pas être supprimé de la base de
données, et un ticket vendu peut-être remboursé, mais pas supprimé */

DELIMITER //
CREATE TRIGGER after_update_evenement AFTER UPDATE
ON evenement FOR EACH ROW

BEGIN
    DECLARE ticket_remboursement CHAR(5);
    -- On recupere l'attribut remboursement --
    SET ticket_remboursement = (SELECT t.remboursement FROM ticket t,spectacle s WHERE t.id_spectacle=s.id_spectacle
         AND s.id_evenement=new.id_evenement);
    IF (NEW.statut='annulé') THEN
      SET ticket_remboursement='oui';
      UPDATE ticket t ,spectacle s SET t.remboursement=ticket_remboursement WHERE new.id_evenement=s.id_evenement 
      AND t.id_spectacle=s.id_spectacle;
    END IF;
END//
DELIMITER ;

/* 2. Vérifier qu’un événement ou un spectacle ne peut pas être créé si un autre
événement ou spectacle utilise déjà une des salles sur le même créneau */

DELIMITER //
CREATE TRIGGER before_insert_evenement_spectacle BEFORE INSERT
ON spectacle FOR EACH ROW

BEGIN
    -- Declaration des variables --
    DECLARE nb_evenement INT;
    DECLARE new_date_debut,new_date_fin DATE ;
    DECLARE error_message VARCHAR(100);
    DECLARE num_salle VARCHAR(100);
    -- On recupere nouvel date debut et nouvel date fin--
    SET new_date_debut = (SELECT e.date_debut from evenement AS e,salle AS s
    WHERE new.id_evenement=e.id_evenement AND new.id_salle=s.id_salle);
     SET new_date_fin = (SELECT e.date_fin from evenement AS e,salle AS s
    WHERE new.id_evenement=e.id_evenement AND new.id_salle=s.id_salle);
    -- On recupere le numero de la salle --
    SET num_salle = (SELECT s.nom_salle FROM salle AS s
    WHERE s.id_salle = new.id_salle);
    -- On compte le nombre d'evenement utilisant la meme salle--
    SET nb_evenement = (SELECT COUNT(e.id_evenement) FROM evenement AS e,salle AS s,spectacle AS spec
    WHERE new.id_salle=spec.id_salle AND new_date_debut >= e.date_debut
    AND new_date_fin <= e.date_fin);
    IF(nb_evenement > 1) THEN 
      SET error_message = CONCAT (num_salle,' ','non disponible pour un evenement et un spectacle'); 
      SIGNAL SQLSTATE  '45000' set message_text = error_message;
    END IF;
END//
DELIMITER ;


/* 3. Un bénévole ne peut-être assigné qu’à un seul responsable par événement */


DELIMITER //
CREATE TRIGGER before_insert_benevole_affec BEFORE INSERT
ON benevole_affectation FOR EACH ROW

BEGIN
    -- Declaration des variables --
    DECLARE nb_id_benevole INT;
    DECLARE error_message VARCHAR(100);
    SET nb_id_benevole = (SELECT COUNT(ba.id_benevole_responsable) FROM benevole_affectation AS ba
    WHERE new.id_benevole=ba.id_benevole);

    IF(nb_id_benevole > 0) THEN 
      SET error_message = CONCAT('bénévole',' ',new.id_benevole,' ','déjà assigné à un responsable'); 
      SIGNAL SQLSTATE  '45000' set message_text = error_message;
    END IF;
END//
DELIMITER ;


/* 4.On ne peut pas vendre plus de tickets que disponible pour un événement par rapport
aux capacités des salles utilisées  */

DELIMITER //
CREATE TRIGGER before_insert_ticket BEFORE INSERT
ON ticket FOR EACH ROW


BEGIN
    -- Declaration des variables  --
    DECLARE error_message VARCHAR(100);
    DECLARE nb_cap_util,nb_ticket INT;
    -- On recupere la capacite des salles utilisées pour un evenement--
    SET nb_cap_util = (SELECT SUM(s.capacite) FROM salle AS s,evenement AS e,spectacle AS spec
    WHERE new.id_spectacle=spec.id_spectacle AND spec.id_salle=s.id_salle AND spec.id_evenement=e.id_evenement);
    -- On compte le nombre de tickets vendus--
    SET nb_ticket = (SELECT COUNT(t.id_ticket) FROM ticket AS t
    WHERE new.id_spectacle=t.id_spectacle);
    IF(nb_ticket > nb_cap_util) THEN 
      SET error_message = 'pas de place disponible'; 
      SIGNAL SQLSTATE  '45000' set message_text = error_message;
    END IF;

END//
DELIMITER ;


/* 5. Les tickets réservés mais non payés doivent redevenir disponibles 15min avant le
début d’un événement */

DELIMITER //
DROP TRIGGER IF EXISTS insert_ticket;
CREATE TRIGGER insert_ticket BEFORE INSERT
ON ticket FOR EACH ROW


BEGIN
    -- Declaration des variables  --
    DECLARE temps_restant TIME;
    DECLARE new_heure_debut TIME ;
    SET new_heure_debut = (SELECT spec.heure_debut FROM spectacle AS spec
    WHERE new.id_spectacle=spec.id_spectacle);
    SET temps_restant = (SELECT (TIMEDIFF(new_heure_debut,CURTIME())));
    IF(new.statut_reservation = 'non payé' AND temps_restant <='00:15:00' ) THEN 
      SET new.disponibilite = 'disponible';
    END IF;

END//
DELIMITER ;

