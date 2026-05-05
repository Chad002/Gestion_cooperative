package com.cooperative.dao;

import com.cooperative.model.Voiture;
import com.cooperative.db.Connexion; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VoitureDAO {

    public boolean ajouterVoiture(Voiture voiture) {
        boolean estAjoute = false;
        String sql = "INSERT INTO VOITURE (idvoit, Design, type, nbrplace, frais) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = Connexion.getConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            if (con != null) {
                pstmt.setString(1, voiture.getImmatriculation());
                pstmt.setString(2, voiture.getDesignation());
                pstmt.setString(3, voiture.getType());
                pstmt.setInt(4, voiture.getPlaces());
                pstmt.setDouble(5, voiture.getFrais());
                int lignes = pstmt.executeUpdate();
                if (lignes > 0) estAjoute = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return estAjoute;
    }

    public List<Voiture> listerVoitures() {
        List<Voiture> liste = new ArrayList<>();
        String sql = "SELECT * FROM VOITURE ORDER BY id_auto DESC";
        try (Connection con = Connexion.getConn();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Voiture v = new Voiture();
                v.setId_auto(rs.getInt("id_auto")); 
                v.setImmatriculation(rs.getString("idvoit"));
                v.setDesignation(rs.getString("Design"));
                v.setType(rs.getString("type"));
                v.setPlaces(rs.getInt("nbrplace"));
                v.setFrais(rs.getDouble("frais"));
                liste.add(v);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return liste;
    }

    public Voiture getVoitureById(String immat) {
        Voiture v = null;
        String sql = "SELECT * FROM VOITURE WHERE idvoit = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, immat);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    v = new Voiture();
                    v.setId_auto(rs.getInt("id_auto"));
                    v.setImmatriculation(rs.getString("idvoit"));
                    v.setDesignation(rs.getString("Design"));
                    v.setType(rs.getString("type"));
                    v.setPlaces(rs.getInt("nbrplace"));
                    v.setFrais(rs.getDouble("frais"));
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return v;
    }

    public Voiture trouverVoitureParId(int idAuto) {
        Voiture v = null;
        String sql = "SELECT * FROM VOITURE WHERE id_auto = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAuto);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    v = new Voiture();
                    v.setId_auto(rs.getInt("id_auto"));
                    v.setImmatriculation(rs.getString("idvoit"));
                    v.setDesignation(rs.getString("Design"));
                    v.setType(rs.getString("type"));
                    v.setPlaces(rs.getInt("nbrplace"));
                    v.setFrais(rs.getDouble("frais"));
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return v;
    }

    public boolean modifierVoiture(Voiture v) {
        String sql = "UPDATE VOITURE SET Design=?, type=?, nbrplace=?, frais=? WHERE idvoit=?";
        try (Connection con = Connexion.getConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, v.getDesignation());
            pstmt.setString(2, v.getType());
            pstmt.setInt(3, v.getPlaces());
            pstmt.setDouble(4, v.getFrais());
            pstmt.setString(5, v.getImmatriculation());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false;
        }
    }

    public boolean supprimerVoiture(String immat) {
        String sql = "DELETE FROM VOITURE WHERE idvoit = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, immat);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int compterToutes() {
        String sql = "SELECT COUNT(*) FROM VOITURE";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
    
}