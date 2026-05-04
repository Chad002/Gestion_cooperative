package com.cooperative.servlet;

import com.cooperative.dao.ClientDAO;
import com.cooperative.model.Client;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ClientServlet")
public class ClientServlet extends HttpServlet {
    
    private final ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                lister(request, response);
                break;
            case "search":
                rechercher(request, response);
                break;
            case "delete":
                supprimer(request, response);
                break;
            case "edit":
                chargerPourModification(request, response);
                break;
            default:
                lister(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            ajouter(request, response);
        } else if ("update".equals(action)) {
            modifier(request, response);
        }
    }

    private void lister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Client> liste = clientDAO.listerTous(); 
        request.setAttribute("listeClients", liste);
        request.getRequestDispatcher("gestion_clients.jsp").forward(request, response);
    }

    private void rechercher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String critere = request.getParameter("critere");
        List<Client> liste = clientDAO.rechercherClients(critere);
        request.setAttribute("listeClients", liste);
        request.getRequestDispatcher("gestion_clients.jsp").forward(request, response);
    }

    private void ajouter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String nom = request.getParameter("nom");
        String numtel = request.getParameter("numtel");
        
        // CORRECTION : Utilisation du constructeur à 2 arguments (nom, numtel)
        Client nouveauClient = new Client(nom, numtel);
        clientDAO.ajouterClient(nouveauClient);
        
        response.sendRedirect("ClientServlet?action=list");
    }

    private void modifier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("idcli"));
        String nom = request.getParameter("nom");
        String numtel = request.getParameter("numtel");
        
        // CORRECTION : Utilisation du constructeur à 3 arguments (id, nom, numtel)
        Client clientModifie = new Client(id, nom, numtel);
        clientDAO.modifierClient(clientModifie);
        
        response.sendRedirect("ClientServlet?action=list");
    }

    private void supprimer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            clientDAO.supprimerClient(id);
        }
        response.sendRedirect("ClientServlet?action=list");
    }

    private void chargerPourModification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            Client client = clientDAO.getClientById(id);
            request.setAttribute("client", client);
            request.getRequestDispatcher("modifier_client.jsp").forward(request, response);
        } else {
            response.sendRedirect("ClientServlet?action=list");
        }
    }
}