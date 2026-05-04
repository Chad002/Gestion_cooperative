package com.cooperative.model;

public class Voiture {
    // Attributs
    private int id_auto; 
    private String immatriculation;
    private String designation;
    private String type; // Simple, Premium, VIP
    private int places;
    private double frais;

    // Constructeur vide (nécessaire pour les JavaBeans/JSP)
    public Voiture() {
    }

    // Constructeur complet
    public Voiture(int id_auto, String immatriculation, String designation, String type, int places, double frais) {
        this.id_auto = id_auto;
        this.immatriculation = immatriculation;
        this.designation = designation;
        this.type = type;
        this.places = places;
        this.frais = frais;
    }

    // --- GETTER ET SETTER POUR ID_AUTO ---
    public int getId_auto() { 
        return id_auto; 
    }
    
    public void setId_auto(int id_auto) { 
        this.id_auto = id_auto; 
    }

    // --- Getters et Setters existants ---
    public String getImmatriculation() { return immatriculation; }
    public void setImmatriculation(String immatriculation) { this.immatriculation = immatriculation; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getPlaces() { return places; }
    public void setPlaces(int places) { this.places = places; }

    public double getFrais() { return frais; }
    public void setFrais(double frais) { this.frais = frais; }
}