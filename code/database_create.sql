drop table post ;
drop table salarie ;
drop table benevoleresp ;
drop table pole ;
drop table payement ;
drop table inscription;
drop table benevolep ;
drop table tarif ;
drop table tiket ;
drop table personne;
drop table artist ;
drop table salle ;
drop table spectacle ;
drop table evenement ;

/* Creations des tables */

CREATE TABLE evenement
(
    id_evenement integer,
    nom_evenement varchar(30) NOT NULL,
    date_evenement datetime NOT NULL,
    lieu varchar(30) NOT NULL,
    CONSTRAINT pk_evenement PRIMARY KEY (id_evenement)
);

CREATE TABLE spectacle
(
    id_spectacle integer,
    id_evenement integer NOT NULL,
    type_spectacle varchar(30) NOT NULL,
    CONSTRAINT pk_spectacle PRIMARY KEY (id_spectacle),
    CONSTRAINT fk_spectacle FOREIGN KEY (id_evenement) REFERENCES evenement(id_evenement) 
);

CREATE TABLE salle
(
    id_salle integer,
    nom_salle varchar(30),
    capacite integer,
    type_spectacle varchar(30) NOT NULL,
    id_spectacle integer NOT NULL,
    id_evenement integer NOT NULL,
    CONSTRAINT pk_salle PRIMARY KEY (id_salle),
    CONSTRAINT fk_salle_spectacle FOREIGN KEY (id_spectacle) REFERENCES spectacle(id_spectacle),
    CONSTRAINT fk_salle_evenement FOREIGN KEY (id_evenement) REFERENCES evenement(id_evenement),
    CONSTRAINT check_capacite CHECK (capacite IN(50,100,300)),
    CONSTRAINT check_nomsalle CHECK (nom_salle IN('salle1','salle2','salle3'))
);

CREATE TABLE artist
(
    nom_artist varchar(30),
    id_spectacle integer,
    id_evenement integer NOT NULL,
    description_artist varchar(30) NOT NULL,
    CONSTRAINT pk_artist PRIMARY KEY (nom_artist),
    CONSTRAINT fk_artist_id_evenement FOREIGN KEY(id_evenement) REFERENCES evenement(id_evenement),
    CONSTRAINT fk_artist_id_spectacle FOREIGN KEY(id_spectacle) REFERENCES spectacle(id_spectacle)

);

CREATE TABLE personne
(
    mail varchar(30),
    nom varchar(30) NOT NULL,
    prenom varchar(30) NOT NULL,
    data_naissance date NOT NULL,
    adresse varchar(50) NOT NULL,
    numero_telephone varchar(30) NOT NULL,
    id_spectacle integer NOT NULL,
    id_evenement integer NOT NULL,
    CONSTRAINT pk_personne PRIMARY KEY (mail),
    CONSTRAINT fk_personne_spectacle FOREIGN KEY (id_spectacle) REFERENCES spectacle(id_spectacle),
    CONSTRAINT fk_personne_evenement FOREIGN KEY (id_evenement) REFERENCES evenement(id_evenement)
);

CREATE TABLE tiket
(
    id_tiket integer,
    mail varchar(30),
    prix numeric(3,0) not null,
    CONSTRAINT pk_tiket PRIMARY KEY (id_tiket),
    CONSTRAINT fk_tiket_personne FOREIGN KEY (mail) REFERENCES personne (mail),
    CONSTRAINT check_prix CHECK (prix > 0)
);

CREATE TABLE tarif
(
    id_tarif integer,
    id_spectacle integer,
    type_tarif varchar(30) not null ,
    CONSTRAINT pk_tarif PRIMARY KEY (id_tarif),
    CONSTRAINT fk_tarif_spectacle FOREIGN KEY (id_spectacle) REFERENCES spectacle (id_spectacle)
 
);

CREATE TABLE benevolep
(
  mail varchar(30),
  nom varchar(30) NOT NULL,
  prenom varchar(30) NOT NULL,
  data_naissance date NOT NULL,
  adresse varchar(50) NOT NULL,
  numero_telephone varchar(30) NOT NULL,
  id_evenement integer,
  CONSTRAINT pk_benevolep PRIMARY KEY (mail),
  CONSTRAINT fk_benevolep_evenement FOREIGN KEY (id_evenement) REFERENCES evenement(id_evenement)
 
);

CREATE TABLE inscription
(
  mail varchar(30),
  id_evenement integer,
  CONSTRAINT pk_inscription PRIMARY KEY (mail,id_evenement),

  CONSTRAINT fk_inscription_mail FOREIGN KEY (mail) REFERENCES personne (mail),
  CONSTRAINT fk_inscription_id_evenement FOREIGN KEY (id_evenement) REFERENCES evenement(id_evenement)

);

CREATE TABLE payement
(
  id_payement integer,
  nom_artist varchar(30),
  date_payement datetime not null,
  montant NUMERIC(3,0) not null,
  CONSTRAINT pk_payement PRIMARY KEY (id_payement),
  CONSTRAINT fk_payement_artist FOREIGN KEY (nom_artist) REFERENCES artist (nom_artist),
  CONSTRAINT check_montant CHECK (montant > 0)

);

CREATE TABLE pole
(
  nom_pole varchar(30),
  CONSTRAINT pk_pole PRIMARY KEY(nom_pole)
);

CREATE TABLE benevoleresp
(
  mail varchar(30),
  nom varchar(30) NOT NULL,
  prenom varchar(30) NOT NULL,
  data_naissance date NOT NULL,
  adresse varchar(50) NOT NULL,
  numero_telephone varchar(30) NOT NULL,
  id_evenement integer,
  nom_pole varchar(30),
  CONSTRAINT pk_benevolep PRIMARY KEY (mail),
  CONSTRAINT fk_benevoleresp_pole FOREIGN KEY (nom_pole) REFERENCES pole(nom_pole)

 
);

CREATE TABLE salarie(
  mail varchar(30),
  nom varchar(30) NOT NULL,
  prenom varchar(30) NOT NULL,
  data_naissance date NOT NULL,
  adresse varchar(50) NOT NULL,
  numero_telephone varchar(30) NOT NULL,
  CONSTRAINT pk_salarie PRIMARY KEY (mail)
);


CREATE TABLE post
(
  nom_post varchar(30),
  mail varchar(30),
  CONSTRAINT pk_post PRIMARY KEY(nom_post),
  CONSTRAINT fk_post_salarie FOREIGN KEY (mail) REFERENCES salarie(mail)


); 
