SELECT objet.nom as objet, valeur_bronze_moyen_unitaire
FROM (
	SELECT id_objet, AVG(valeur_bronze_unitaire)::BIGINT as valeur_bronze_moyen_unitaire
	FROM (
		SELECT id_objet, (valeur_bronze / quantite)::BIGINT AS valeur_bronze_unitaire
		FROM (
			SELECT id_commande, SUM(valeur_bronze) AS valeur_bronze
			FROM (
				SELECT id_commande, couter.quantite::BIGINT * valeur_bronze::BIGINT AS valeur_bronze
				FROM couter
				LEFT JOIN monnaie on monnaie.id = couter.id_monnaie)
			AS quantite_paye_par_paiement
			GROUP BY id_commande)
		AS valeur_bronze_par_commande
		LEFT JOIN commande ON commande.id = id_commande
		LEFT JOIN objet on id_objet = objet.id
		ORDER BY id_objet ASC)
	AS valeur_bronze_unitaire_par_commande
	GROUP BY id_objet)
AS valeur_bronze_moyen_unitaire
JOIN objet ON objet.id = id_objet
ORDER BY objet