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

public class Test {
    public static void main(String[] args) {
        // Appel de votre méthode statique
        Connection c = Connexion.getConn();
        
        // Fermeture immédiate après test
        if (c != null) {
            Connexion.closeConn(c);
        }
    }
}