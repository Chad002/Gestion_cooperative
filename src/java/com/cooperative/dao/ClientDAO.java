package com.cooperative.dao;

import com.cooperative.model.Client;
import com.cooperative.db.Connexion; // Utilisation de TON fichier de connexion
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientDAO {

    // 1. Lister tous les clients (Utilise uniquement idcli, nom, numtel)
    public List<Client> listerTous() {
        List<Client> liste = new ArrayList<>();
        String sql = "SELECT idcli, nom, numtel FROM client ORDER BY nom ASC";
        
        try (Connection con = Connexion.getConn(); // Appel de TA méthode getConn()
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                // Utilise le constructeur (int, String, String) de Client.java
                liste.add(new Client(
                    rs.getInt("idcli"), 
                    rs.getString("nom"), 
                    rs.getString("numtel")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Erreur ClientDAO (listerTous) : " + e.getMessage());
        }
        return liste;
    }

    // 2. Rechercher par nom ou téléphone
    public List<Client> rechercherClients(String critere) {
        List<Client> liste = new ArrayList<>();
        String sql = "SELECT * FROM client WHERE nom ILIKE ? OR numtel LIKE ?";
        
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, "%" + critere + "%");
            ps.setString(2, "%" + critere + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    liste.add(new Client(
                        rs.getInt("idcli"), 
                        rs.getString("nom"), 
                        rs.getString("numtel")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return liste;
    }

    // 3. Ajouter un client
    public boolean ajouterClient(Client c) {
        String sql = "INSERT INTO client (nom, numtel) VALUES (?, ?)";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, c.getNom());
            ps.setString(2, c.getNumtel());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. Modifier un client
    public boolean modifierClient(Client c) {
        String sql = "UPDATE client SET nom = ?, numtel = ? WHERE idcli = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, c.getNom());
            ps.setString(2, c.getNumtel());
            ps.setInt(3, c.getIdcli());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. Supprimer un client
    public boolean supprimerClient(int id) {
        String sql = "DELETE FROM client WHERE idcli = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
    
    // 6. Récupérer un client spécifique par ID
    public Client getClientById(int id) {
        String sql = "SELECT * FROM client WHERE idcli = ?";
        try (Connection con = Connexion.getConn();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Client(
                        rs.getInt("idcli"), 
                        rs.getString("nom"), 
                        rs.getString("numtel")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}