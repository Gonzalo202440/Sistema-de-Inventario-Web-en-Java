<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Sistema de Inventario</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <div class="navbar">
            <a href="index.jsp">Inicio</a>
            <a href="listar.jsp">Listar Productos</a>
            <a href="agregar.jsp">Agregar Producto</a>
            <a href="movimientos.jsp">Ver movimientos de Productos</a>
            <a href="reportes.jsp">Reportes</a>
            <form action="login.jsp" method="get" class="logout-form">
                <input type="submit" value="Cerrar Sesión" class="logout-button">
            </form>
        </div>
        <h1>Bienvenido al Sistema de Inventario</h1>
        <footer>&copy; 2024 Sistema de Inventario</footer>
    </body>
</html>
