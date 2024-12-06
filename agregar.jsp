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
            <a href="movimientos.jsp">Ver movimientos de Productos</a>
            <a href="reportes.jsp">Reportes</a>
        </div>
        <h1>Agregar Producto</h1>

        <form method="post">
            <input type="text" name="nombre" placeholder="Nombre del producto" required>
            <input type="number" name="cantidad" placeholder="Cantidad" required>
            <input type="number" step="0.01" name="precio" placeholder="Precio" required>
            <input type="text" name="descripcion" placeholder="Descripción" required>
            <input type="text" name="categoria" placeholder="Categoría" required>
            <input type="text" name="imagen_url" placeholder="URL de la imagen (opcional)">
            <input type="submit" value="Guardar">
        </form>

        <%
            // Verificar si se envió el formulario
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String nombre = request.getParameter("nombre");
                String cantidadStr = request.getParameter("cantidad");
                String precioStr = request.getParameter("precio");
                String descripcion = request.getParameter("descripcion");
                String categoria = request.getParameter("categoria");
                String imagenUrl = request.getParameter("imagen_url");

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
                        String sql = "INSERT INTO productos (nombre, cantidad, precio, descripcion, categoria, imagen_url) VALUES (?, ?, ?, ?, ?, ?)";
                        pstmt = connection.prepareStatement(sql);
                        pstmt.setString(1, nombre);
                        pstmt.setInt(2, cantidad);
                        pstmt.setDouble(3, precio);
                        pstmt.setString(4, descripcion);
                        pstmt.setString(5, categoria);
                        pstmt.setString(6, imagenUrl.isEmpty() ? null : imagenUrl);  // Si la URL de la imagen está vacía, se asigna NULL

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