<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Lista de Productos</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <div class="navbar">
            <a href="index.jsp">Inicio</a>
            <a href="agregar.jsp">Agregar Producto</a>
        </div>
        <h1>Lista de Productos</h1>

        <table>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Cantidad</th>
                <th>Precio</th>
                <th>Acciones</th>
            </tr>

            <%
                // Conexión a la base de datos
                String url = "jdbc:mysql://localhost:3306/inventario";
                String user = "root";  // Cambia por tu usuario de MySQL
                String password = ""; // Cambia por tu contraseña de MySQL
                Connection connection = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    // Cargar el controlador de MySQL
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    // Establecer la conexión
                    connection = DriverManager.getConnection(url, user, password);

                    // Crear la consulta SQL
                    String query = "SELECT * FROM productos";
                    stmt = connection.createStatement();
                    rs = stmt.executeQuery(query);

                    // Iterar sobre los resultados y mostrarlos en la tabla
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("nombre") %></td>
                <td><%= rs.getInt("cantidad") %></td>
                <td><%= rs.getDouble("precio") %></td>
                <td>
                    <!-- Botones Editar y Eliminar con sus respectivas URLs -->
                    <a href="editar.jsp?id=<%= rs.getInt("id") %>">Editar</a> |
                    <a href="eliminar.jsp?id=<%= rs.getInt("id") %>">Eliminar</a>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5'>Error al cargar los productos: " + e.getMessage() + "</td></tr>");
                } finally {
                    // Cerrar recursos
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </table>

        <footer>&copy; 2024 Sistema de Inventario</footer>
    </body>
</html>
