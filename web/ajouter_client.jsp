<%-- 
    Document   : ajouter_client
    Created on : 2 mai 2026
    Author     : RUSS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Ajouter un Client</title>
    <style>
        body { background-color: #f4f7f6; font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .form-card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 450px; }
        h2 { text-align: center; color: #2c3e50; margin-bottom: 30px; }
        
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; color: #7f8c8d; font-weight: bold; }
        input { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; }
        
        .btn-container { display: flex; gap: 10px; margin-top: 30px; }
        .btn-save { flex: 2; background-color: #27ae60; color: white; border: none; padding: 12px; border-radius: 5px; cursor: pointer; font-weight: bold; font-size: 16px; }
        .btn-back { flex: 1; background-color: #95a5a6; color: white; border: none; padding: 12px; border-radius: 5px; cursor: pointer; text-align: center; text-decoration: none; font-weight: bold; }
        .btn-save:hover { background-color: #219150; }
        .btn-back:hover { background-color: #7f8c8d; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>Nouveau Client</h2>
        
        <!-- On dirige vers ClientServlet avec l'action "add" -->
        <form action="ClientServlet?action=add" method="POST">
            
            <div class="form-group">
                <label>Nom complet</label>
                <input type="text" name="nom" placeholder="Ex: Rakoto Madison" required>
            </div>
            
            <div class="form-group">
                <label>Numéro de téléphone</label>
                <input type="text" name="numtel" placeholder="Ex: 034 33 888 12" required>
            </div>
            
            <div class="btn-container">
                <button type="submit" class="btn-save">Enregistrer</button>
                <a href="ClientServlet?action=list" class="btn-back">Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>