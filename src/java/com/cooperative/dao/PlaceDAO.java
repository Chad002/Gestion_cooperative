package com.cooperative.dao;

import com.cooperative.model.Place;
import com.cooperative.db.Connexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PlaceDAO {

    // 1. RÉCUPÉRER LES PLACES ET GÉNÉRER SI BESOIN
    public List<Place> getPlacesByVoiture(String idvoit, int nbrPlaceTotal) {
        List<Place> liste = new ArrayList<>();
        Connection con = null;
        
        try {
            con = Connexion.getConn();
            // On vérifie d'abord si des places existent
            String sqlCheck = "SELECT COUNT(*) FROM place WHERE idvoit = ?";
            PreparedStatement psCheck = con.prepareStatement(sqlCheck);
            psCheck.setString(1, idvoit);
            ResultSet rsCheck = psCheck.executeQuery();
            
            if (rsCheck.next() && rsCheck.getInt(1) == 0) {
                // AUCUNE PLACE : On génère avec le BATCH UPDATE
                genererPlacesAutomatique(con, idvoit, nbrPlaceTotal);
            }

            // RÉCUPÉRATION FINALE (Tri croissant par numéro de place)
            String sqlSelect = "SELECT * FROM place WHERE idvoit = ? ORDER BY place ASC";
            PreparedStatement psSelect = con.prepareStatement(sqlSelect);
            psSelect.setString(1, idvoit);
            ResultSet rs = psSelect.executeQuery();

            while (rs.next()) {
                liste.add(new Place(
                    rs.getInt("id_place"),
                    rs.getString("idvoit"),
                    rs.getInt("place"),
                    rs.getString("occupation")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { Connexion.closeConn(con); }
        return liste;
    }

    // 2. LE BATCH UPDATE (Génération rapide)
    private void genererPlacesAutomatique(Connection con, String idvoit, int nbr) throws SQLException {
        String sql = "INSERT INTO place (idvoit, place, occupation) VALUES (?, ?, 'non')";
        PreparedStatement pstmt = con.prepareStatement(sql);
        
        for (int i = 1; i <= nbr; i++) {
            pstmt.setString(1, idvoit);
            pstmt.setInt(2, i);
            pstmt.addBatch(); // On prépare le paquet
        }
        pstmt.executeBatch(); // On envoie tout d'un coup !
    }

    // 3. LES STATISTIQUES (Format String pour tes DIVs)
    public Map<String, String> getStatsPlaces(String idvoit) {
        Map<String, String> stats = new HashMap<>();
        Connection con = null;
        try {
            con = Connexion.getConn();
            String sql = "SELECT " +
                         "COUNT(*) as total, " +
                         "COUNT(*) FILTER (WHERE occupation = 'oui') as occ, " +
                         "COUNT(*) FILTER (WHERE occupation = 'non') as lib " +
                         "FROM place WHERE idvoit = ?";
            
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, idvoit);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                stats.put("total", String.valueOf(rs.getInt("total")));
                stats.put("occupees", String.valueOf(rs.getInt("occ")));
                stats.put("libres", String.valueOf(rs.getInt("lib")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { Connexion.closeConn(con); }
        return stats;
    }
}