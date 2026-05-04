package com.cooperative.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Variables Java prêtes pour les données réelles plus tard
        int totalVoitures = 12;
        int clientsInscrits = 154;
        int reservationsJour = 8;
        String recettes = "450 000"; // En String pour gérer l'espace des milliers

        // Envoi des données à la page JSP
        request.setAttribute("totalVoitures", totalVoitures);
        request.setAttribute("clientsInscrits", clientsInscrits);
        request.setAttribute("reservationsJour", reservationsJour);
        request.setAttribute("recettes", recettes);

        // Redirection vers l'interface
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}