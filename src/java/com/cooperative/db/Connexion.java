/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.cooperative.db;

/**
 *
 * @author RUSS
 */


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connexion {
    
    // Paramètres configurés pour votre nouvelle version de Postgres
    private static final String URL = "jdbc:postgresql://localhost:5433/db_gestion_cooperative";
    private static final String USER = "postgres";
    private static final String PASSWORD = "admin";

    /**
     * Méthode statique pour ouvrir la connexion
     * @return Connection
     */
    public static Connection getConn() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            
            if (con != null) {
                System.out.println("=== SUCCÈS : Connexion établie sur le port 5433 ! ===");
            }
        } catch (Exception e) {
            System.out.println("=== ÉCHEC : Impossible de se connecter à la base ===");
            e.printStackTrace();
        }
        return con;
    }

    /**
     * Méthode statique pour fermer proprement la connexion
     * @param con La connexion à fermer
     */
    public static void closeConn(Connection con) {
        if (con != null) {
            try {
                con.close();
                System.out.println("=== INFO : Connexion fermée avec succès. ===");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}