package com.cooperative.model;

import java.sql.Timestamp;
import java.sql.Date;

public class Reservation {
    private String idreserv;
    private int idvoit;
    private String nomVoiture; // Pour afficher la désignation dans le tableau
    private int idcli;
    private String nomClient;  // Pour afficher le nom du client dans le tableau
    private int place;
    private Timestamp dateReserv; // Format AAAA-MM-JJ HH:MM:SS
    private Date dateVoyage;     // Format AAAA-MM-JJ[cite: 1]
    private String payment;
    private int montantAvance;

    public Reservation() {}

    // Getters et Setters pour que le JSP puisse lire les données[cite: 1]
    public String getIdreserv() { return idreserv; }
    public void setIdreserv(String idreserv) { this.idreserv = idreserv; }

    public int getIdvoit() { return idvoit; }
    public void setIdvoit(int idvoit) { this.idvoit = idvoit; }

    public String getNomVoiture() { return nomVoiture; }
    public void setNomVoiture(String nomVoiture) { this.nomVoiture = nomVoiture; }

    public int getIdcli() { return idcli; }
    public void setIdcli(int idcli) { this.idcli = idcli; }

    public String getNomClient() { return nomClient; }
    public void setNomClient(String nomClient) { this.nomClient = nomClient; }

    public int getPlace() { return place; }
    public void setPlace(int place) { this.place = place; }

    public Timestamp getDateReserv() { return dateReserv; }
    public void setDateReserv(Timestamp dateReserv) { this.dateReserv = dateReserv; }

    public Date getDateVoyage() { return dateVoyage; }
    public void setDateVoyage(Date dateVoyage) { this.dateVoyage = dateVoyage; }

    public String getPayment() { return payment; }
    public void setPayment(String payment) { this.payment = payment; }

    public int getMontantAvance() { return montantAvance; }
    public void setMontantAvance(int montantAvance) { this.montantAvance = montantAvance; }
}