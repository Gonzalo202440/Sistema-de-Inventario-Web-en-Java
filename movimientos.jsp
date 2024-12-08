<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Registrar Movimiento</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <style>
            /* Estilos para la tabla */
            table {
                width: 100%;
                margin-bottom: 80px;
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
            <a href="detalleMovimientos.jsp">Detalle de Movimientos</a>
            <a href="reportes.jsp">Reportes</a>
        </div>
        <h1>Registrar Movimiento</h1>

        <form method="post" action="movimientos.jsp">
            <label>Producto:</label>
            <select name="producto_id">
                <% 
                    // Conexión a la base de datos para obtener los productos
                    Connection connection = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    String url = "jdbc:mysql://localhost:3306/inventario";
                    String user = "root";
                    String password = "";

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connection = DriverManager.getConnection(url, user, password);
                        stmt = connection.createStatement();
                        rs = stmt.executeQuery("SELECT id, nombre FROM productos");

                        while (rs.next()) {
                %>
                <option value="<%= rs.getInt("id") %>"><%= rs.getString("nombre") %></option>
                <% 
                        }
                    } catch (Exception e) {
                        out.println("Error al cargar los productos: " + e.getMessage());
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (connection != null) connection.close();
                    }
                %>
            </select>

            <label>Tipo de Movimiento:</label>
            <select name="tipo">
                <option value="ENTRADA">Entrada</option>
                <option value="SALIDA">Salida</option>
            </select>

            <label>Cantidad:</label>
            <input type="number" name="cantidad" required>

            <button type="submit">Registrar Movimiento</button>
        </form>

        <% 
            if (request.getMethod().equalsIgnoreCase("POST")) {
                int productoId = Integer.parseInt(request.getParameter("producto_id"));
                String tipo = request.getParameter("tipo");
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));

                Connection conn2 = null;
                PreparedStatement pstmtProducto = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn2 = DriverManager.getConnection(url, user, password);

                    // Actualizar la cantidad y las entradas/salidas en productos
                    String actualizarSQL = tipo.equals("ENTRADA") 
                        ? "UPDATE productos SET cantidad = cantidad + ?, entradas = entradas + ?, fecha_actualizacion = NOW() WHERE id = ?"
                        : "UPDATE productos SET cantidad = cantidad - ?, salidas = salidas + ?, fecha_actualizacion = NOW() WHERE id = ?";

                    pstmtProducto = conn2.prepareStatement(actualizarSQL);
                    pstmtProducto.setInt(1, cantidad);
                    pstmtProducto.setInt(2, cantidad);
                    pstmtProducto.setInt(3, productoId);
                    pstmtProducto.executeUpdate();

                    out.println("<p style='color: green;'>Movimiento registrado correctamente.</p>");
                } catch (Exception e) {
                    out.println("<p style='color: red;'>Error al registrar el movimiento: " + e.getMessage() + "</p>");
                } finally {
                    if (pstmtProducto != null) pstmtProducto.close();
                    if (conn2 != null) conn2.close();
                }
            }
        %>

        <footer>&copy; 2024 Sistema de Inventario</footer>
    </body>
</html>
