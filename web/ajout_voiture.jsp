<%-- 
    Document   : ajout_voiture
    Created on : 2 mai 2026, 02:04:55
    Author     : RUSS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Ajouter une Voiture</title>
    <style>
        body { background-color: #f4f7f6; font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .form-card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 450px; }
        h2 { text-align: center; color: #2c3e50; margin-bottom: 30px; }
        
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #7f8c8d; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; }
        
        .btn-container { display: flex; gap: 10px; margin-top: 20px; }
        .btn-save { flex: 2; background-color: #27ae60; color: white; border: none; padding: 12px; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-back { flex: 1; background-color: #95a5a6; color: white; border: none; padding: 12px; border-radius: 5px; cursor: pointer; text-align: center; text-decoration: none; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>Nouvelle Voiture</h2>
        <form action="VoitureServlet" method="POST">
            <div class="form-group">
                <label>Immatriculation</label>
                <input type="text" name="immatriculation" required>
            </div>
            <div class="form-group">
                <label>Désignation</label>
                <input type="text" name="designation" required>
            </div>
            <div class="form-group">
                <label>Type</label>
                <select name="type">
                    <option value="Simple">Simple</option>
                    <option value="Premium">Premium</option>
                    <option value="VIP">VIP</option>
                </select>
            </div>
            <div class="form-group">
                <label>Nombre de places</label>
                <input type="number" name="places" required>
            </div>
            <div class="form-group">
                <label>Frais (Ar)</label>
                <input type="number" name="frais" required>
            </div>
            
            <div class="btn-container">
                <button type="submit" class="btn-save">Enregistrer</button>
                <a href="gestion_voitures.jsp" class="btn-back">Retour</a>
            </div>
        </form>
    </div>
</body>
</html>