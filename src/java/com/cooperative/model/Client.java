package com.cooperative.model;

public class Client {
    private int idcli;
    private String nom;
    private String numtel;

    // Constructeur pour la récupération (avec ID)
    public Client(int idcli, String nom, String numtel) {
        this.idcli = idcli;
        this.nom = nom;
        this.numtel = numtel;
    }

    // Constructeur pour l'insertion (sans ID)
    public Client(String nom, String numtel) {
        this.nom = nom;
        this.numtel = numtel;
    }

    // Getters et Setters
    public int getIdcli() { return idcli; }
    public void setIdcli(int idcli) { this.idcli = idcli; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getNumtel() { return numtel; }
    public void setNumtel(String numtel) { this.numtel = numtel; }
}