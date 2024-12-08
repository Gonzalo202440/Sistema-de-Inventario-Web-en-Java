<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Inicio de Sesión</title>
        <link rel="stylesheet" type="text/css" href="styles_login.css">
    </head>
    <body>
        <div class="login-container">
            <h1>Inicio de Sesión</h1>
            <form method="post">
                <input type="text" name="username" placeholder="Usuario" required>
                <input type="password" name="password" placeholder="Contraseña" required>
                <input type="submit" name="login" value="Iniciar Sesión">
            </form>
            <p>¿No tienes una cuenta? <a href="registro.jsp">Regístrate aquí</a></p>
        </div>

        <%
            // Lógica de inicio de sesión
            if (request.getParameter("login") != null) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                String url = "jdbc:mysql://localhost:3306/inventario";
                String dbUser = "root"; // Cambia por tu usuario de MySQL
                String dbPassword = ""; // Cambia por tu contraseña de MySQL

                Connection connection = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // Conectar a la base de datos
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connection = DriverManager.getConnection(url, dbUser, dbPassword);

                    // Verificar las credenciales del usuario
                    String query = "SELECT * FROM usuarios WHERE username = ? AND password = ?";
                    pstmt = connection.prepareStatement(query);
                    pstmt.setString(1, username);
                    pstmt.setString(2, password);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        // Credenciales válidas, redirigir a index.jsp
                        response.sendRedirect("index.jsp");
                    } else {
                        // Credenciales inválidas
                        out.println("<p style='color:red;'>Usuario o contraseña incorrectos.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Cerrar recursos
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        %>
    </body>
</html>
