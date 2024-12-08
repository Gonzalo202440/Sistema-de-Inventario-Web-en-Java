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
            <a href="movimientos.jsp">Ver movimientos de Productos</a>
            <a href="reportes.jsp">Reportes</a>
        </div>
        <h1>Lista de Productos</h1>

        <table>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Cantidad</th>
                <th>Precio</th>
                <th>Descripción</th>
                <th>Categoría</th>
                <th>Imagen</th>
                <th>Fecha Agregado</th>
                <th>Acciones</th>
            </tr>

            <%
                // Declarar e inicializar las variables
                Connection connection = null;
                Statement stmt = null;
                ResultSet rs = null;
                String url = "jdbc:mysql://localhost:3306/inventario";  // Asegúrate de ajustar la URL de la base de datos
                String user = "root";  // Cambia este valor según tu configuración
                String password = "";  // Cambia este valor según tu configuración

                try {
                    // Cargar el controlador de MySQL
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connection = DriverManager.getConnection(url, user, password);

                    // Preparar la consulta SQL
                    String query = "SELECT * FROM productos";
                    stmt = connection.createStatement();
                    rs = stmt.executeQuery(query);

                    // Mostrar los resultados
                    while (rs.next()) {
            %>

            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("nombre") %></td>
                <td><%= rs.getInt("cantidad") %></td>
                <td><%= rs.getDouble("precio") %></td>
                <td><%= rs.getString("descripcion") %></td>
                <td><%= rs.getString("categoria") %></td>
                <td>
                    <% if (rs.getString("imagen_url") != null) { %>
                    <img src="<%= rs.getString("imagen_url") %>" alt="Imagen del Producto" width="100">
                    <% } else { %>
                    Sin imagen
                    <% } %>
                </td>
                <td><%= rs.getTimestamp("fecha_agregado") %></td>
                <td>
                    <a href="editar.jsp?id=<%= rs.getInt("id") %>">Editar</a> |
                    <a href="eliminar.jsp?id=<%= rs.getInt("id") %>">Eliminar</a>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='9'>Error al cargar los productos: " + e.getMessage() + "</td></tr>");
                } finally {
                    // Cerrar los recursos
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (connection != null) connection.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </table>

        <footer>&copy; 2024 Sistema de Inventario</footer>
    </body>
</html>
