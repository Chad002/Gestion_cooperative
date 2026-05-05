<%@page import="java.util.List"%>
<%@page import="com.cooperative.model.Voiture"%>
<%@page import="com.cooperative.dao.VoitureDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>COOP-TRANS - Gestion</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: Arial, sans-serif; display: flex; background-color: #f4f7f6; }
        .sidebar { width: 250px; height: 100vh; background-color: #2c3e50; color: white; position: fixed; }
        .sidebar h2 { text-align: center; padding: 20px; border-bottom: 1px solid #34495e; margin: 0; }
        .nav-btn { display: block; width: 100%; padding: 15px 20px; color: white; text-decoration: none; transition: 0.3s; }
        .nav-btn:hover { background-color: #34495e; }
        .main-content { margin-left: 250px; padding: 30px; width: calc(100% - 250px); }
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
        .btn-add { background-color: #27ae60; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .table-wrapper { background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-height: 520px; overflow-y: auto; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #2c3e50; color: white; padding: 15px; position: sticky; top: 0; }
        td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; }
        .btn-edit { color: #2980b9; margin-right: 10px; text-decoration: none; font-weight: bold; }
        .btn-delete { color: #e74c3c; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>COOP-TRANS</h2>
        <a href="dashboard" class="nav-btn">🏠 Tableau de Bord</a>
        <a href="gestion_voitures.jsp" class="nav-btn" style="background-color: #3498db;">🚌 Gestion Voitures</a>
<!--        <a href="gestion_clients.jsp" class="nav-btn">👥 Gestion Clients</a>-->
        <a href="ClientServlet?action=list" class="nav-btn">👥 Gestion Clients</a>
        <a href="PlaceServlet?action=list" class="nav-btn">🪑 Gestion Places</a>
        <a href="ReservationServlet?action=list" class="nav-btn">📅 Réservations</a>
        <a href="PdfServlet" class="nav-btn" style="background-color: #3498db;">📄 Générer PDF</a>
    </div>

    <div class="main-content">
        <div class="header-section">
            <h1>Liste des Voitures :</h1>
            <a href="ajout_voiture.jsp" class="btn-add">+ Ajouter une voiture</a>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Immatriculation</th>
                        <th>Désignation</th>
                        <th>Type</th>
                        <th>Places</th>
                        <th>Frais (Ar)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        VoitureDAO dao = new VoitureDAO();
                        List<Voiture> liste = dao.listerVoitures();
                        if (liste.isEmpty()) {
                    %>
                        <tr><td colspan="6">Aucune voiture trouvée.</td></tr>
                    <%
                        } else {
                            for (Voiture v : liste) {
                    %>
                        <tr>
                            <td><%= v.getImmatriculation() %></td>
                            <td><%= v.getDesignation() %></td>
                            <td><%= v.getType() %></td>
                            <td><%= v.getPlaces() %></td>
                            <td><%= (int) v.getFrais() %></td>
                            <td>
                                <a href="modifier_voiture.jsp?id=<%= java.net.URLEncoder.encode(v.getImmatriculation(), "UTF-8") %>" class="btn-edit">Modifier</a>
                                <a href="VoitureServlet?action=delete&id=<%= java.net.URLEncoder.encode(v.getImmatriculation(), "UTF-8") %>" 
                                   class="btn-delete" onclick="return confirm('Supprimer ?');">Supprimer</a>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>