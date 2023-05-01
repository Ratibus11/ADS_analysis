SELECT quantites_par_siecle_total.siecle as siecle, quantite_total, quantite_aegypte, ROUND(quantite_aegypte::numeric / quantite_total::numeric * 100, 2)

FROM
	(SELECT SUM(quantite) AS quantite_total, siecle
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