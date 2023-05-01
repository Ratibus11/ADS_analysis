SELECT 
  * 
FROM 
  (
    SELECT 
      province.nom AS province, 
      ROW_NUMBER() OVER (
        PARTITION BY id_province 
        ORDER BY 
          quantite DESC
      ) AS top_vente, 
      quantite, 
      dieu.nom AS dieu 
    FROM 
      (
        SELECT 
          SUM(quantite) AS quantite, 
          id_dieu, 
          id_province 
        FROM 
          (
            SELECT 
              quantite, 
              id_dieu, 
              id_province 
            FROM 
              (
                SELECT 
                  id_province, 
                  quantite, 
                  id_dieu 
                FROM 
                  decoration 
                  LEFT JOIN commande on commande.id_decoration = decoration.id 
                WHERE 
                  id_dieu IS NOT NULL
              ) AS quantite_decoration_par_dieu_par_commande 
            UNION ALL 
            SELECT 
              quantite, 
              id_dieu, 
              id_province 
            FROM 
              (
                SELECT 
                  id_province, 
                  quantite, 
                  id_dieu 
                FROM 
                  enchanter 
                  LEFT JOIN commande ON commande.id = enchanter.id_commande 
                  LEFT JOIN pouvoir ON id_pouvoir = pouvoir.id 
                  LEFT JOIN dieu ON id_dieu = dieu.id
              ) AS quantite_pouvoir_par_dieu_par_commande
          ) AS quantite_pouvoir_decoration_par_dieu_par_commande 
        GROUP BY 
          id_province, 
          id_dieu
      ) AS quantite_pouvoir_decoration_par_dieu_par_province 
      LEFT JOIN dieu ON dieu.id = id_dieu 
      LEFT JOIN province ON province.id = id_province 
    ORDER BY 
      province ASC, 
      quantite DESC
  ) AS quantite_pouvoir_decoration_par_dieu_par_province_avec_noms 
WHERE 
  top_vente <= 5