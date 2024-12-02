<%@ page import="java.sql.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/inventario";
    String user = "root";
    String password = "";
    Connection connection = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, password);
    } catch (Exception e) {
        out.println("Error al conectar con la base de datos: " + e.getMessage());
    }
%>
