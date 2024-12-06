<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Detalle de Movimientos</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <style>
            /* Estilos para la tabla */
            table {
                width: 100%;
                margin-bottom: 80px; /* Espacio debajo de la tabla */
            }

            footer {
                margin-top: 50px;
                padding-top: 20px;
                border-top: 2px solid #ddd;
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <a href="index.jsp">Inicio</a>
            <a href="listar.jsp">Listar Productos</a>
            <a href="movimientos.jsp">Registrar Movimiento</a>
            <a href="reportes.jsp">Reportes</a>
        </div>
        <h1>Detalle de Movimientos</h1>

        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Entradas</th>
                    <th>Salidas</th>
                    <th>Cantidad Actual</th>
                    <th>Fecha Última Actualización</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conn = null;
                    Statement stmtProductos = null;
                    ResultSet rsProductos = null;

                    String url = "jdbc:mysql://localhost:3306/inventario";
                    String user = "root";
                    String password = "";

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, user, password);
                        stmtProductos = conn.createStatement();

                        // Consultar la tabla productos para obtener las entradas, salidas y cantidades actuales
                        String queryProductos = "SELECT nombre, entradas, salidas, cantidad, fecha_actualizacion FROM productos";
                        rsProductos = stmtProductos.executeQuery(queryProductos);

                        while (rsProductos.next()) {
                %>
                <tr>
                    <td><%= rsProductos.getString("nombre") %></td>
                    <td><%= rsProductos.getInt("entradas") %></td>
                    <td><%= rsProductos.getInt("salidas") %></td>
                    <td><%= rsProductos.getInt("cantidad") %></td>
                    <td><%= rsProductos.getTimestamp("fecha_actualizacion") %></td>
                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        out.println("Error al cargar los productos: " + e.getMessage());
                    } finally {
                        if (rsProductos != null) rsProductos.close();
                        if (stmtProductos != null) stmtProductos.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>        
        </table>

        <footer>&copy; 2024 Sistema de Inventario</footer>
    </body>
</html>
