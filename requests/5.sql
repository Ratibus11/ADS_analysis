WITH ventes_par_artisan_par_siecle AS 
(
  SELECT
    id_artisan,
    SUM(quantite) AS quantite,
    CEIL(annee / 100) + 1 AS siecle 
  FROM
    realiser 
    LEFT JOIN
      commande 
      ON commande.id = id_commande 
  GROUP BY
    id_artisan,
    siecle 
)
SELECT
  quantite_s1,
  quantite_s2,
  ROUND( ( ( quantite_s2 :: NUMERIC / quantite_s1 :: NUMERIC ) - 1 ) * 100, 2 ) AS diff_s1_s2,
  quantite_s3,
  ROUND( ( ( quantite_s3 :: NUMERIC / quantite_s2 :: NUMERIC ) - 1 ) * 100, 2 ) AS diff_s2_s3,
  quantite_s4,
  ROUND( ( ( quantite_s4 :: NUMERIC / quantite_s3 :: NUMERIC ) - 1 ) * 100, 2 ) AS diff_s3_s4,
  quantite_s5,
  ROUND( ( ( quantite_s5 :: NUMERIC / quantite_s4 :: NUMERIC ) - 1 ) * 100, 2 ) AS diff_s4_s5 
FROM
  (
    SELECT
      id_artisan,
      quantite AS quantite_s1,
      siecle 
    FROM
      ventes_par_artisan_par_siecle 
    WHERE
      siecle = 1 
  )
  AS siecle_1 
  LEFT JOIN
    (
      SELECT
        id_artisan,
        quantite AS quantite_s2 
      FROM
        ventes_par_artisan_par_siecle 
      WHERE
        siecle = 2 
    )
    AS siecle_2 
    ON siecle_2.id_artisan = siecle_1.id_artisan 
  LEFT JOIN
    (
      SELECT
        id_artisan,
        quantite AS quantite_s3 
      FROM
        ventes_par_artisan_par_siecle 
      WHERE
        siecle = 3 
    )
    AS siecle_3 
    ON siecle_3.id_artisan = siecle_1.id_artisan 
  LEFT JOIN
    (
      SELECT
        id_artisan,
        quantite AS quantite_s4 
      FROM
        ventes_par_artisan_par_siecle 
      WHERE
        siecle = 4 
    )
    AS siecle_4 
    ON siecle_4.id_artisan = siecle_1.id_artisan 
  LEFT JOIN
    (
      SELECT
        id_artisan,
        quantite AS quantite_s5 
      FROM
        ventes_par_artisan_par_siecle 
      WHERE
        siecle = 5 
    )
    AS siecle_5 
    ON siecle_5.id_artisan = siecle_1.id_artisan