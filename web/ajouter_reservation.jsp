<%@page import="com.cooperative.dao.*"%>
<%@page import="com.cooperative.model.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter une Réservation</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f7f6; padding: 20px; }
        .form-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); max-width: 650px; margin: auto; }
        .form-container h2 { color: #2c3e50; border-bottom: 2px solid #27ae60; padding-bottom: 10px; margin-top: 0; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #34495e; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .readonly-field { background: #eee; font-weight: bold; color: #2c3e50; }
        .button-group { display: flex; gap: 10px; margin-top: 25px; }
        .btn-submit { background: #27ae60; color: white; border: none; padding: 12px; flex: 2; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-annuler { background: #e74c3c; color: white; text-decoration: none; padding: 12px; flex: 1; border-radius: 5px; text-align: center; font-weight: bold; }
        #infoTarif { font-size: 0.9em; display: block; margin-top: 5px; color: #27ae60; font-weight: bold; }
    </style>
</head>
<body>
    <%
        // 1. Gestion de l'ID de réservation
        String idReserv = request.getParameter("id");
        if (idReserv == null || idReserv.trim().isEmpty() || idReserv.equalsIgnoreCase("null")) {
            idReserv = new ReservationDAO().genererProchainID();
        }

        // 2. Date actuelle
        String dateReservation = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        
        // 3. Récupération de la voiture sélectionnée
        String idVoitSel = request.getParameter("idvoit");
        double tarifVoiture = 0;
        int totalPlacesVoiture = 0;

        if (idVoitSel != null && !idVoitSel.isEmpty()) {
            VoitureDAO vDao = new VoitureDAO();
            // On récupère directement la voiture par son ID
            Voiture v = vDao.trouverVoitureParId(Integer.parseInt(idVoitSel)); 
            if (v != null) {
                tarifVoiture = v.getFrais();
                totalPlacesVoiture = v.getPlaces();
            }
        }
    %>

    <div class="form-container">
        <h2>Nouvelle Réservation</h2>
        <form action="ReservationServlet" method="POST">
            <input type="hidden" name="action" value="insert">
            
            <div class="form-group">
                <label>Date de Réservation</label>
                <input type="text" name="date_reservation" value="<%= dateReservation %>" class="readonly-field" readonly>
            </div>

            <div class="form-group">
                <label>Numéro de Réservation</label>
                <input type="text" name="idreserv" value="<%= idReserv %>" class="readonly-field" readonly>
            </div>

            <div class="form-group">
                <label>Client</label>
                <select name="idcli" required>
                    <option value="">-- Sélectionner le client --</option>
                    <% 
                        // CORRECTION : Utilisation de listerTous() au lieu de listerClients()
                        List<Client> clients = new ClientDAO().listerTous(); 
                        for(Client c : clients) { 
                    %>
                        <option value="<%= c.getIdcli() %>"><%= c.getNom() %></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Voiture</label>
                <select name="idvoit" onchange="window.location.href='ajouter_reservation.jsp?id=<%= idReserv %>&idvoit=' + this.value" required>
                    <option value="">-- Choisir une voiture --</option>
                    <% 
                        List<Voiture> voitures = new VoitureDAO().listerVoitures();
                        for(Voiture v : voitures) {
                            String selected = (String.valueOf(v.getId_auto()).equals(idVoitSel)) ? "selected" : "";
                    %>
                        <option value="<%= v.getId_auto() %>" <%= selected %>><%= v.getDesignation() %> (<%= v.getImmatriculation() %>)</option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Place disponible</label>
                <select name="place" required>
                    <% 
                        if(idVoitSel != null && !idVoitSel.isEmpty()) {
                            ReservationDAO resDao = new ReservationDAO();
                            // Vérifiez que getPlacesOccupees(int) est bien public dans ReservationDAO
                            List<Integer> placesOccupees = resDao.getPlacesOccupees(Integer.parseInt(idVoitSel)); 
                            boolean placeTrouvee = false;
                            
                            for(int i = 1; i <= totalPlacesVoiture; i++) {
                                if(!placesOccupees.contains(i)) { 
                                    placeTrouvee = true; %>
                                    <option value="<%= i %>">Place N° <%= i %></option>
                    <%          }
                            }
                            if(!placeTrouvee) { %>
                                <option value="">Désolé, complet</option>
                    <%      }
                        } else { %>
                        <option value="">Sélectionnez d'abord une voiture</option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>Date de Voyage</label>
                <input type="date" name="date_voyage" id="date_voyage" required>
            </div>

            <div class="form-group">
                <label>Mode de Paiement</label>
                <select name="payment" id="paymentMode" onchange="gererPaiement()" required>
                    <option value="Sans avance">Sans avance</option>
                    <option value="Avec avance">Avec avance</option>
                    <option value="Tout payé">Tout payé</option>
                </select>
            </div>

            <div class="form-group">
                <label>Montant Avancé (Ar)</label>
                <input type="number" name="montant_avance" id="montant_avance" value="0">
                <span id="infoTarif"></span>
            </div>

            <div class="button-group">
                <button type="submit" class="btn-submit">Confirmer la Réservation</button>
                <a href="ReservationServlet?action=list" class="btn-annuler">Annuler</a>
            </div>
        </form>
    </div>

    <script>
        function gererPaiement() {
            var mode = document.getElementById('paymentMode').value;
            var champMontant = document.getElementById('montant_avance');
            var tarif = <%= tarifVoiture %>;
            
            if (mode === "Tout payé") {
                champMontant.value = tarif;
                champMontant.readOnly = true;
            } else if (mode === "Sans avance") {
                champMontant.value = 0;
                champMontant.readOnly = true;
            } else {
                champMontant.value = "";
                champMontant.readOnly = false;
                champMontant.focus();
            }
        }

        window.onload = function() {
            var dateInput = document.getElementById('date_voyage');
            var demain = new Date();
            demain.setDate(demain.getDate() + 1);
            dateInput.valueAsDate = demain;
            
            if (<%= tarifVoiture %> > 0) {
                document.getElementById('infoTarif').innerText = "Tarif voiture : " + <%= tarifVoiture %> + " Ar";
            }
        };
    </script>
</body>
</html>