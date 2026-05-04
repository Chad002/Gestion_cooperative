package com.cooperative.servlet;

import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Voiture;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "VoitureServlet", urlPatterns = {"/VoitureServlet"})
public class VoitureServlet extends HttpServlet {

    /**
     * Gère les requêtes GET (Principalement la SUPPRESSION)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String id = request.getParameter("id");

        // Vérification de l'action de suppression
        if ("delete".equals(action) && id != null) {
            VoitureDAO dao = new VoitureDAO();
            boolean ok = dao.supprimerVoiture(id);
            
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<html><body><script>");
            if (ok) {
                out.println("alert('Succès : Voiture " + id + " supprimée avec succès !');");
            } else {
                out.println("alert('Erreur : Impossible de supprimer la voiture.');");
            }
            out.println("window.location.href='gestion_voitures.jsp';");
            out.println("</script></body></html>");
        }
    }

    /**
     * Gère les requêtes POST (AJOUT et MODIFICATION)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // On récupère le champ caché "action" pour savoir si on AJOUTE ou on MODIFIE
        String action = request.getParameter("action");

        try {
            // 1. Récupération des données du formulaire
            String immat = request.getParameter("immatriculation");
            String design = request.getParameter("designation");
            String type = request.getParameter("type");
            
            // Conversion sécurisée des nombres
            int places = 0;
            double frais = 0.0;
            try {
                places = Integer.parseInt(request.getParameter("places"));
                frais = Double.parseDouble(request.getParameter("frais"));
            } catch (NumberFormatException e) {
                throw new Exception("Le nombre de places et les frais doivent être des nombres valides.");
            }

            // 2. Création de l'objet voiture via le CONSTRUCTEUR VIDE (Fix de l'erreur)
            Voiture v = new Voiture();
            v.setImmatriculation(immat);
            v.setDesignation(design);
            v.setType(type);
            v.setPlaces(places);
            v.setFrais(frais);

            VoitureDAO dao = new VoitureDAO();
            boolean succes = false;

            // 3. Choix du traitement selon l'action
            if ("update".equals(action)) {
                // Si c'est une mise à jour, on appelle la méthode de modification
                succes = dao.modifierVoiture(v);
            } else {
                // Sinon, c'est un ajout classique
                succes = dao.ajouterVoiture(v);
            }

            // 4. Feedback visuel
            out.println("<html><body><script>");
            if (succes) {
                out.println("alert('Opération réussie avec succès !');");
                out.println("window.location.href='gestion_voitures.jsp';");
            } else {
                out.println("alert('Erreur : L\\'opération a échoué. Vérifiez vos données.');");
                out.println("window.history.back();");
            }
            out.println("</script></body></html>");

        } catch (Exception e) {
            // Gestion des erreurs critiques
            out.println("<html><body><script>");
            out.println("alert('Erreur système : " + e.getMessage().replace("'", "\\'") + "');");
            out.println("window.history.back();");
            out.println("</script></body></html>");
            e.printStackTrace();
        }
    }
}