package com.cooperative.model;

public class Place {
    private int idPlace;      // Ton ID SERIAL caché
    private String idvoit;    // Le matricule de la voiture
    private int numPlace;     // Le numéro de la place (1, 2, 3...)
    private String occupation; // "oui" ou "non"

    public Place() {}

    public Place(int idPlace, String idvoit, int numPlace, String occupation) {
        this.idPlace = idPlace;
        this.idvoit = idvoit;
        this.numPlace = numPlace;
        this.occupation = occupation;
    }

    // Getters et Setters
    public int getIdPlace() { return idPlace; }
    public void setIdPlace(int idPlace) { this.idPlace = idPlace; }

    public String getIdvoit() { return idvoit; }
    public void setIdvoit(String idvoit) { this.idvoit = idvoit; }

    public int getNumPlace() { return numPlace; }
    public void setNumPlace(int numPlace) { this.numPlace = numPlace; }

    public String getOccupation() { return occupation; }
    public void setOccupation(String occupation) { this.occupation = occupation; }
}