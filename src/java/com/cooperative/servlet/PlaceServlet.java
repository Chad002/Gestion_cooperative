package com.cooperative.servlet;

import com.cooperative.dao.PlaceDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.dao.ReservationDAO; // Nouvel import pour lire les réservations
import com.cooperative.model.Place;
import com.cooperative.model.Voiture;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap; // Nouvel import pour les stats
import java.util.List;
import java.util.Map;

@WebServlet("/PlaceServlet")
public class PlaceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        VoitureDAO vDao = new VoitureDAO();
        PlaceDAO pDao = new PlaceDAO();
        ReservationDAO rDao = new ReservationDAO(); // Instanciation du DAO Réservation
        
        String action = request.getParameter("action");
        if (action == null) action = "list";

        // Chargement systématique de la liste des voitures pour le sélecteur
        List<Voiture> voituresDispo = vDao.listerVoitures();
        request.setAttribute("listeVoitures", voituresDispo);

        if (action.equals("search")) {
            String idSelected = request.getParameter("idvoit");
            
            if (idSelected != null && !idSelected.isEmpty()) {
                // 1. Récupérer les détails de la voiture
                Voiture v = vDao.getVoitureById(idSelected);
                
                if (v != null) {
                    // 2. Récupérer les places (qui sont par défaut à 'non' dans la BDD)
                    List<Place> places = pDao.getPlacesByVoiture(idSelected, v.getPlaces());
                    
                    // 3. NOUVEAU : Récupérer les VRAIES places occupées depuis la table RESERVER
                    // Attention: getPlacesOccupees prend l'id_auto (entier)
                    List<Integer> placesOccupees = rDao.getPlacesOccupees(v.getId_auto());
                    
                    // 4. Croisement dynamique des données (Met à jour le texte et les couleurs du tableau)
                    int countOccupees = 0;
                    for (Place p : places) {
                        if (placesOccupees.contains(p.getNumPlace())) {
                            p.setOccupation("oui"); // Force le statut occupé en mémoire
                            countOccupees++;
                        } else {
                            p.setOccupation("non");
                        }
                    }
                    
                    // 5. Calcul dynamique des statistiques (Remplace la méthode getStatsPlaces)
                    int totalPlaces = v.getPlaces();
                    int libres = totalPlaces - countOccupees;
                    
                    Map<String, String> stats = new HashMap<>();
                    stats.put("total", String.valueOf(totalPlaces));
                    stats.put("occupees", String.valueOf(countOccupees));
                    stats.put("libres", String.valueOf(libres));
                    
                    // Envoi des attributs à la JSP
                    request.setAttribute("idSelected", idSelected);
                    request.setAttribute("typeVoiture", v.getType());
                    request.setAttribute("stats", stats);
                    request.setAttribute("listePlaces", places);
                }
            }
        }

        // Redirection vers l'interface
        request.getRequestDispatcher("gestion_places.jsp").forward(request, response);
    }
}