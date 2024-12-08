<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Reportes y Análisis</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            /* Estilos CSS generales */
            body {
                font-family: Arial, sans-serif;
                line-height: 1.6;
                margin: 0;
                padding: 0;
                background-color: #f4f4f4;
                color: #333;
            }
            h1, h2 {
                text-align: center;
                color: #333;
            }
            table {
                width: 90%;
                margin: 20px auto;
                border-collapse: collapse;
                background: #fff;
            }
            table thead {
                background-color: #4CAF50;
                color: white;
            }
            table th, table td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: center;
            }
            table tbody tr:nth-child(even) {
                background-color: #f2f2f2;
            }
            .description {
                max-width: 90%;
                margin: 10px auto 20px;
                font-size: 1.1em;
                color: #555;
                text-align: center;
                font-style: italic;
                background: #e8f5e9;
                padding: 10px;
                border-radius: 5px;
                border-left: 4px solid #4CAF50;
            }
            canvas {
                max-width: 80%;
                margin: 20px auto;
                display: block;
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <a href="index.jsp">Inicio</a>
            <a href="listar.jsp">Listar Productos</a>
            <a href="movimientos.jsp">Ver movimientos de Productos</a>
            <a href="detalleMovimientos.jsp">Detalle de Movimientos</a>
        </div>

        <h1>Reportes y Análisis del Inventario</h1>

        <!-- Reportes de Niveles de Inventario -->
        <h2>Reportes de Niveles de Inventario</h2>
        <div class="description">
            Este reporte muestra la cantidad actual de productos en el inventario, junto con los niveles de stock mínimo y máximo definidos para cada uno, así como la fecha de la última actualización.
        </div>
        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Stock Mínimo</th>
                    <th>Stock Máximo</th>
                    <th>Última Actualización</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    String url = "jdbc:mysql://localhost:3306/inventario";
                    String user = "root";
                    String password = "";

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, user, password);
                        stmt = conn.createStatement();

                        // Consulta para obtener niveles de inventario
                        String query = "SELECT nombre, cantidad, stock_minimo, stock_maximo, fecha_actualizacion FROM productos";
                        rs = stmt.executeQuery(query);

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getInt("cantidad") %></td>
                    <td><%= rs.getInt("stock_minimo") %></td>
                    <td><%= rs.getInt("stock_maximo") %></td>
                    <td><%= rs.getTimestamp("fecha_actualizacion") %></td>
                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        out.println("Error al cargar los productos: " + e.getMessage());
                    } finally {
                        // Cerrar la conexión
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>        
        </table>

        <!-- Análisis de Productos Más Vendidos -->
        <h2>Análisis de Productos Más Vendidos</h2>
        <div class="description">
            Este reporte identifica los productos más vendidos, ordenados según el volumen total vendido. Ideal para evaluar la demanda de los productos más populares.
        </div>
        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Entradas</th>
                    <th>Salidas</th>
                    <th>Total Vendido</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        conn = DriverManager.getConnection(url, user, password);
                        stmt = conn.createStatement();

                        // Consulta para los productos más vendidos
                        String queryMasVendidos = "SELECT nombre, entradas, salidas, (entradas - salidas) AS total_vendido FROM productos ORDER BY total_vendido DESC LIMIT 10";
                        rs = stmt.executeQuery(queryMasVendidos);

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getInt("entradas") %></td>
                    <td><%= rs.getInt("salidas") %></td>
                    <td><%= rs.getInt("total_vendido") %></td>
                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        out.println("Error al cargar el análisis de productos más vendidos: " + e.getMessage());
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>        
        </table>

        <!-- Análisis de Productos Menos Vendidos -->
        <h2>Análisis de Productos Menos Vendidos</h2>
        <div class="description">
            Este reporte muestra los productos con menor rotación en el inventario, permitiendo identificar artículos con baja demanda o posibles excesos de stock.
        </div>
        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Entradas</th>
                    <th>Salidas</th>
                    <th>Total Vendido</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        conn = DriverManager.getConnection(url, user, password);
                        stmt = conn.createStatement();

                        // Consulta para los productos menos vendidos
                        String queryMenosVendidos = "SELECT nombre, entradas, salidas, (entradas - salidas) AS total_vendido FROM productos ORDER BY total_vendido ASC LIMIT 10";
                        rs = stmt.executeQuery(queryMenosVendidos);

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getInt("entradas") %></td>
                    <td><%= rs.getInt("salidas") %></td>
                    <td><%= rs.getInt("total_vendido") %></td>
                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        out.println("Error al cargar el análisis de productos menos vendidos: " + e.getMessage());
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>        
        </table>

        <!-- Reportes Financieros -->
        <h2>Reportes Financieros</h2>
        <div class="description">
            Este reporte calcula los márgenes de ganancia basados en los precios de venta y las cantidades de productos ingresadas y vendidas, ofreciendo una perspectiva financiera.
        </div>
        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Precio</th>
                    <th>Entradas</th>
                    <th>Salidas</th>
                    <th>Margen de Ganancia</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        conn = DriverManager.getConnection(url, user, password);
                        stmt = conn.createStatement();

                        // Consulta para el reporte financiero
                        String queryFinanciero = "SELECT nombre, precio, entradas, salidas, (precio * entradas - precio * salidas) AS margen_ganancia FROM productos";
                        rs = stmt.executeQuery(queryFinanciero);

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getBigDecimal("precio") %></td>
                    <td><%= rs.getInt("entradas") %></td>
                    <td><%= rs.getInt("salidas") %></td>
                    <td><%= rs.getBigDecimal("margen_ganancia") %></td>
                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        out.println("Error al cargar el reporte financiero: " + e.getMessage());
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch ( SQLException e) { e.printStackTrace(); } if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); } } %> </tbody>
        </table>

        <!-- Gráfica de Inventario -->
        <h2>Gráficas de Inventario</h2>
        <canvas id="graficoInventario"></canvas>

        <script>
            // Lógica de la gráfica
            var ctx = document.getElementById('graficoInventario').getContext('2d');
            var graficoInventario = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Producto A', 'Producto B', 'Producto C'], // Datos de ejemplo
                    datasets: [{
                            label: 'Cantidad en Inventario',
                            data: [10, 20, 30], // Datos de ejemplo
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        </script>
    </body>

</html> 
