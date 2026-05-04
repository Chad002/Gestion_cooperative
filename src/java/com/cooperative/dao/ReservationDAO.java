package com.cooperative.dao;

import com.cooperative.model.Reservation;
import com.cooperative.db.Connexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReservationDAO {

    /**
     * RÉCUPÉRER LES NUMÉROS DE PLACES DÉJÀ RÉSERVÉES POUR UNE VOITURE
     * Résout l'erreur "method getPlacesOccupees(int) is undefined"
     */
    public List<Integer> getPlacesOccupees(int idAuto) {
        List<Integer> places = new ArrayList<>();
        String sql = "SELECT place FROM RESERVER WHERE idvoit = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAuto);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    places.add(rs.getInt("place"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return places;
    }

    public List<Reservation> listerToutes() {
        List<Reservation> liste = new ArrayList<>();
        String sql = "SELECT r.*, v.Design as nom_voiture, c.nom as nom_client " +
                     "FROM RESERVER r " +
                     "JOIN VOITURE v ON r.idvoit = v.id_auto " + 
                     "JOIN CLIENT c ON r.idcli = c.idcli " +
                     "ORDER BY r.date_reserv DESC";

        try (Connection con = Connexion.getConn();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Reservation r = mapResultSetToReservation(rs);
                r.setNomVoiture(rs.getString("nom_voiture"));
                r.setNomClient(rs.getString("nom_client"));
                liste.add(r);
            }
        } catch (SQLException e) { 
            System.out.println("Erreur SQL Lister: " + e.getMessage()); 
        }
        return liste;
    }

    public Reservation trouverParId(String id) {
        String sql = "SELECT r.*, v.Design as nom_voiture, c.nom as nom_client " +
                     "FROM RESERVER r " +
                     "JOIN VOITURE v ON r.idvoit = v.id_auto " + 
                     "JOIN CLIENT c ON r.idcli = c.idcli " +
                     "WHERE r.idreserv = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reservation r = mapResultSetToReservation(rs);
                    r.setNomVoiture(rs.getString("nom_voiture"));
                    r.setNomClient(rs.getString("nom_client"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean clientExisteDeja(int idCli) {
        String sql = "SELECT COUNT(*) FROM RESERVER WHERE idcli = ?";
        try (Connection con = Connexion.getConn(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCli);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    public boolean clientExisteAilleurs(int idCli, String idReservActuelle) {
        String sql = "SELECT COUNT(*) FROM RESERVER WHERE idcli = ? AND idreserv != ?";
        try (Connection con = Connexion.getConn(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCli);
            ps.setString(2, idReservActuelle);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    public boolean enregistrer(Reservation r) {
        String sql = "INSERT INTO RESERVER (idreserv, idvoit, idcli, place, date_voyage, payment, montant_avance) VALUES (?, ?, ?, ?, ?, ?, ?)";
        return executerUpdate(sql, r, true);
    }

    public boolean modifier(Reservation r) {
        String sql = "UPDATE RESERVER SET idvoit = ?, idcli = ?, place = ?, date_voyage = ?, payment = ?, montant_avance = ? WHERE idreserv = ?";
        return executerUpdate(sql, r, false);
    }

    public boolean supprimer(String id) {
        String sql = "DELETE FROM RESERVER WHERE idreserv = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, String> getStatsPaiement() {
        Map<String, String> stats = new HashMap<>();
        stats.put("sans", "0"); stats.put("avec", "0"); stats.put("tout", "0");

        String sql = "SELECT payment, COUNT(*) as total FROM RESERVER GROUP BY payment";
        try (Connection con = Connexion.getConn();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                String statut = rs.getString("payment");
                String total = String.valueOf(rs.getInt("total"));
                if (statut != null) {
                    if (statut.contains("Sans")) stats.put("sans", total);
                    else if (statut.contains("Avec")) stats.put("avec", total);
                    else if (statut.contains("Tout")) stats.put("tout", total);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    public String genererProchainID() {
        String sql = "SELECT idreserv FROM RESERVER ORDER BY idreserv DESC LIMIT 1";
        try (Connection con = Connexion.getConn();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                int numero = Integer.parseInt(rs.getString(1).replace("RES-", "")) + 1;
                return String.format("RES-%03d", numero);
            }
        } catch (Exception e) { System.out.println("Erreur ID : " + e.getMessage()); }
        return "RES-001";
    }

    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setIdreserv(rs.getString("idreserv"));
        r.setIdvoit(rs.getInt("idvoit"));
        r.setIdcli(rs.getInt("idcli"));
        r.setPlace(rs.getInt("place"));
        r.setDateReserv(rs.getTimestamp("date_reserv"));
        r.setDateVoyage(rs.getDate("date_voyage"));
        r.setPayment(rs.getString("payment"));
        r.setMontantAvance(rs.getInt("montant_avance"));
        return r;
    }

    private boolean executerUpdate(String sql, Reservation r, boolean isInsert) {
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (isInsert) {
                ps.setString(1, r.getIdreserv());
                ps.setInt(2, r.getIdvoit());
                ps.setInt(3, r.getIdcli());
                ps.setInt(4, r.getPlace());
                ps.setDate(5, r.getDateVoyage() != null ? new java.sql.Date(r.getDateVoyage().getTime()) : null);
                ps.setString(6, r.getPayment());
                ps.setInt(7, r.getMontantAvance());
            } else {
                ps.setInt(1, r.getIdvoit());
                ps.setInt(2, r.getIdcli());
                ps.setInt(3, r.getPlace());
                ps.setDate(4, r.getDateVoyage() != null ? new java.sql.Date(r.getDateVoyage().getTime()) : null);
                ps.setString(5, r.getPayment());
                ps.setInt(6, r.getMontantAvance());
                ps.setString(7, r.getIdreserv());
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}