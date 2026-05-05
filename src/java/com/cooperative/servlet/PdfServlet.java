package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Reservation;
import com.cooperative.model.Voiture;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/PdfServlet")
public class PdfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ReservationDAO resDao = new ReservationDAO();
        VoitureDAO voitDao = new VoitureDAO();
        
        String action = request.getParameter("action");
        String idReserv = request.getParameter("idreserv");

        // 1. Toujours charger la liste pour le sélecteur de la page
        List<Reservation> listeReservations = resDao.listerToutes();
        request.setAttribute("listeReservations", listeReservations);

        if (idReserv != null && !idReserv.isEmpty()) {
            Reservation r = resDao.trouverParId(idReserv);
            if (r != null) {
                // On récupère la voiture pour avoir les frais et le type
                Voiture v = voitDao.trouverVoitureParId(r.getIdvoit());
                
                request.setAttribute("res", r);
                request.setAttribute("voit", v);
                
                // Si l'action est "generate", on lance le téléchargement PDF
                if ("generate".equals(action)) {
                    genererFichierPDF(response, r, v);
                    return; 
                }
            }
        }
        
        request.getRequestDispatcher("generer_pdf.jsp").forward(request, response);
    }

    private void genererFichierPDF(HttpServletResponse response, Reservation r, Voiture v) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Recu_" + r.getIdreserv() + ".pdf");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Design du PDF
            Font boldFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
            Paragraph title = new Paragraph("REÇU DE RÉSERVATION N° " + r.getIdreserv(), boldFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph("\n"));

            document.add(new Paragraph("Date de réservation : " + r.getDateReserv()));
            document.add(new Paragraph("Date du voyage : " + r.getDateVoyage()));
            document.add(new Paragraph("Nom du Client : " + r.getNomClient()));
            document.add(new Paragraph("-----------------------------------------------------------"));
            document.add(new Paragraph("Voiture : " + v.getImmatriculation() + " (" + v.getType() + ")"));
            document.add(new Paragraph("Place n° : " + r.getPlace()));
            document.add(new Paragraph("Frais de transport : " + v.getFrais() + " Ar"));
            document.add(new Paragraph("Paiement : " + r.getPayment()));
            
            double reste = v.getFrais() - r.getMontantAvance();
            document.add(new Paragraph("Avance versée : " + r.getMontantAvance() + " Ar"));
            document.add(new Paragraph("Reste à payer : " + reste + " Ar"));

            document.close();
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }
}