<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registro de Usuario</title>
    <link rel="stylesheet" type="text/css" href="styles_login.css">
</head>
<body>
    <div class="login-container">
        <h1>Registro de Usuario</h1>
        <form method="post">
            <input type="text" name="username" placeholder="Usuario" required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <input type="submit" name="register" value="Registrar">
        </form>
        <p>¿Ya tienes una cuenta? <a href="login.jsp">Inicia sesión aquí</a></p>
    </div>

    <%
        // Lógica de registro de usuario
        if (request.getParameter("register") != null) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            String url = "jdbc:mysql://localhost:3306/inventario";
            String dbUser = "root"; // Cambia por tu usuario de MySQL
            String dbPassword = ""; // Cambia por tu contraseña de MySQL

            Connection connection = null;
            PreparedStatement pstmt = null;

            try {
                // Conectar a la base de datos
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, dbUser, dbPassword);

                // Insertar nuevo usuario en la base de datos
                String query = "INSERT INTO usuarios (username, password) VALUES (?, ?)";
                pstmt = connection.prepareStatement(query);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.executeUpdate();

                // Registro exitoso, redirigir a login.jsp
                out.println("<p style='color:green;'>Registro exitoso. <a href='login.jsp'>Inicia sesión aquí</a></p>");
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                // Cerrar recursos
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    %>
</body>
</html>
