<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // On récupère l'objet client envoyé par la Servlet
    com.cooperative.model.Client c = (com.cooperative.model.Client) request.getAttribute("client");
    if (c == null) {
        response.sendRedirect("ClientServlet?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Modifier le Client</title>
    <style>
        body { background-color: #f4f7f6; font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .form-card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 450px; }
        h2 { text-align: center; color: #2c3e50; margin-bottom: 30px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #7f8c8d; }
        input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; }
        .id-field { background-color: #eee; cursor: not-allowed; }
        .btn-container { display: flex; gap: 10px; margin-top: 20px; }
        .btn-save { flex: 2; background-color: #2980b9; color: white; border: none; padding: 12px; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-back { flex: 1; background-color: #95a5a6; color: white; border: none; padding: 12px; border-radius: 5px; cursor: pointer; text-align: center; text-decoration: none; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2>Modifier Client</h2>
        <form action="ClientServlet" method="POST">
            <input type="hidden" name="action" value="update">
            <div class="form-group">
                <label>ID (Non modifiable)</label>
                <input type="text" name="idcli" value="<%= c.getIdcli() %>" class="id-field" readonly>
            </div>
            <div class="form-group">
                <label>Nom complet</label>
                <input type="text" name="nom" value="<%= c.getNom() %>" required>
            </div>
            <div class="form-group">
                <label>Numéro de téléphone</label>
                <input type="text" name="numtel" value="<%= c.getNumtel() %>" required>
            </div>
            <div class="btn-container">
                <button type="submit" class="btn-save">Enregistrer les modifications</button>
                <a href="ClientServlet?action=list" class="btn-back">Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>