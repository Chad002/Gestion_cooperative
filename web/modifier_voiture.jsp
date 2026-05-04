<%@page import="com.cooperative.model.Voiture"%>
<%@page import="com.cooperative.dao.VoitureDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    VoitureDAO dao = new VoitureDAO();
    Voiture v = dao.getVoitureById(id);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Modifier Voiture</title>
    <style>
        body { font-family: Arial; background: #f4f7f6; padding: 50px; }
        .form-container { background: white; padding: 30px; max-width: 500px; margin: auto; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; }
        .btn-save { background: #3498db; color: white; border: none; padding: 10px 20px; cursor: pointer; width: 100%; font-weight: bold; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Modifier la voiture</h2>
        <form action="VoitureServlet" method="POST">
            <!-- On cache l'action pour que la Servlet sache qu'on modifie -->
            <input type="hidden" name="action" value="update">
            
            <label>Immatriculation (Non modifiable)</label>
            <input type="text" name="immatriculation" value="<%= v.getImmatriculation() %>" readonly>
            
            <label>Désignation</label>
            <input type="text" name="designation" value="<%= v.getDesignation() %>" required>
            
            <label>Type</label>
            <select name="type">
                <option value="VIP" <%= v.getType().equals("VIP") ? "selected" : "" %>>VIP</option>
                <option value="Premium" <%= v.getType().equals("Premium") ? "selected" : "" %>>Premium</option>
                <option value="Simple" <%= v.getType().equals("Simple") ? "selected" : "" %>>Simple</option>
            </select>
            
            <label>Nombre de places</label>
            <input type="number" name="places" value="<%= v.getPlaces() %>" required>
            
            <label>Frais (Ar)</label>
            <input type="number" name="frais" value="<%= (int)v.getFrais() %>" required>
            
            <button type="submit" class="btn-save">Enregistrer les modifications</button>
            <a href="gestion_voitures.jsp" style="display:block; text-align:center; margin-top:10px;">Annuler</a>
        </form>
    </div>
</body>
</html>