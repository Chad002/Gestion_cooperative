<%@page import="java.util.Map"%>
<%@page import="com.cooperative.model.Reservation"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>COOP-TRANS - Gestion Réservations</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: 'Segoe UI', Arial, sans-serif; display: flex; background-color: #f4f7f6; }
        
        /* Sidebar */
        .sidebar { width: 250px; height: 100vh; background-color: #2c3e50; color: white; position: fixed; }
        .sidebar h2 { text-align: center; padding: 20px; border-bottom: 1px solid #34495e; margin: 0; }
        .nav-btn { display: block; width: 100%; padding: 15px 20px; color: white; text-decoration: none; transition: 0.3s; }
        .nav-btn:hover { background-color: #34495e; }
        
        /* Main Content */
        .main-content { margin-left: 250px; padding: 30px; width: calc(100% - 250px); }
        
        .header-section { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
        
        /* Style du bouton Ajouter */
        .btn-ajouter { 
            background-color: #27ae60; 
            color: white; 
            padding: 12px 20px; 
            text-decoration: none; 
            border-radius: 5px; 
            font-weight: bold; 
            transition: background 0.3s;
            display: inline-block;
        }
        .btn-ajouter:hover { background-color: #219150; }

        /* Blocs de Statistiques */
        .stats-container { display: flex; gap: 20px; margin-bottom: 25px; }
        .stat-card { flex: 1; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; border: 1px solid #eee; }
        .stat-card h3 { margin: 0; color: #7f8c8d; font-size: 13px; text-transform: uppercase; }
        .stat-card p { margin: 5px 0 0; font-size: 22px; font-weight: bold; }

        /* Tableau */
        .table-wrapper { background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-height: 450px; overflow-y: auto; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #2c3e50; color: white; padding: 12px; position: sticky; top: 0; font-size: 14px; z-index: 10; }
        td { padding: 10px; border-bottom: 1px solid #eee; text-align: center; font-size: 13px; }

        /* Status Couleurs */
        .pay-sans { color: #e74c3c; font-weight: bold; }
        .pay-avec { color: #f39c12; font-weight: bold; }
        .pay-tout { color: #27ae60; font-weight: bold; }

        /* BOUTONS ACTIONS CORRIGÉS */
        .btn-edit { 
            color: #2980b9 !important; 
            text-decoration: none !important; 
            font-weight: bold; 
            margin-right: 8px; 
        }
        .btn-edit:hover { color: #1a5276 !important; text-decoration: underline !important; }

        .btn-delete { 
            color: #e74c3c !important; 
            text-decoration: none !important; 
            font-weight: bold; 
        }
        .btn-delete:hover { color: #943126 !important; text-decoration: underline !important; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>COOP-TRANS</h2>
        <a href="dashboard" class="nav-btn">🏠 Tableau de Bord</a>
        <a href="gestion_voitures.jsp" class="nav-btn">🚌 Gestion Voitures</a>
        <a href="ClientServlet?action=list" class="nav-btn">👥 Gestion Clients</a>
        <a href="PlaceServlet?action=list" class="nav-btn">🪑 Gestion Places</a>
        <a href="ReservationServlet?action=list" class="nav-btn" style="background-color: #3498db;">📅 Réservations</a>
        <a href="PdfServlet" class="nav-btn" style="background-color: #3498db;">📄 Générer PDF</a>
    </div>

    <div class="main-content">
        <div class="header-section">
            <div>
                <h1>Réservations</h1>
                <p style="color: #7f8c8d;">Gestion des réservations et suivi des paiements en temps réel.</p>
            </div>
            <a href="ReservationServlet?action=add" class="btn-ajouter">+ Ajouter une réservation</a>
        </div>

        <% Map<String, String> stats = (Map<String, String>) request.getAttribute("stats"); %>
        <div class="stats-container">
            <div class="stat-card"><h3>Sans avance</h3><p class="pay-sans"><%= (stats != null) ? stats.get("sans") : "0" %></p></div>
            <div class="stat-card"><h3>Avec avance</h3><p class="pay-avec"><%= (stats != null) ? stats.get("avec") : "0" %></p></div>
            <div class="stat-card"><h3>Tout payé</h3><p class="pay-tout"><%= (stats != null) ? stats.get("tout") : "0" %></p></div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>N°</th>
                        <th>Voiture</th>
                        <th>Client</th>
                        <th>Place</th>
                        <th>Date Réserv.</th>
                        <th>Date Voyage</th>
                        <th>Paiement</th>
                        <th>Montant (Ar)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Reservation> list = (List<Reservation>) request.getAttribute("listeReservations");
                        if (list != null && !list.isEmpty()) {
                            for (Reservation r : list) {
                                String payClass = "";
                                if("Sans avance".equals(r.getPayment())) payClass = "pay-sans";
                                else if("Avec avance".equals(r.getPayment())) payClass = "pay-avec";
                                else payClass = "pay-tout";
                    %>
                        <tr>
                            <td><strong><%= r.getIdreserv() %></strong></td>
                            <td><%= r.getNomVoiture() %></td>
                            <td><%= r.getNomClient() %></td>
                            <td><span style="background: #eee; padding: 2px 6px; border-radius: 3px;">N° <%= r.getPlace() %></span></td>
                            <td>
                                <% 
                                    String dateBrute = String.valueOf(r.getDateReserv());
                                    if(dateBrute != null && dateBrute.length() > 19) {
                                        out.print(dateBrute.substring(0, 19));
                                    } else {
                                        out.print(dateBrute);
                                    }
                                %>
                            </td>
                            <td><%= r.getDateVoyage() %></td>
                            <td class="<%= payClass %>"><%= r.getPayment() %></td>
                            <td><%= String.format("%,d", (int)r.getMontantAvance()) %> Ar</td>
                            <td>
                                <!-- LIEN CORRIGÉ ICI -->
                                <a href="ReservationServlet?action=edit&id=<%= r.getIdreserv() %>" class="btn-edit">Modifier</a>
                                <a href="ReservationServlet?action=delete&id=<%= r.getIdreserv() %>" class="btn-delete" onclick="return confirm('Voulez-vous vraiment supprimer cette réservation ?');">Supprimer</a>
                            </td>
                        </tr>
                    <% 
                            } 
                        } else { 
                    %>
                        <tr>
                            <td colspan="9" style="padding: 20px; color: #95a5a6;">Aucune réservation trouvée.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>