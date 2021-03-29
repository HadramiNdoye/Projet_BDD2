
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

-- -----------------------------------------------------
-- Creation du second trigger
-- -----------------------------------------------------

DELIMITER //
CREATE TRIGGER before_insert_evenement_spectacle BEFORE INSERT
ON spectacle FOR EACH ROW

BEGIN
    -- Declaration des variables --
    DECLARE new_id_salle_evenement,nb_evenement,nb_spectacle INT;
    DECLARE new_date_debut,new_date_fin DATE ;
    DECLARE error_message VARCHAR(100);
    -- On recupere nouvel date debut et nouvel date fin--
    SET new_date_debut = (SELECT e.date_debut from evenement AS e,salle AS s
    WHERE new.id_evenement=e.id_evenement AND new.id_salle=s.id_salle);
     SET new_date_fin = (SELECT e.date_fin from evenement AS e,salle AS s
    WHERE new.id_evenement=e.id_evenement AND new.id_salle=s.id_salle);
    -- On compte le nombre d'evenement utilisant la meme salle--
    SET nb_evenement = (SELECT COUNT(e.id_evenement) FROM evenement AS e,salle AS s,spectacle AS spec
    WHERE new.id_salle=spec.id_salle AND new_date_debut >= e.date_debut
    AND new_date_fin <= e.date_fin);
    IF(nb_evenement > 1) THEN 
      SET error_message = 'salle non disponible pour un evenement et un spectacle'; 
      SIGNAL SQLSTATE  '45000' set message_text = error_message;
    END IF;
END//
DELIMITER ;

-- Creation du troisieme trigger --
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
      SET error_message = 'bénévole déjà assigné à un responsable'; 
      SIGNAL SQLSTATE  '45000' set message_text = error_message;
    END IF;
END//
DELIMITER ;

-- Creation du quatrieme trigger --

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

-- le cinquieme trigger--

DELIMITER //
CREATE TRIGGER insert_ticket AFTER INSERT
ON ticket FOR EACH ROW


BEGIN
    -- Declaration des variables  --
    DECLARE temps_restant INT;
    DECLARE new_heure_debut TIME ;
    SET new_heure_debut = (SELECT spec.heure_debut FROM spectacle AS spec
    WHERE spec.id_spectacle = new.id_spectacle);
    SET temps_restant = (SELECT (CURTIME()-new_heure_debut));
    IF(new.statut_reservation = 'non payé' AND temps_restant <=15 ) THEN 
      UPDATE ticket AS t SET t.disponibilite = 'disponible' WHERE t.id_ticket = new.id_ticket ;
    END IF;

END//
DELIMITER ;

