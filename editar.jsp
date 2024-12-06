<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Editar Producto</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <div class="navbar">
            <a href="index.jsp">Inicio</a>
            <a href="listar.jsp">Listar Productos</a>
            <a href="movimientos.jsp">Ver movimientos de Productos</a>
            <a href="reportes.jsp">Reportes</a>
        </div>
        <h1>Editar Producto</h1>

        <%
            // Obtener el ID del producto desde la URL
            String productIdStr = request.getParameter("id");
            int productId = Integer.parseInt(productIdStr);

            // Variables para la base de datos
            String nombre = "";
            int cantidad = 0;
            double precio = 0.0;
            String descripcion = "";
            String categoria = "";
            String imagenUrl = "";

            // Conexión a la base de datos
            String url = "jdbc:mysql://localhost:3306/inventario";
            String user = "root";  // Cambia según tu configuración
            String password = "";  // Cambia según tu configuración
            Connection connection = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                // Cargar el controlador de MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, password);

                // Obtener los datos del producto
                String query = "SELECT * FROM productos WHERE id = ?";
                stmt = connection.prepareStatement(query);
                stmt.setInt(1, productId);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    nombre = rs.getString("nombre");
                    cantidad = rs.getInt("cantidad");
                    precio = rs.getDouble("precio");
                    descripcion = rs.getString("descripcion");
                    categoria = rs.getString("categoria");
                    imagenUrl = rs.getString("imagen_url");
                }

            } catch (Exception e) {
                out.println("<p style='color: red;'>Error al cargar los datos del producto: " + e.getMessage() + "</p>");
            } finally {
                // Cerrar recursos
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (connection != null) connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>

        <!-- Formulario de edición -->
        <form method="post">
            <input type="text" name="nombre" value="<%= nombre %>" placeholder="Nombre del producto" required>
            <input type="number" name="cantidad" value="<%= cantidad %>" placeholder="Cantidad" required>
            <input type="number" step="0.01" name="precio" value="<%= precio %>" placeholder="Precio" required>
            <input type="text" name="descripcion" value="<%= descripcion %>" placeholder="Descripción" required>
            <input type="text" name="categoria" value="<%= categoria %>" placeholder="Categoría" required>
            <input type="text" name="imagen_url" value="<%= imagenUrl %>" placeholder="URL de la imagen (opcional)">
            <input type="submit" value="Actualizar">
        </form>

        <%
            // Si el formulario es enviado
            if (request.getMethod().equalsIgnoreCase("POST")) {
                // Obtener los datos del formulario con nombres diferentes
                String nuevoNombre = request.getParameter("nombre");
                String nuevaCantidadStr = request.getParameter("cantidad");
                String nuevoPrecioStr = request.getParameter("precio");
                String nuevaDescripcion = request.getParameter("descripcion");
                String nuevaCategoria = request.getParameter("categoria");
                String nuevaImagenUrl = request.getParameter("imagen_url");

                // Validar los valores ingresados
                if (nuevoNombre != null && !nuevoNombre.isEmpty() && nuevaCantidadStr != null && nuevoPrecioStr != null) {
                    int nuevaCantidad = Integer.parseInt(nuevaCantidadStr);
                    double nuevoPrecio = Double.parseDouble(nuevoPrecioStr);

                    // Conexión a la base de datos
                    Connection nuevaConnection = null;
                    PreparedStatement nuevaPstmt = null;

                    try {
                        // Cargar el controlador de MySQL
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        nuevaConnection = DriverManager.getConnection(url, user, password);

                        // Preparar la consulta SQL para actualizar el producto
                        String sql = "UPDATE productos SET nombre = ?, cantidad = ?, precio = ?, descripcion = ?, categoria = ?, imagen_url = ? WHERE id = ?";
                        nuevaPstmt = nuevaConnection.prepareStatement(sql);
                        nuevaPstmt.setString(1, nuevoNombre);
                        nuevaPstmt.setInt(2, nuevaCantidad);
                        nuevaPstmt.setDouble(3, nuevoPrecio);
                        nuevaPstmt.setString(4, nuevaDescripcion);
                        nuevaPstmt.setString(5, nuevaCategoria);
                        nuevaPstmt.setString(6, nuevaImagenUrl.isEmpty() ? null : nuevaImagenUrl);
                        nuevaPstmt.setInt(7, productId);

                        // Ejecutar la consulta
                        int filas = nuevaPstmt.executeUpdate();

                        if (filas > 0) {
                            out.println("<p style='color: green; text-align: center;'>Producto actualizado exitosamente.</p>");
                        } else {
                            out.println("<p style='color: red; text-align: center;'>Error al actualizar el producto.</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color: red; text-align: center;'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        // Cerrar recursos
                        try {
                            if (nuevaPstmt != null) nuevaPstmt.close();
                            if (nuevaConnection != null) nuevaConnection.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                } else {
                    out.println("<p style='color: red; text-align: center;'>Por favor, completa todos los campos.</p>");
                }
            }
        %>


        <footer>&copy; 2024 Sistema de Inventario</footer>
    </body>
</html>
