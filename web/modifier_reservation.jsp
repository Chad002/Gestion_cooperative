<%@page import="com.cooperative.model.Reservation"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifier la Réservation</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 50px; background-color: #f4f7f6; }
        .form-container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); max-width: 600px; margin: auto; }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 25px; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #34495e; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 14px; }
        input[readonly] { background-color: #edf2f7; cursor: not-allowed; border: 1px solid #cbd5e0; }
        .btn-submit { background-color: #3498db; color: white; padding: 12px; border: none; border-radius: 6px; cursor: pointer; width: 100%; font-size: 16px; font-weight: bold; margin-top: 10px; }
        .btn-submit:hover { background-color: #2980b9; }
        .btn-back { display: block; text-align: center; margin-top: 15px; color: #7f8c8d; text-decoration: none; }
    </style>
</head>
<body>

<%
    Reservation r = (Reservation) request.getAttribute("reservation");
    List<com.cooperative.model.Client> tousLesClients = (List<com.cooperative.model.Client>) request.getAttribute("listeClientsDispo");
    
    if (r == null) {
        response.sendRedirect("ReservationServlet?action=list");
        return;
    }
%>

<div class="form-container">
    <h2>Modifier la Réservation</h2>
    <form action="ReservationServlet" method="POST" id="editForm">
        <input type="hidden" name="action" value="update">

        <div class="form-group">
            <label>ID Réservation</label>
            <input type="text" name="idreserv" value="<%= r.getIdreserv() %>" readonly>
        </div>

        <div class="form-group">
            <label>Voiture (Fixe)</label>
            <input type="hidden" name="idvoit" value="<%= r.getIdvoit() %>">
            <input type="text" value="<%= r.getNomVoiture() %>" readonly>
        </div>

        <div class="form-group">
            <label>Client</label>
            <select name="idcli" required>
                <option value="<%= r.getIdcli() %>" selected><%= r.getNomClient() %> (Actuel)</option>
                <% if (tousLesClients != null) {
                    for (com.cooperative.model.Client c : tousLesClients) { 
                        if(c.getIdcli() != r.getIdcli()) { %>
                        <option value="<%= c.getIdcli() %>"><%= c.getNom() %></option>
                <%      }
                    }
                } %>
            </select>
        </div>

        <div class="form-group">
            <label>Date de voyage</label>
            <!-- Suppression du readonly pour permettre la modification -->
            <input type="date" name="date_voyage" value="<%= r.getDateVoyage() %>" required>
        </div>

        <div class="form-group">
            <label>N° Place</label>
            <!-- Remplacement de l'input par un selecteur -->
            <select name="place" required>
                <% for(int i=1; i<=18; i++) { %>
                    <option value="<%= i %>" <%= (r.getPlace() == i) ? "selected" : "" %>>
                        Place n°<%= i %>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="form-group">
            <label>Type de Paiement</label>
            <select name="payment" id="paymentSelect" onchange="toggleMontant()">
                <option value="Sans avance" <%="Sans avance".equals(r.getPayment())?"selected":""%>>Sans avance</option>
                <option value="Avec avance" <%="Avec avance".equals(r.getPayment())?"selected":""%>>Avec avance</option>
                <option value="Tout payé" <%="Tout payé".equals(r.getPayment())?"selected":""%>>Tout payé</option>
            </select>
        </div>

        <div class="form-group">
            <label>Montant Avancé (Ar)</label>
            <input type="number" name="montant_avance" id="montantInput" value="<%= (int)r.getMontantAvance() %>">
        </div>

        <button type="submit" class="btn-submit">Mettre à jour la réservation</button>
        <a href="ReservationServlet?action=list" class="btn-back">Retour à la liste</a>
    </form>
</div>

<script>
    function toggleMontant() {
        const select = document.getElementById('paymentSelect');
        const input = document.getElementById('montantInput');
        
        if (select.value === "Sans avance") {
            input.value = 0;
            input.readOnly = true;
        } else {
            input.readOnly = false;
        }
    }
    // Appel au chargement pour initialiser l'état du champ montant
    window.onload = toggleMontant;
</script>

</body>
</html>