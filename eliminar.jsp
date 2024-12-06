<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Eliminar Producto</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <div class="navbar">
            <a href="index.jsp">Inicio</a>
            <a href="listar.jsp">Listar Productos</a>
            <a href="movimientos.jsp">Ver movimientos de Productos</a>
            <a href="reportes.jsp">Reportes</a>
        </div>
        <h1>Eliminar Producto</h1>

        <%
            // Obtener el ID del producto desde la URL
            String productIdStr = request.getParameter("id");
            int productId = Integer.parseInt(productIdStr);

            // Variables para la base de datos
            Connection connection = null;
            PreparedStatement stmt = null;
            String url = "jdbc:mysql://localhost:3306/inventario";
            String user = "root";
            String password = "";

            try {
                // Establecer conexión
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, password);

                // Eliminar producto
                String query = "DELETE FROM productos WHERE id = ?";
                stmt = connection.prepareStatement(query);
                stmt.setInt(1, productId);
                int rowsDeleted = stmt.executeUpdate();

                if (rowsDeleted > 0) {
                    out.println("<p style='color: green;'>Producto eliminado exitosamente.</p>");
                } else {
                    out.println("<p style='color: red;'>No se encontró el producto.</p>");
                }

            } catch (Exception e) {
                out.println("<p style='color: red;'>Error al eliminar el producto: " + e.getMessage() + "</p>");
            } finally {
                // Cerrar recursos
                try {
                    if (stmt != null) stmt.close();
                    if (connection != null) connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>

        <footer>&copy; 2024 Sistema de Inventario</footer>
    </body>
</html>
