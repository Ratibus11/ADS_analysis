WITH quantite_pouvoir_decoration_par_dieu_par_mois AS (
	SELECT SUM(quantite) AS quantite, id_dieu, id_mois
	FROM (
		SELECT quantite, id_dieu, id_mois
		FROM (
			SELECT id_mois, quantite, id_dieu
			FROM decoration
			LEFT JOIN commande on commande.id_decoration = decoration.id
			WHERE id_dieu IS NOT NULL)
		AS quantite_decoration_par_dieu_par_commande

		UNION ALL

		SELECT
			quantite, id_dieu, id_mois
		FROM (
			SELECT id_mois, quantite, id_dieu
			FROM enchanter
			LEFT JOIN commande ON commande.id = enchanter.id_commande
			LEFT JOIN pouvoir ON id_pouvoir = pouvoir.id
			LEFT JOIN dieu ON id_dieu = dieu.id)
		AS quantite_pouvoir_par_dieu_par_commande)
	AS quantite_pouvoir_decoration_par_dieu_par_commande
	GROUP BY id_mois, id_dieu)
	
SELECT mois.nom AS mois, dieu_fete.nom as dieu_fete, dieu_par_mois.nom AS dieu, quantite_totale, quantite, ROUND(quantite::NUMERIC / quantite_totale::NUMERIC * 100, 2) AS part_dieu
FROM (
	SELECT SUM(quantite) AS quantite_totale, id_mois
	FROM quantite_pouvoir_decoration_par_dieu_par_mois
	GROUP BY id_mois)
AS quantite_pouvoir_decoration_par_mois

LEFT JOIN quantite_pouvoir_decoration_par_dieu_par_mois ON quantite_pouvoir_decoration_par_dieu_par_mois.id_mois = quantite_pouvoir_decoration_par_mois.id_mois
LEFT JOIN dieu AS dieu_par_mois ON dieu_par_mois.id = quantite_pouvoir_decoration_par_dieu_par_mois.id_dieu
LEFT JOIN mois ON mois.id = quantite_pouvoir_decoration_par_mois.id_mois
LEFT JOIN dieu AS dieu_fete ON dieu_fete.id = mois.id_dieu
ORDER BY mois, part_dieu DESC