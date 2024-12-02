<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Agregar Producto</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">Inicio</a>
        <a href="listar.jsp">Listar Productos</a>
    </div>
    <h1>Agregar Producto</h1>
    
    <form method="post">
        <input type="text" name="nombre" placeholder="Nombre del producto" required>
        <input type="number" name="cantidad" placeholder="Cantidad" required>
        <input type="number" step="0.01" name="precio" placeholder="Precio" required>
        <input type="submit" value="Guardar">
    </form>

    <%
        // Verificar si se envió el formulario
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String nombre = request.getParameter("nombre");
            String cantidadStr = request.getParameter("cantidad");
            String precioStr = request.getParameter("precio");

            // Validar los valores ingresados
            if (nombre != null && !nombre.isEmpty() && cantidadStr != null && precioStr != null) {
                int cantidad = Integer.parseInt(cantidadStr);
                double precio = Double.parseDouble(precioStr);

                // Conexión a la base de datos
                String url = "jdbc:mysql://localhost:3306/inventario";
                String user = "root";  // Cambia según tu configuración
                String password = "";  // Cambia según tu configuración
                Connection connection = null;
                PreparedStatement pstmt = null;

                try {
                    // Cargar el controlador de MySQL
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connection = DriverManager.getConnection(url, user, password);

                    // Preparar la consulta SQL
                    String sql = "INSERT INTO productos (id, nombre, cantidad, precio) VALUES (NULL, ?, ?, ?)";
                    pstmt = connection.prepareStatement(sql);
                    pstmt.setString(1, nombre);
                    pstmt.setInt(2, cantidad);
                    pstmt.setDouble(3, precio);

                    // Ejecutar la consulta
                    int filas = pstmt.executeUpdate();

                    if (filas > 0) {
                        out.println("<p style='color: green; text-align: center;'>Producto agregado exitosamente.</p>");
                    } else {
                        out.println("<p style='color: red; text-align: center;'>Error al agregar el producto.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p style='color: red; text-align: center;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Cerrar recursos
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            } else {
                out.println("<p style='color: red; text-align: center;'>Por favor, completa todos los campos.</p>");
            }
        }
    %>

    <footer>&copy; 2024 Sistema de Inventario</footer>
</body>
</html>
