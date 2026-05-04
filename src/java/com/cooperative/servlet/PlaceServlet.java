package com.cooperative.servlet;

import com.cooperative.dao.PlaceDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Place;
import com.cooperative.model.Voiture;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/PlaceServlet")
public class PlaceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // C) Instanciation directe dans le doGet
        VoitureDAO vDao = new VoitureDAO();
        PlaceDAO pDao = new PlaceDAO();
        
        String action = request.getParameter("action");
        if (action == null) action = "list";

        // Chargement systématique de la liste des voitures pour le sélecteur
        List<Voiture> voituresDispo = vDao.listerVoitures();
        request.setAttribute("listeVoitures", voituresDispo);

        if (action.equals("search")) {
            String idSelected = request.getParameter("idvoit");
            
            if (idSelected != null && !idSelected.isEmpty()) {
                // 1. Récupérer les détails de la voiture (pour le type et le nbr de places)
                Voiture v = vDao.getVoitureById(idSelected);
                
                if (v != null) {
                    // 2. Récupérer (ou générer) les places
                    List<Place> places = pDao.getPlacesByVoiture(idSelected, v.getPlaces());
                    
                    // 3. Récupérer les statistiques
                    Map<String, String> stats = pDao.getStatsPlaces(idSelected);
                    
                    // A & B) Envoi des attributs demandés
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