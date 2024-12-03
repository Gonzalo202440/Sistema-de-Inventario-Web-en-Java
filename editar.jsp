<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/inventario";
    String user = "root";  // Cambia por tu usuario de MySQL
    String password = "";  // Cambia por tu contraseña de MySQL
    Connection connection = null;
    Statement stmt = null;
    ResultSet rs = null;
    int id = Integer.parseInt(request.getParameter("id"));
    
    // Recuperar el producto con el ID
    String nombre = "";
    int cantidad = 0;
    double precio = 0.0;

    try {
        // Establecer la conexión
        connection = DriverManager.getConnection(url, user, password);

        // Consulta SQL para obtener el producto
        String query = "SELECT * FROM productos WHERE id = " + id;
        stmt = connection.createStatement();
        rs = stmt.executeQuery(query);

        if (rs.next()) {
            nombre = rs.getString("nombre");
            cantidad = rs.getInt("cantidad");
            precio = rs.getDouble("precio");
        }
    } catch (Exception e) {
        out.println("Error al recuperar los datos: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<h2>Editar Producto</h2>
<link rel="stylesheet" type="text/css" href="styles.css">
<form action="actualizar.jsp" method="post">
    <input type="hidden" name="id" value="<%= id %>">
    <input type="text" name="nombre" value="<%= nombre %>" required>
    <input type="number" name="cantidad" value="<%= cantidad %>" required>
    <input type="number" name="precio" value="<%= precio %>" step="0.01" required>
    <input type="submit" value="Actualizar">
</form>
