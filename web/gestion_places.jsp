<%@page import="java.util.Map"%>
<%@page import="com.cooperative.model.Place"%>
<%@page import="com.cooperative.model.Voiture"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>COOP-TRANS - Gestion Places</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: Arial, sans-serif; display: flex; background-color: #f4f7f6; }
        
        /* Sidebar identique à Gestion Clients */
        .sidebar { width: 250px; height: 100vh; background-color: #2c3e50; color: white; position: fixed; }
        .sidebar h2 { text-align: center; padding: 20px; border-bottom: 1px solid #34495e; margin: 0; }
        .nav-btn { display: block; width: 100%; padding: 15px 20px; color: white; text-decoration: none; transition: 0.3s; }
        .nav-btn:hover { background-color: #34495e; }
        
        .main-content { margin-left: 250px; padding: 30px; width: calc(100% - 250px); }
        
        /* Header & Filtres */
        .header-section { display: flex; flex-direction: column; margin-bottom: 20px; border-bottom: 2px solid #ddd; padding-bottom: 15px; }
        .filter-row { display: flex; align-items: center; gap: 15px; margin-top: 10px; }
        
        .select-input { padding: 8px; border: 1px solid #ccc; border-radius: 4px; width: 300px; }
        .type-badge { background-color: #ecf0f1; color: #2c3e50; padding: 8px 15px; border-radius: 4px; font-weight: bold; border: 1px solid #bdc3c7; }
        
        .btn-search { background-color: #3498db; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-refresh { background-color: #e67e22; color: white; text-decoration: none; padding: 8px 15px; border-radius: 4px; font-weight: bold; font-size: 14px; }

        /* Blocs de Statistiques (KPI) */
        .stats-container { display: flex; gap: 20px; margin-bottom: 25px; }
        .stat-card { flex: 1; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; }
        .stat-card h3 { margin: 0; color: #7f8c8d; font-size: 14px; text-transform: uppercase; }
        .stat-card p { margin: 10px 0 0; font-size: 24px; font-weight: bold; color: #2c3e50; }

        /* Tableau avec Scrollbar */
        .table-wrapper { background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
                         max-height: 450px; overflow-y: auto; } /* Scroll après ~10 lignes */
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #2c3e50; color: white; padding: 15px; position: sticky; top: 0; }
        td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; font-weight: bold; }
        
        /* Couleurs demandées */
        .occ-non { color: #27ae60; } /* Vert */
        .occ-oui { color: #e74c3c; } /* Rouge */
        
        .no-data-cell { padding: 40px; color: #e74c3c; font-weight: bold; font-style: italic; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>COOP-TRANS</h2>
        <a href="dashboard" class="nav-btn">🏠 Tableau de Bord</a>
        <a href="gestion_voitures.jsp" class="nav-btn">🚌 Gestion Voitures</a>
        <a href="ClientServlet?action=list" class="nav-btn">👥 Gestion Clients</a>
        <a href="PlaceServlet?action=list" class="nav-btn" style="background-color: #3498db;">🪑 Gestion Places</a>
        <a href="ReservationServlet?action=list" class="nav-btn">📅 Réservations</a>
    </div>

    <div class="main-content">
        <div class="header-section">
            <h1>Places libres :</h1>
            <p>Visualisez les places disponibles d'une voiture.</p>
            
            <form action="PlaceServlet" method="GET" class="filter-row">
                <input type="hidden" name="action" value="search">
                
                <label>Choisis une voiture :</label>
                <select name="idvoit" class="select-input" required>
                    <option value="">-- Sélectionner --</option>
                    <% 
                        List<Voiture> voitures = (List<Voiture>) request.getAttribute("listeVoitures");
                        String idSelected = (String) request.getAttribute("idSelected");
                        if(voitures != null) {
                            for(Voiture v : voitures) {
                                String selected = (v.getImmatriculation().equals(idSelected)) ? "selected" : "";
                    %>
                        <option value="<%= v.getImmatriculation() %>" <%= selected %>>
                            <%= v.getImmatriculation() %> - <%= v.getDesignation() %> - <%= v.getPlaces() %> places
                        </option>
                    <% } } %>
                </select>

                <% String type = (String) request.getAttribute("typeVoiture"); 
                   if(type != null) { %>
                    <div class="type-badge"><%= type.toUpperCase() %></div>
                <% } %>

                <button type="submit" class="btn-search">Rechercher</button>
                <a href="PlaceServlet?action=list" class="btn-refresh">Rafraîchir</a>
            </form>
        </div>

        <!-- Blocs de Statistiques -->
        <% Map<String, String> stats = (Map<String, String>) request.getAttribute("stats"); %>
        <div class="stats-container">
            <div class="stat-card">
                <h3>Total</h3>
                <p><%= (stats != null) ? stats.get("total") : "0" %></p>
            </div>
            <div class="stat-card">
                <h3>Occupées</h3>
                <p style="color: #e74c3c;"><%= (stats != null) ? stats.get("occupees") : "0" %></p>
            </div>
            <div class="stat-card">
                <h3>Libres</h3>
                <p style="color: #27ae60;"><%= (stats != null) ? stats.get("libres") : "0" %></p>
            </div>
        </div>

        <!-- Tableau des places -->
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Nombre de place</th>
                        <th>Occupations</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Place> places = (List<Place>) request.getAttribute("listePlaces");
                        if (places == null || places.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="2" class="no-data-cell">Aucune donnée</td>
                        </tr>
                    <%
                        } else {
                            for (Place p : places) {
                                String colorClass = p.getOccupation().equalsIgnoreCase("oui") ? "occ-oui" : "occ-non";
                    %>
                        <tr>
                            <td><%= p.getNumPlace() %></td>
                            <td class="<%= colorClass %>"><%= p.getOccupation().substring(0, 1).toUpperCase() + p.getOccupation().substring(1) %></td>
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
