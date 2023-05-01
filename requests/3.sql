SELECT quantites_par_siecle_total.siecle as siecle, quantite_totale, quantite_aegypte, ROUND(quantite_aegypte::NUMERIC / quantite_totale::NUMERIC * 100, 2) AS part_aegypte

FROM
	(SELECT SUM(quantite) AS quantite_totale, siecle
	FROM (
		SELECT quantite, CEIL(annee / 100) + 1 AS siecle
		FROM commande
		LEFT JOIN province ON province.id = id_province)
	AS quantites_par_commande_total
	GROUP BY siecle)
AS quantites_par_siecle_total

LEFT JOIN

	(SELECT SUM(quantite) AS quantite_aegypte, siecle
	FROM (
		SELECT quantite, CEIL(annee / 100) + 1 AS siecle
		FROM commande
		LEFT JOIN province ON province.id = id_province
		WHERE province.nom = 'ÆGYPTE')
	AS quantites_par_commande_aegypte
	GROUP BY siecle)
AS quantites_par_siecle_aegypte

ON quantites_par_siecle_aegypte.siecle = quantites_par_siecle_total.siecle