package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.ClientDAO; // Nécessaire pour lister les clients
import com.cooperative.model.Reservation;
import com.cooperative.model.Client;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.text.SimpleDateFormat;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ReservationDAO dao = new ReservationDAO();
        ClientDAO clientDao = new ClientDAO(); // Pour récupérer les noms des clients
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if (action.equals("list")) {
            List<Reservation> reservations = dao.listerToutes();
            Map<String, String> stats = dao.getStatsPaiement();
            request.setAttribute("listeReservations", reservations);
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("gestion_reservations.jsp").forward(request, response);
            
        } else if (action.equals("add")) {
            String prochainID = dao.genererProchainID();
            response.sendRedirect("ajouter_reservation.jsp?id=" + prochainID);

        } else if (action.equals("edit")) {
            String id = request.getParameter("id");
            Reservation r = dao.trouverParId(id);
            
            // On récupère TOUS les clients pour la liste déroulante du formulaire
            List<Client> listeClients = clientDao.listerTous(); 
            
            request.setAttribute("reservation", r);
            request.setAttribute("listeClientsDispo", listeClients);
            request.getRequestDispatcher("modifier_reservation.jsp").forward(request, response);

        } else if (action.equals("delete")) {
            String id = request.getParameter("id");
            if (id != null) {
                dao.supprimer(id);
            }
            response.sendRedirect("ReservationServlet?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        ReservationDAO dao = new ReservationDAO();

        if ("insert".equals(action) || "update".equals(action)) {
            try {
                Reservation r = new Reservation();
                String idReserv = request.getParameter("idreserv");
                int idCli = Integer.parseInt(request.getParameter("idcli"));
                
                r.setIdreserv(idReserv);
                r.setIdvoit(Integer.parseInt(request.getParameter("idvoit")));
                r.setIdcli(idCli);
                r.setPlace(Integer.parseInt(request.getParameter("place")));
                r.setPayment(request.getParameter("payment"));
                
                String mntStr = request.getParameter("montant_avance");
                r.setMontantAvance((mntStr == null || mntStr.isEmpty()) ? 0 : Integer.parseInt(mntStr));

                String dateVoyageStr = request.getParameter("date_voyage");
                if (dateVoyageStr != null && !dateVoyageStr.isEmpty()) {
                    java.util.Date dateUtil = new SimpleDateFormat("yyyy-MM-dd").parse(dateVoyageStr);
                    r.setDateVoyage(new java.sql.Date(dateUtil.getTime()));
                }

                if ("insert".equals(action)) {
                    // Sécurité Doublon à l'ajout
                    if (dao.clientExisteDeja(idCli)) {
                        envoyerAlerte(response, "Ce client a déjà une réservation active.");
                        return;
                    }
                    dao.enregistrer(r);
                } else {
                    // Sécurité Doublon à la modification :
                    // On vérifie si idCli appartient déjà à une AUTRE réservation que idReserv
                    if (dao.clientExisteAilleurs(idCli, idReserv)) {
                        envoyerAlerte(response, "Modification impossible : Ce client est déjà enregistré sur une autre réservation.");
                        return;
                    }
                    dao.modifier(r);
                }
                
                response.sendRedirect("ReservationServlet?action=list");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("ReservationServlet?action=list&error=true");
            }
        }
    }

    // Méthode utilitaire pour afficher une alerte JavaScript proprement
    private void envoyerAlerte(HttpServletResponse response, String message) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<script>alert('" + message + "'); window.history.back();</script>");
    }
}