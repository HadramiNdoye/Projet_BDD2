drop table personne;
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



