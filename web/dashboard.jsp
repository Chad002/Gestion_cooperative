<%-- 
    Document   : dashboard
    Created on : 2 mai 2026, 00:53:22
    Author     : RUSS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>COOP-TRANS - Tableau de Bord</title>
        <style>
        /* Correction globale pour que les dimensions soient respectées */
        * { box-sizing: border-box; } 

        body { margin: 0; font-family: Arial, sans-serif; display: flex; background-color: #f4f7f6; }

        .sidebar { width: 250px; height: 100vh; background-color: #2c3e50; color: white; position: fixed; }
        .sidebar h2 { text-align: center; padding: 20px; border-bottom: 1px solid #34495e; margin: 0; }

        /* Correction du bouton pour qu'il ne dépasse plus */
        .nav-btn { 
            display: block; 
            width: 100%; 
            padding: 15px 20px; /* Un peu plus d'espace à gauche pour l'icône */
            border: none; 
            background: none; 
            color: white; 
            text-align: left; 
            cursor: pointer; 
            font-size: 16px; 
            transition: 0.3s;
            text-decoration: none;
            white-space: nowrap; /* Empêche le texte de revenir à la ligne */
            overflow: hidden;    /* Sécurité anti-débordement */
        }

        .nav-btn:hover { background-color: #34495e; }
        .active { background-color: #3498db; width: 100%; }

        .main-content { margin-left: 250px; padding: 30px; width: calc(100% - 250px); }
        .header { margin-bottom: 30px; }

        .stats-container { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .card { 
            background: white; padding: 20px; border-radius: 8px; 
            text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
        }
        .card h3 { color: #7f8c8d; font-size: 14px; margin-bottom: 10px; margin-top: 0; }
        .card p { color: #2980b9; font-size: 28px; font-weight: bold; margin: 0; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>COOP-TRANS</h2>
        <a href="dashboard" class="nav-btn">🏠 Tableau de Bord</a>
        <!-- Nouveau bouton vers la gestion -->
        <a href="gestion_voitures.jsp" class="nav-btn">🚌 Gestion Voitures</a>
<!--        <a href="gestion_clients.jsp" class="nav-btn">👥 Gestion Clients</a>-->
        <a href="ClientServlet?action=list" class="nav-btn">👥 Gestion Clients</a>
        <a href="PlaceServlet?action=list" class="nav-btn">🪑 Gestion Places</a>
        <a href="ReservationServlet?action=list" class="nav-btn">📅 Réservations</a>
        <a href="PdfServlet" class="nav-btn" style="background-color: #3498db;">📄 Générer PDF</a>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Tableau de Bord</h1>
        </div>

        <div class="stats-container">
            <div class="card">
                <h3>Total Voitures</h3>
                <p>${totalVoitures}</p>
            </div>
            <div class="card">
                <h3>Clients Inscrits</h3>
                <p>${clientsInscrits}</p>
            </div>
            <div class="card">
                <h3>Réservations Jour</h3>
                <p>${reservationsJour}</p>
            </div>
            <div class="card">
                <h3>Recettes (Ar)</h3>
                <p>${recettes}</p>
            </div>
        </div>
    </div>

</body>
</html>
