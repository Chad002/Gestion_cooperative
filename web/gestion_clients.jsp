<%@page import="java.util.List"%>
<%@page import="com.cooperative.model.Client"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>COOP-TRANS - Gestion Clients</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: Arial, sans-serif; display: flex; background-color: #f4f7f6; }
        .sidebar { width: 250px; height: 100vh; background-color: #2c3e50; color: white; position: fixed; }
        .sidebar h2 { text-align: center; padding: 20px; border-bottom: 1px solid #34495e; margin: 0; }
        .nav-btn { display: block; width: 100%; padding: 15px 20px; color: white; text-decoration: none; transition: 0.3s; }
        .nav-btn:hover { background-color: #34495e; }
        .main-content { margin-left: 250px; padding: 30px; width: calc(100% - 250px); }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
        
        /* Barre de recherche compacte */
        .search-container { display: flex; gap: 5px; align-items: center; }
        .search-input { padding: 8px; border: 1px solid #ccc; border-radius: 4px; width: 200px; }
        .btn-search { background-color: #3498db; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-refresh { background-color: #e67e22; color: white; text-decoration: none; padding: 8px 15px; border-radius: 4px; font-weight: bold; font-size: 14px; }
        
        .btn-add { background-color: #27ae60; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .table-wrapper { background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-height: 520px; overflow-y: auto; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #2c3e50; color: white; padding: 15px; position: sticky; top: 0; }
        td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; }
        .btn-edit { color: #2980b9; margin-right: 10px; text-decoration: none; font-weight: bold; }
        .btn-delete { color: #e74c3c; text-decoration: none; font-weight: bold; }
        
        .no-data-cell { padding: 30px; color: #e74c3c; font-weight: bold; font-style: italic; text-align: center; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>COOP-TRANS</h2>
        <a href="dashboard" class="nav-btn">🏠 Tableau de Bord</a>
        <a href="gestion_voitures.jsp" class="nav-btn">🚌 Gestion Voitures</a>
<!--        <a href="gestion_clients.jsp" class="nav-btn" style="background-color: #3498db;">👥 Gestion Clients</a>-->
        <a href="ClientServlet?action=list" class="nav-btn">👥 Gestion Clients</a>
        <a href="PlaceServlet?action=list" class="nav-btn">🪑 Gestion Places</a>
        <a href="ReservationServlet?action=list" class="nav-btn">📅 Réservations</a>
        <a href="PdfServlet" class="nav-btn" style="background-color: #3498db;">📄 Générer PDF</a>
    </div>

    <div class="main-content">
        <div class="header-section">
            <h1>Liste des Clients :</h1>
            
            <form action="ClientServlet" method="GET" class="search-container">
                <input type="hidden" name="action" value="search">
                <input type="text" name="critere" class="search-input" placeholder="Nom ou Tel..." required>
                <button type="submit" class="btn-search">Rechercher</button>
                <!-- Rafraîchir redirige vers la liste complète via la Servlet -->
                <a href="ClientServlet?action=list" class="btn-refresh">Rafraîchir</a>
            </form>

            <a href="ajouter_client.jsp" class="btn-add">+ Ajouter un client</a>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Noms</th>
                        <th>Numéro Tel</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Récupération de la liste typée Client depuis la requête
                        List<Client> clients = (List<Client>) request.getAttribute("listeClients");

                        if (clients == null || clients.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="4" class="no-data-cell">Aucun client trouvé</td>
                        </tr>
                    <%
                        } else {
                            for (Client c : clients) {
                    %>
                        <tr>
                            <td><%= c.getIdcli() %></td>
                            <td><%= c.getNom() %></td>
                            <td><%= c.getNumtel() %></td>
                            <td>
                                <% 
                                    String critere = request.getParameter("critere");
                                    // Les boutons ne disparaissent QUE si on a vraiment écrit quelque chose
                                    if (critere == null || critere.trim().isEmpty()) { 
                                %>
                                    <a href="ClientServlet?action=edit&id=<%= c.getIdcli() %>" class="btn-edit">Modifier</a>
                                    <a href="ClientServlet?action=delete&id=<%= c.getIdcli() %>" class="btn-delete" onclick="return confirm('Supprimer ?');">Supprimer</a>
                                <% } else { %>
                                    <span style="color: #bdc3c7; font-style: italic;">Modification indisponible</span>
                                <% } %>
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