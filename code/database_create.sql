-- MySQL Script generated by MySQL Workbench
-- mar. 23 mars 2021 00:19:21
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema fsmrel
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `evenement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evenement`(
  `id_evenement` INT AUTO_INCREMENT,
  `nom_evenement` VARCHAR(45) NULL,
  `date_debut` DATE NOT NULL,
  `date_fin` DATE NULL,
  `lieu` VARCHAR(45) NULL,
  PRIMARY KEY (`id_evenement`),
  CONSTRAINT date_compare CHECK(date_debut <= date_fin),
  CONSTRAINT date_check CHECK(date_fin <= date_debut + INTERVAL 60 day)
  

  )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `salle`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `salle` (
  `id_salle` INT NOT NULL AUTO_INCREMENT,
  `nom_salle` VARCHAR(45) NOT NULL,
  `capacite` INT NOT NULL,
  PRIMARY KEY (`id_salle`),
  CONSTRAINT check_capacite CHECK (capacite IN(50,100,300)),
  CONSTRAINT check_nomsalle CHECK (nom_salle IN('salle1','salle2','salle3')))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `spectacle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spectacle` (
  `id_spectacle` INT NOT NULL AUTO_INCREMENT,
  `type_spectacle` VARCHAR(45) NULL,
  `date_spectacle` DATE NOT NULL,
  `heure_debut` TIME NULL,
  `heure_fin` TIME NULL,
  `id_evenement` INT NULL,
  `id_salle` INT NULL,
  PRIMARY KEY (`id_spectacle`),
  INDEX `fk_spectacle_evenement_idx` (`id_salle` ASC) VISIBLE,
  CONSTRAINT `fk_spectacle_evenement`
    FOREIGN KEY (`id_evenement`)
    REFERENCES `evenement` (`id_evenement`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_spectacle_salle`
    FOREIGN KEY (`id_salle`)
    REFERENCES `salle` (`id_salle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT date_heure CHECK(`heure_debut` < `heure_fin`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `artiste`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `artiste` (
  `id_artist` INT NOT NULL AUTO_INCREMENT,
  `nom_artiste` VARCHAR(45) NOT NULL,
  `description_artiste` VARCHAR(45) NULL,
  `cachet` DOUBLE NOT NULL,
  `id_spectacle` INT NULL,
  `id_evenement` INT NULL,
  INDEX `fk_artiste_evenement_idx` (`id_evenement` ASC) VISIBLE,
  INDEX `fk_artiste_spectacle_idx` (`id_spectacle` ASC) VISIBLE,
  PRIMARY KEY (`id_artist`),
  CONSTRAINT `fk_artiste_evenement`
    FOREIGN KEY (`id_evenement`)
    REFERENCES `evenement` (`id_evenement`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_artiste_spectacle`
    FOREIGN KEY (`id_spectacle`)
    REFERENCES `spectacle` (`id_spectacle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT check_cachet CHECK (cachet > 0)
    );


-- -----------------------------------------------------
-- Table `personne`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `personne` (
  `id_personne` INT NOT NULL AUTO_INCREMENT,
  `mail` VARCHAR(45) NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `prenom` VARCHAR(45) NOT NULL,
  `date_naissance` DATE NOT NULL,
  `adresse` VARCHAR(45) NOT NULL,
  `numero_telephone` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_personne`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pole`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pole` (
  `id_pole` INT NOT NULL AUTO_INCREMENT,
  `nom_pole` VARCHAR(45) NULL,
  PRIMARY KEY (`id_pole`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `benevole`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benevole_inscription` (
  `id_benevole` INT NOT NULL AUTO_INCREMENT,
  `id_evenement` INT NOT NULL,
  `id_benevole_responsable` INT NULL,
  PRIMARY KEY (`id_benevole`, `id_evenement`),
  INDEX `fk_benevole_inscription_responsable_idx` (`id_benevole_responsable` ASC) VISIBLE,
  INDEX `fk_benevole_inscription_2_idx` (`id_evenement` ASC) VISIBLE,
  CONSTRAINT `fk_benevole_inscription_1`
    FOREIGN KEY (`id_benevole`)
    REFERENCES `benevole` (`id_benevole`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_benevole_inscription_2`
    FOREIGN KEY (`id_evenement`)
    REFERENCES `evenement` (`id_evenement`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_benevole_inscription_responsable`
    FOREIGN KEY (`id_benevole_responsable`)
    REFERENCES `benevole_responsable` (`id_benevole_responsable`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tiket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tiket` (
  `id_tiket` INT NOT NULL AUTO_INCREMENT,
  `prix` DOUBLE NOT NULL,
  `id_personne` INT NOT NULL,
  `payement` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tiket`),
  INDEX `fk_tiket_personne_idx` (`id_personne` ASC) VISIBLE,
  CONSTRAINT `fk_tiket_personne`
    FOREIGN KEY (`id_personne`)
    REFERENCES `personne` (`id_personne`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT check_prix CHECK (prix > 0))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tarif`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarif` (
  `id_tarif` INT NOT NULL AUTO_INCREMENT,
  `type_tarif` VARCHAR(45) NULL,
  `id_spectacle` INT NULL,
  PRIMARY KEY (`id_tarif`),
  INDEX `fk_tarif_spectacle_idx` (`id_spectacle` ASC) VISIBLE,
  CONSTRAINT `fk_tarif_spectacle`
    FOREIGN KEY (`id_spectacle`)
    REFERENCES `spectacle` (`id_spectacle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `payement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `payement` (
  `id-payement` INT NOT NULL AUTO_INCREMENT,
  `id_artist` INT NULL,
  `date_payement` DATETIME NULL,
  `montant` DOUBLE NULL,
  PRIMARY KEY (`id-payement`),
  INDEX `fk_payement_artiste_idx` (`id_artist` ASC) VISIBLE,
  CONSTRAINT `fk_payement_artiste`
    FOREIGN KEY (`id_artist`)
    REFERENCES `artiste` (`id_artist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT check_montant CHECK (montant > 0))

ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `benevole_responsable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benevole_responsable` (
  `id_benevole_responsable` INT NOT NULL AUTO_INCREMENT,
  `nom_responsabilite` VARCHAR(45) NULL,
  PRIMARY KEY (`id_benevole_responsable`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `benevole_inscription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `benevole_inscription` (
  `id_benevole` INT NOT NULL AUTO_INCREMENT ,
  `id_evenement` INT NOT NULL,
  `id_benevole_responsable` INT NULL,
  PRIMARY KEY (`id_benevole`, `id_evenement`),
  INDEX `fk_benevole_inscription_responsable_idx` (`id_benevole_responsable` ASC) VISIBLE,
  INDEX `fk_benevole_inscription_2_idx` (`id_evenement` ASC) VISIBLE,
  CONSTRAINT `fk_benevole_inscription_1`
    FOREIGN KEY (`id_benevole`)
    REFERENCES `benevole` (`id_benevole`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_benevole_inscription_2`
    FOREIGN KEY (`id_evenement`)
    REFERENCES `evenement` (`id_evenement`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_benevole_inscription_responsable`
    FOREIGN KEY (`id_benevole_responsable`)
    REFERENCES `benevole_responsable` (`id_benevole_responsable`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `post` (
  `id_post` INT NOT NULL AUTO_INCREMENT,
  `nom_post` VARCHAR(45) NULL,
  `mail` VARCHAR(45) NULL,
  PRIMARY KEY (`id_post`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `salarie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `salarie` (
  `id_salarie` INT NOT NULL AUTO_INCREMENT,
  `poste` VARCHAR(45) NOT NULL,
  `id_personne` INT NULL,
  `salaire` DOUBLE NOT NULL,
  PRIMARY KEY (`id_salarie`),
  INDEX `fk_salarie_personne_idx` (`id_personne` ASC) VISIBLE,
  CONSTRAINT `fk_salarie_personne`
    FOREIGN KEY (`id_personne`)
    REFERENCES `personne` (`id_personne`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT check_salaire CHECK (salaire > 0))
ENGINE = InnoDB
DEFAULT CHARACTER SET = big5;


-- -----------------------------------------------------
-- Table `compte_client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compte_client` (
  `id_compte_client` INT NOT NULL AUTO_INCREMENT,
  `id_personne` INT NOT NULL,
  PRIMARY KEY (`id_compte_client`),
  INDEX `fk_compte_client_idx` (`id_personne` ASC) VISIBLE,
  CONSTRAINT `fk_compte_client`
    FOREIGN KEY (`id_personne`)
    REFERENCES `personne` (`id_personne`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Placeholder table for view `view1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `view1` (`id` INT);

-- -----------------------------------------------------
-- View `view1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `view1`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
