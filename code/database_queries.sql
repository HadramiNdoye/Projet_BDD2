-- 1.Liste des bénévoles et de leur âge, ainsi que les événements auxquels ils ont participés--
SELECT b.id_benevole, p.mail,p.nom, p.prenom, p.adresse,p.numero_telephone,(YEAR(NOW()) - YEAR(p.date_naissance)) AS age,bi.id_evenement
FROM benevole_inscription AS bi, benevole AS b, personne AS p
WHERE bi.id_benevole= b.id_benevole
AND b.id_personne = p.id_personne ;

-- 2. Montant des prestations réglées aux artistes entre deux dates données--

select a.nom_artiste, datediff(e.date_fin,e.date_debut) as nb_jours,a.cachet
from payement AS p, evenement AS e, artiste AS a,spectacle AS spec
where a.id_spectacle = spec.id_spectacle
and spec.id_evenement = e.id_evenement;

-- 3. Afficher le nombre de places disponibles pour un événement --
select id_evenement, count(capacite) as nb_place 
from spectacle,salle
where spectacle.id_salle = salle.id_salle 
and id_evenement not in (select id_ticket from ticket,personne 
where ticket.id_personne = personne.id_personne)
GROUP by id_evenement;

-- 4 --
SELECT ((dayofyear(date_debut) - dayofyear(NOW())) * 24 ) * 60 AS nb_minutes,
(dayofyear(date_debut) - dayofyear(NOW())) * 24 AS nb_heures, 
dayofyear(date_debut) - dayofyear(NOW()) AS nb_jours, 
(MONTH(date_debut) - MONTH(CURDATE())) AS nb_month,
(YEAR(date_debut) - YEAR(CURDATE())) AS nb_annees
FROM evenement WHERE id_evenement IN(55,56,57,58,59,60) ;
-- 5. 
select e.nom_evenement, count(t.id_ticket) as meilleur_vente,sum(t.prix) as somme_collectee,
(sum(t.prix)  - sum(a.cachet)) as benefice
from  evenement AS e,ticket AS t,personne AS p,spectacle AS spec,artiste AS a
where t.id_personne = p.id_personne and a.id_spectacle = spec.id_spectacle
and e.id_evenement = spec.id_evenement and t.id_spectacle = spec.id_spectacle
GROUP BY e.nom_evenement
order BY meilleur_vente desc;

-- 6.  Proposer une requête d’insertion d’un événement composé de 7 spectacles qui utilisent les 3 salles --
INSERT INTO `evenement` (`id_evenement`, `nom_evenement`, `date_debut`, `date_fin`, `lieu`, `statut`)
VALUES (62, 'fete de la musique', '2021-08-10', '2021-08-23', 'grenoble', 'non annulé');
INSERT INTO `salle` (`id_salle`, `nom_salle`, `capacite`) VALUES (21, 'salle2', 100);
INSERT INTO `spectacle` (`type_spectacle`, `date_spectacle`, `heure_debut`, `heure_fin`, `id_evenement`, `id_salle`) 
VALUES ('lectures', '2021-03-21', '03:52:36', '04:38:29', 62, 21);

INSERT INTO `salle` (`nom_salle`, `capacite`) VALUES ('salle2', 100);
INSERT INTO `spectacle` (`type_spectacle`, `date_spectacle`, `heure_debut`, `heure_fin`, `id_evenement`, `id_salle`) 
VALUES ('lectures', '2021-03-21', '04:52:36', '05:38:29', 62, 24);

INSERT INTO `salle` (`id_salle`,`nom_salle`, `capacite`) VALUES (25,'salle2', 100);
INSERT INTO `spectacle` (`type_spectacle`, `date_spectacle`, `heure_debut`, `heure_fin`, `id_evenement`, `id_salle`) 
VALUES ('lectures', '2021-03-21', '04:52:36', '05:38:29', 62, 25);

INSERT INTO `salle` (`id_salle`,`nom_salle`, `capacite`) VALUES (26,'salle2', 100);
INSERT INTO `spectacle` (`type_spectacle`, `date_spectacle`, `heure_debut`, `heure_fin`, `id_evenement`, `id_salle`) 
VALUES ('lectures', '2021-03-21', '03:52:36', '04:38:29', 62, 26);

INSERT INTO `salle` (`id_salle`,`nom_salle`, `capacite`) VALUES (27,'salle2', 100);
INSERT INTO `spectacle` (`type_spectacle`, `date_spectacle`, `heure_debut`, `heure_fin`, `id_evenement`, `id_salle`) 
VALUES ('lectures', '2021-03-21', '03:52:36', '04:38:29', 62, 27);

INSERT INTO `salle` (`id_salle`,`nom_salle`, `capacite`) VALUES (28,'salle1', 100);
INSERT INTO `spectacle` (`type_spectacle`, `date_spectacle`, `heure_debut`, `heure_fin`, `id_evenement`, `id_salle`) 
VALUES ('lectures', '2021-03-21', '03:52:36', '04:38:29', 62, 28);

INSERT INTO `salle` (`id_salle`,`nom_salle`, `capacite`) VALUES (29,'salle3', 100);
INSERT INTO `spectacle` (`type_spectacle`, `date_spectacle`, `heure_debut`, `heure_fin`, `id_evenement`, `id_salle`) 
VALUES ('danse', '2021-03-21', '03:52:36', '04:38:29', 62, 29);

-- 7. Les salaires annuels des salariés pour une année donnée--
select id_salarie,(salaire*12) as salaire_annuelle, 
year(now()) as annee
from salarie;

-- 8 Les ventes d’un événements classées par tarifs (tarifs plein, jeune, etc.)--
select e.nom_evenement,t.id_ticket,ta.type_tarif
from ticket as t,tarif as ta,spectacle as spec,evenement as e
where ta.id_spectacle = spec.id_spectacle
and spec.id_evenement = e.id_evenement 
and t.id_spectacle = spec.id_spectacle
order by ta.type_tarif asc;

-- 9. Les pourcentages de types de spectacle pour une année donnée --
Select type_spectacle, (Count(type_spectacle)* 100 / (Select Count(*) From spectacle)) as pourcentage
From spectacle
Group By type_spectacle;

-- 10 Les événements annulés ainsi que le montant des tickets remboursés--

UPDATE evenement SET statut='annulé' WHERE id_evenement = 4;
UPDATE evenement SET statut='annulé' WHERE id_evenement = 20;
UPDATE evenement SET statut='annulé' WHERE id_evenement = 11;
UPDATE evenement SET statut='annulé' WHERE id_evenement = 2;
UPDATE evenement SET statut='annulé' WHERE id_evenement = 5;
UPDATE evenement SET statut='annulé' WHERE id_evenement = 7;

SELECT e.id_evenement,e.nom_evenement, sum(t.prix) as montant_tickets FROM evenement as e, spectacle as spec, ticket as t
WHERE e.id_evenement = spec.id_evenement and spec.id_spectacle=t.id_spectacle and t.remboursement = 'oui' and e.statut = 'annulé'
GROUP BY e.id_evenement ;



