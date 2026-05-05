<%@page import="com.cooperative.model.Voiture"%>
<%@page import="com.cooperative.model.Reservation"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>COOP-TRANS - Reçu PDF</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: Arial, sans-serif; display: flex; background-color: #f4f7f6; }
        
        .sidebar { width: 250px; height: 100vh; background-color: #2c3e50; color: white; position: fixed; }
        .sidebar h2 { text-align: center; padding: 20px; border-bottom: 1px solid #34495e; margin: 0; }
        .nav-btn { display: block; width: 100%; padding: 15px 20px; color: white; text-decoration: none; transition: 0.3s; }
        .nav-btn:hover { background-color: #34495e; }
        
        .main-content { margin-left: 250px; padding: 30px; width: calc(100% - 250px); }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #ddd; padding-bottom: 15px; }
        .btn-pdf { background-color: #e74c3c; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; border: none; cursor: pointer; }
        .btn-pdf:hover { background-color: #c0392b; }

        .filter-box { background: white; padding: 20px; border-radius: 8px; margin-bottom: 25px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .select-input { padding: 10px; border: 1px solid #ccc; border-radius: 4px; width: 350px; font-size: 14px; }
        .btn-preview { background-color: #3498db; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }

        /* Style du Reçu (Aperçu) */
        .receipt-container { 
            background: white; width: 600px; margin: 0 auto; padding: 40px; 
            border: 1px dashed #bdc3c7; border-radius: 4px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .receipt-header { text-align: center; border-bottom: 2px solid #2c3e50; padding-bottom: 20px; margin-bottom: 30px; }
        .receipt-header h2 { margin: 0; color: #2c3e50; font-size: 28px; }
        .receipt-body p { margin: 15px 0; font-size: 16px; color: #34495e; line-height: 1.6; }
        .receipt-body strong { color: #2c3e50; }
        .divider { border-top: 1px solid #eee; margin: 20px 0; }
        .total-box { background: #f9f9f9; padding: 15px; border-radius: 4px; border-left: 5px solid #27ae60; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>COOP-TRANS</h2>
        <a href="dashboard" class="nav-btn">🏠 Tableau de Bord</a>
        <a href="gestion_voitures.jsp" class="nav-btn">🚌 Gestion Voitures</a>
        <a href="ClientServlet?action=list" class="nav-btn">👥 Gestion Clients</a>
        <a href="PlaceServlet?action=list" class="nav-btn">🪑 Gestion Places</a>
        <a href="ReservationServlet?action=list" class="nav-btn">📅 Réservations</a>
        <a href="PdfServlet" class="nav-btn" style="background-color: #3498db;">📄 Générer PDF</a>
    </div>

    <div class="main-content">
        <% 
            Reservation res = (Reservation) request.getAttribute("res");
            Voiture voit = (Voiture) request.getAttribute("voit");
        %>

        <div class="header-section">
            <div>
                <h1>Reçu de réservation :</h1>
                <p>Aperçu et impression du reçu client.</p>
            </div>
            <% if (res != null) { %>
                <a href="PdfServlet?action=generate&idreserv=<%= res.getIdreserv() %>" class="btn-pdf">📥 Générer un PDF</a>
            <% } %>
        </div>

        <div class="filter-box">
            <form action="PdfServlet" method="GET">
                <label>Sélectionner une réservation :</label>
                <select name="idreserv" class="select-input" required>
                    <option value="">-- Choisir une réservation --</option>
                    <% 
                        List<Reservation> liste = (List<Reservation>) request.getAttribute("listeReservations");
                        if (liste != null) {
                            for (Reservation r : liste) {
                                String selected = (res != null && r.getIdreserv().equals(res.getIdreserv())) ? "selected" : "";
                    %>
                        <option value="<%= r.getIdreserv() %>" <%= selected %>>
                            <%= r.getIdreserv() %> - <%= r.getNomClient() %>
                        </option>
                    <% } } %>
                </select>
                <button type="submit" class="btn-preview">Afficher l'aperçu</button>
            </form>
        </div>

        <% if (res != null && voit != null) { 
            double reste = voit.getFrais() - res.getMontantAvance();
        %>
            <div class="receipt-container">
                <div class="receipt-header">
                    <h2>Reçu N° <%= res.getIdreserv() %></h2>
                </div>
                
                <div class="receipt-body">
                    <p><strong>Date de réservation :</strong> <%= res.getDateReserv() %></p>
                    <p><strong>Date du voyage :</strong> <%= res.getDateVoyage() %></p>
                    <div class="divider"></div>
                    <p><strong>Nom du Client :</strong> <%= res.getNomClient() %></p>
                    <p><strong>Voiture N° :</strong> <%= voit.getImmatriculation() %> | <strong>Type :</strong> <%= voit.getType() %></p>
                    <p><strong>Place n° :</strong> <%= res.getPlace() %></p>
                    <div class="divider"></div>
                    <p><strong>Frais :</strong> <%= (int) voit.getFrais() %> Ar</p>
                    <p><strong>Paiement :</strong> <%= res.getPayment() %></p>
                    
                    <div class="total-box">
                        <p><strong>Montant Avance :</strong> <%= res.getMontantAvance() %> Ar</p>
                        <p style="font-size: 20px; color: #c0392b;"><strong>Reste :</strong> <%= (int) reste %> Ar</p>
                    </div>
                </div>
            </div>
        <% } else if (request.getParameter("idreserv") != null) { %>
            <p style="text-align: center; color: #e74c3c; font-weight: bold;">Erreur : Impossible de charger les détails de cette réservation.</p>
        <% } %>
    </div>
</body>
</html>