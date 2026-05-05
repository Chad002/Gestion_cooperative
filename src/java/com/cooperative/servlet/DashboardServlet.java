package com.cooperative.servlet;

import com.cooperative.dao.VoitureDAO;
import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.ClientDAO; // Assure-toi qu'il est bien là
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Initialisation des DAOs
        VoitureDAO vDao = new VoitureDAO();
        ReservationDAO rDao = new ReservationDAO();
        ClientDAO cDao = new ClientDAO();

        // Récupération des vraies données
        int totalVoitures = vDao.compterToutes();
        int clientsInscrits = cDao.listerTous().size(); // Ou cDao.compterTous()
        int reservationsJour = rDao.compterReservationsJour();
        long totalRecettes = rDao.calculerRecettesTotales();

        // Formatage des recettes (ex: 450 000)
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.FRENCH);
        symbols.setGroupingSeparator(' ');
        DecimalFormat df = new DecimalFormat("#,###", symbols);
        String recettesFormatees = df.format(totalRecettes);

        // Envoi des données à la page JSP[cite: 10]
        request.setAttribute("totalVoitures", totalVoitures);
        request.setAttribute("clientsInscrits", clientsInscrits);
        request.setAttribute("reservationsJour", reservationsJour);
        request.setAttribute("recettes", recettesFormatees);

        // Redirection vers l'interface[cite: 10]
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}