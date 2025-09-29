<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="modell.Requerimiento"%>
<%@page import="controller.RequerimientoJpaController"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="modell.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    Usuario u = (Usuario) sesion.getAttribute("user");

    if (u == null) {
        response.sendRedirect("index.jsp");
    }
%>
<%
    if (request.getParameter("id") != null) {
        int id = Integer.parseInt(request.getParameter("id"));
        RequerimientoJpaController rg = new RequerimientoJpaController();
        rg.destroy(id);
    }
%>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Consulta de requerimiento</title>
        <link rel="stylesheet" href="asset/css/normaliz.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="asset/css/style.css">
        <link rel="shortcut icon" href="asset/img/favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="asset/css/compras.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.4/xlsx.full.min.js"></script>

        <script>
            function exportTableToExcel() {
                const estadoIds = ['pendiente', 'solicitado', 'entregado', 'rechazado'];
                const wb = XLSX.utils.book_new();

                estadoIds.forEach(estado => {
                    const table = document.getElementById('tabla-' + estado);
                    if (table) {
                        const ws = XLSX.utils.table_to_sheet(table);
                        XLSX.utils.book_append_sheet(wb, ws, estado.charAt(0).toUpperCase() + estado.slice(1));
                    }
                });

                XLSX.writeFile(wb, 'Listado_Solicitudes_compras.xlsx');
            }
        </script>
        <script>
            function filtrarPorFecha() {
                const fechaInicioStr = document.getElementById("fechaInicio").value;
                const fechaFinStr = document.getElementById("fechaFin").value;

                if (!fechaInicioStr || !fechaFinStr) {
                    alert("Por favor selecciona ambas fechas.");
                    return;
                }

                const fechaInicio = new Date(fechaInicioStr);
                const fechaFin = new Date(fechaFinStr);
                fechaFin.setHours(23, 59, 59); // Para incluir toda la fecha final

                const tablas = document.querySelectorAll("table.solicitudes-tabla");

                tablas.forEach(tabla => {
                    const filas = tabla.querySelectorAll("tbody tr");

                    filas.forEach(fila => {
                        const celdaFecha = fila.querySelectorAll("td")[4]; // Columna "Fecha de solicitud"
                        if (celdaFecha) {
                            const textoFecha = celdaFecha.innerText.trim(); // ejemplo: "23/04/2025"
                            const partes = textoFecha.split("/");

                            if (partes.length === 3) {
                                const dia = parseInt(partes[0]);
                                const mes = parseInt(partes[1]) - 1;
                                const anio = parseInt(partes[2]);

                                const fechaSolicitud = new Date(anio, mes, dia);

                                const mostrar = (fechaSolicitud >= fechaInicio && fechaSolicitud <= fechaFin);
                                fila.style.display = mostrar ? "" : "none";

                                // DEPURACIÓN
                                console.log(`Fila: ${textoFecha} | Fecha parsed: ${fechaSolicitud.toLocaleDateString()} | Mostrar: ${mostrar}`);
                            } else {
                                fila.style.display = "none";
                            }
                        }
                    });
                });
            }
        </script>

    </head>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Winky+Sans:ital,wght@0,300..900;1,300..900&display=swap');
        body{
            font-family: "Oswald", sans-serif;
        }
        .control {
            overflow-x: auto; /* Permite el desplazamiento horizontal si es necesario */
            max-width: 100%; /* Asegura que no sobrepase el contenedor */
        }

        .table {
            width: 100%;
            table-layout: auto; /* Ajusta el tamaï¿½o de las columnas de forma dinï¿½mica */
            white-space: nowrap; /* Evita que el contenido se desborde */
            align-items: center;

        }
    </style>
    <style>
        .colorlib-table-container {
            max-width: 150%;
            overflow-x: auto;
            margin: 30px auto;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        .colorlib-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            
        }

        .colorlib-table thead {
            background-color: #28539C;
            color: white;
            text-align: center;
        }

        .colorlib-table thead th {
            background-color: #28539C;
            padding: 12px;
            font-size: 12px;
            min-width: 200px;
            white-space: nowrap;
            z-index: 10;
        }

        .colorlib-table tbody tr {
            background-color: #f9f9f9;
            transition: background-color 0.3s;
        }

        .colorlib-table tbody tr:nth-child(even) {
            background-color: #f1f5f9;
        }

        .colorlib-table tbody tr:hover {
            background-color: #e2e8f0;
        }

        .colorlib-table td {
            padding: 12px;
            text-align: center;
            font-size: 10px;
            color: #333;
        }

        /* Opcional: cabecera fija (con scroll interno) */
        .colorlib-table-container-fixed {
            max-height: 500px;
            overflow-y: auto;
        }

        .colorlib-table thead th {
            position: sticky;
            top: 0;
            z-index: 10;
        }
    </style>
    <body>
        <!-- Sidebar -->
        <div class="sidebar p-3" id="sidebar">
            <div class="text-center mb-4">
                <img src="asset/img/Logo.png" width="150px" alt="Logo" class="img-fluid mb-2">
                <h4>
                    <% if (u != null) {
                            out.print(u.getEmpleado());
                        } %>
                </h4>
                <small>Clinica Salud Social S.A.S</small>
            </div>
            <ul class="nav flex-column">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="dashboard.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-home"></i> Menu
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="dashboard.jsp">Inicio</a></li>
                            <% if (u != null && u.getROLcodigo() != null && "ADMINISTRADOR".equals(u.getROLcodigo().getNombre())) { %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="compras.jsp"> 
                                <i class="bi bi-clipboard-check"></i> Solicitudes de Compras</a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="solicitud.jsp">
                                <i class="bi bi-search"></i> Consulta de Compras
                            </a>
                        </li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="requerimiento_compras.jsp">
                                <i class="bi bi-clipboard-check"></i> Requerimiento a Compras
                            </a>

                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="Ccompras.jsp" 
                               <i class="bi bi-search"></i> Consulta de Requerimiento
                            </a>
                        </li>

                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="cambiarcontraseña.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-gear-fill"></i> Configuracion
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="cambiarcontraseña.jsp">Cambiar contraseña</a></li>
                        <li><a class="dropdown-item" href="creacionusuario.jsp">Crear Usuario</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="cerrarsecion.jsp">
                        <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                    </a>

                </li>
                <% } else if (u != null && u.getROLcodigo() != null && "COMPRAS".equals(u.getROLcodigo().getNombre())) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="compras.jsp">
                        <i class="bi bi-clipboard-check"></i> Solicitudes de Compras
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="solicitud.jsp">
                        <i class="bi bi-search"></i> Consulta De Compras
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="cambiarcontraseña.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-gear-fill"></i> Configuracion
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="cambiarcontraseña.jsp">Cambiar contraseña</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="cerrarsecion.jsp">
                        <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                    </a>

                </li>
                <% } else { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="compras.jsp">
                        <i class="bi bi-clipboard-check"></i> Solicitudes de Compras
                    </a>

                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="cambiarcontraseña.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-gear-fill"></i> Configuracion
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="cambiarcontraseña.jsp">Cambiar contraseña</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="cerrarsecion.jsp">
                        <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                    </a>

                </li>
                <% }%>   
            </ul>
        </div>
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="compras.jsp"></a>
                <img src="https://www.clinicasaludsocial.com/images/logo-full-color.jpg" alt="GIF sin fondo" width="150px" style="background-color: transparent;">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </div>
        </nav>
        <!-- Main Content -->
        <div class="main-content py-5">
            <div class="container py-5" style="border-radius: 7px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); background-color:#e5e7eb;;">
                <h2>
                    <img src="asset/icons/verifica.gif" alt="GIF sin fondo" width="50px" style="background-color: transparent;">
                    <strong>Listado De requerimiento de Compras</strong>
                </h2>

                <div class="form-container">
                    <%
                        RequerimientoJpaController solicitudController = new RequerimientoJpaController();
                        List<Requerimiento> solicitudes = solicitudController.findRequerimientoEntities();

                        // Orden descendente por ID
                        solicitudes.sort(( o1,   o2) -> (o2.getId() != null && o1.getId() != null)
                                ? o2.getId().compareTo(o1.getId())
                                : 0);

                        // Parámetros de filtros
                        String fechaInicioParam = request.getParameter("fechaInicio");
                        String fechaFinParam = request.getParameter("fechaFin");
                        String searchParam = request.getParameter("searchInput");
                        String estadoParam = request.getParameter("estado");
                        String cantidadParam = request.getParameter("cantidad");

                        int cantidad = (cantidadParam != null && !cantidadParam.isEmpty()) ? Integer.parseInt(cantidadParam) : 50;

                        Date fechaInicio = null, fechaFin = null;
                        if (fechaInicioParam != null && fechaFinParam != null) {
                            try {
                                SimpleDateFormat sdfFiltro = new SimpleDateFormat("yyyy-MM-dd");
                                fechaInicio = sdfFiltro.parse(fechaInicioParam);
                                fechaFin = sdfFiltro.parse(fechaFinParam);
                            } catch (ParseException e) {
                                e.printStackTrace();
                            }
                        }

                        // Aplicar filtros en memoria
                        List<Requerimiento> solicitudesFiltradas = new ArrayList<>();
                        for (Requerimiento s : solicitudes) {
                            boolean incluir = true;

                            // Filtro por fecha
                            if (fechaInicio != null && fechaFin != null && s.getFecha() != null) {
                                if (s.getFecha().before(fechaInicio) || s.getFecha().after(fechaFin)) {
                                    incluir = false;
                                }
                            }

                            // Filtro por búsqueda
                            if (searchParam != null && !searchParam.trim().isEmpty()) {
                                if (s.getCodigo() == null || !s.getCodigo().toLowerCase().contains(searchParam.toLowerCase())) {
                                    incluir = false;
                                }
                            }

                            // Filtro por estado
                            if (estadoParam != null && !estadoParam.equals("todos")) {
                                if (s.getArticulo() == null || !s.getArticulo().equalsIgnoreCase(estadoParam)) {
                                    incluir = false;
                                }
                            }

                            if (incluir) {
                                solicitudesFiltradas.add(s);
                            }
                        }

                        // Limitar resultados
                        if (solicitudesFiltradas.size() > cantidad) {
                            solicitudesFiltradas = solicitudesFiltradas.subList(0, cantidad);
                        }

                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    %>

                    <div class="container mt-4">
                        <!-- Formulario de filtros -->
                        <form method="get" class="row g-3 mb-4 p-3 bg-light rounded shadow-sm">
                            <div class="col-md-3">
                                <input type="text" name="searchInput" value="<%= searchParam != null ? searchParam : ""%>" 
                                       placeholder="Buscar por código" class="form-control">
                            </div>
                            <div class="col-md-2">
                                <input type="number" name="cantidad" value="<%= cantidad%>" min="1" class="form-control" placeholder="Cantidad">
                            </div>
                            <div class="col-md-2">
                                <input type="date" name="fechaInicio" value="<%= fechaInicioParam != null ? fechaInicioParam : ""%>" class="form-control">
                            </div>
                            <div class="col-md-2">
                                <input type="date" name="fechaFin" value="<%= fechaFinParam != null ? fechaFinParam : ""%>" class="form-control">
                            </div>
                            <div class="col-md-2 ">
                                <select name="estado" class="form-select me-2">
                                    <option value="todos" <%= (estadoParam == null || estadoParam.equals("todos")) ? "selected" : ""%>>Todos</option>
                                    <option value="pendiente" <%= "pendiente".equalsIgnoreCase(estadoParam) ? "selected" : ""%>>Pendientes</option>
                                    <option value="entregado" <%= "entregado".equalsIgnoreCase(estadoParam) ? "selected" : ""%>>Entregados</option>
                                    <option value="rechazado" <%= "rechazado".equalsIgnoreCase(estadoParam) ? "selected" : ""%>>Rechazados</option>
                                    <option value="entrego-parcialmente" <%= "entrego-parcialmente".equalsIgnoreCase(estadoParam) ? "selected" : ""%>>Entregado - Parcialmente</option>
                                </select>
                                
                            </div>
                                <div class="col-md-1 ">
                                    <button type="submit" class="btn btn-primary"><i class="fa fa-filter"></i> </button>
                                </div>
                        </form>

                        <!-- Tabla de resultados -->
                        <div style=" max-width: 2500px;" class="colorlib-table-container colorlib-table-container-fixed">
                            <table class="colorlib-table ce" id="solicitudesTable">
                                <thead class="colorlib-table" style="position: sticky; top: 0; z-index: 2;">
                                    <tr style="font-size: 13px;">
                                        <th class="text-center" style="min-width:30px;">Código</th>
                                        <th class="text-center" style="min-width:50px;">Fecha</th>
                                        <th class="text-center">Centro de Costo</th>
                                        <th class="text-center" style="min-width:500px;">Descripción</th>
                                        <th class="text-center">Usuario</th>
                                        <th class="text-center" style="min-width:60px;">Estado</th>
                                        <th class="text-center" style="min-width:500px;">Observación</th>
                                        <th class="text-center">Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Requerimiento solicitud : solicitudesFiltradas) {
                                        if ("ocultar".equalsIgnoreCase(solicitud.getCantidad())){
                                        continue;
                                        }
                                    %>
                                    <tr style="font-size: 12px;">
                                        <td class="text-center"><%= solicitud.getCodigo()%></td>
                                        <td class="text-center"><%= (solicitud.getFecha() != null) ? sdf.format(solicitud.getFecha()) : ""%></td>
                                        <td class="text-center"><%= solicitud.getCentrocosto()%></td>
                                        <td>
                                            <ol>
                                                <%
                                                    if (solicitud.getDescripcion() != null) {
                                                        String[] items = solicitud.getDescripcion().split("\\d+\\. ");
                                                        for (String item : items) {
                                                            if (!item.trim().isEmpty()) {
                                                %>
                                                <li><%= item.trim()%></li>
                                                    <%
                                                                }
                                                            }
                                                        }
                                                    %>
                                            </ol>
                                        </td>
                                        <td class="text-center"><%= solicitud.getUsuario()%></td>
                                        <td class="text-center">
                                            <span class="badge
                                                  <%= "pendiente".equalsIgnoreCase(solicitud.getArticulo()) ? "bg-warning text-dark"
                                    : "entregado".equalsIgnoreCase(solicitud.getArticulo()) ? "bg-success"
                                    : "entrego-parcialmente".equalsIgnoreCase(solicitud.getArticulo()) ? "bg-info"
                                    : "bg-danger"%>">
                                                <%= solicitud.getArticulo()%>
                                            </span>
                                        </td>
                                        <td class="text-center"><%= solicitud.getObservacion()%></td>
                                        <td class="text-center">
                                            <button onclick="abrirEstado(<%= solicitud.getId()%>)" 
                                                    class="btn btn-sm btn-outline-primary">
                                                <i class="fa fa-edit"></i> Editar
                                            </button>
                                            <button onclick="Ocultar(<%= solicitud.getId()%>)" 
                                                    class="btn btn-sm btn-outline-primary">
                                                <i class="fa fa-edit"></i> Editar
                                            </button>
                                        </td>
                                    </tr>
                                    <% }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function mostrarCantidad() {
                const cantidad = parseInt(document.getElementById("cantidadInput").value) || 50;
                document.querySelectorAll(".solicitudes-tabla tbody").forEach(tbody => {
                    const filasVisibles = Array.from(tbody.querySelectorAll("tr")).filter(fila => fila.style.display !== "none");
                    filasVisibles.forEach((fila, i) => {
                        fila.style.display = i < cantidad ? "" : "none";
                    });
                });
            }

            window.onload = mostrarCantidad;
            document.getElementById("cantidadInput").addEventListener("input", mostrarCantidad);

            function filtrarPorEstado(estado) {
                const secciones = document.querySelectorAll(".estado-section");
                secciones.forEach(sec => {
                    if (estado === "todos") {
                        sec.style.display = "";
                    } else {
                        sec.style.display = sec.id === "estado-" + estado ? "" : "none";
                    }
                });
                mostrarCantidad();
            }

            function searchTable() {
                const input = document.getElementById("searchInput");
                const filter = input.value.toUpperCase();
                let visibleRows = [];

                document.querySelectorAll(".solicitudes-tabla tbody").forEach(tbody => {
                    const rows = tbody.querySelectorAll("tr");
                    rows.forEach(row => {
                        const codigoCell = row.cells[0]; // Columna CÓDIGO
                        if (codigoCell) {
                            const txtValue = codigoCell.textContent || codigoCell.innerText;
                            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                row.style.display = "";
                                visibleRows.push(row);
                            } else {
                                row.style.display = "none";
                            }
                        }
                    });
                });

                const cantidad = parseInt(document.getElementById("cantidadInput").value) || visibleRows.length;
                let count = 0;
                visibleRows.forEach(row => {
                    if (count < cantidad) {
                        row.style.display = "";
                        count++;
                    } else {
                        row.style.display = "none";
                    }
                });
            }
            // Abrir ventana para actualizar
            function abrirEstado(id) {
                window.open(
                        'estado.jsp?id=' + id,
                        'Formulario de Registro',
                        'width=400,height=300'
                        );
            }
            function Ocultar(id) {
                window.open(
                        'OculRegistro.jsp?id=' + id,
                        'Formulario de Registro',
                        'width=400,height=300'
                        );
            }
        </script>
    </div>
</div>
</form>
</div>
</div>
</div>

<style>
    .table td, .table th {
        text-align: justify;
        white-space: normal;
        word-wrap: break-word;
        max-width: 500px;
    }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>


<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/exceljs/dist/exceljs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
<script>
            async function exportTableToExcel() {
                const table = document.getElementById("solicitudesTable");
                const wb = new ExcelJS.Workbook();
                const ws = wb.addWorksheet("Plan de trabajo");

// Estilos generales
                const headerFill = {type: 'pattern', pattern: 'solid', fgColor: {argb: 'FFCCE5FF'}}; // azul pastel
                const headerFont = {bold: true, color: {argb: 'FF000000'}};
                const borderStyle = {style: 'thin', color: {argb: 'FF000000'}};

// Cabecera
                const headers = [];
                for (let th of table.tHead.rows[0].cells) {
                    headers.push(th.innerText.trim());
                }

                ws.addRow(headers);
                const headerRow = ws.getRow(1);
                headerRow.eachCell((cell) => {
                    cell.fill = headerFill;
                    cell.font = headerFont;
                    cell.alignment = {vertical: 'middle', horizontal: 'center', wrapText: true};
                    cell.border = {
                        top: borderStyle,
                        left: borderStyle,
                        bottom: borderStyle,
                        right: borderStyle
                    };
                });

// Filas
                for (let i = 0; i < table.tBodies[0].rows.length; i++) {
                    const row = table.tBodies[0].rows[i];
                    const rowData = [];
                    // Excluir última columna (Acción)
                    for (let j = 0; j < row.cells.length - 1; j++) {
                        rowData.push(row.cells[j].innerText.trim());
                    }
                    const newRow = ws.addRow(rowData);

                    // Estilo por fila
                    newRow.eachCell((cell) => {
                        cell.alignment = {vertical: 'middle', horizontal: 'center', wrapText: true};
                        cell.border = {
                            top: borderStyle,
                            left: borderStyle,
                            bottom: borderStyle,
                            right: borderStyle
                        };
                    });

                    // Color alterno
                    if (i % 2 === 0) {
                        newRow.eachCell((cell) => {
                            cell.fill = {type: 'pattern', pattern: 'solid', fgColor: {argb: 'FFF2F2F2'}}; // gris claro
                        });
                    }
                }

// Ancho de columnas personalizado
                const columnWidths = [15, 20, 30, 50, 20, 15, 20, 20, 20, 15, 15, 15];
                ws.columns.forEach((col, index) => {
                    col.width = columnWidths[index] || 20;
                });

// Guardar archivo
                const buf = await wb.xlsx.writeBuffer();
                saveAs(new Blob([buf]), "Plan_de_trabajo.xlsx");
            }
</script>
<script>
    function filtrarPorFecha() {
        const fechaInicioStr = document.getElementById("fechaInicio").value;
        const fechaFinStr = document.getElementById("fechaFin").value;

        if (!fechaInicioStr || !fechaFinStr) {
            alert("Por favor selecciona ambas fechas.");
            return;
        }

        const fechaInicio = new Date(fechaInicioStr);
        const fechaFin = new Date(fechaFinStr);
        fechaFin.setHours(23, 59, 59); // Para incluir toda la fecha final

        const tablas = document.querySelectorAll("table.solicitudes-tabla");

        tablas.forEach(tabla => {
            const filas = tabla.querySelectorAll("tbody tr");

            filas.forEach(fila => {
                const celdaFecha = fila.querySelectorAll("td")[4]; // Columna "Fecha de solicitud"
                if (celdaFecha) {
                    const textoFecha = celdaFecha.innerText.trim(); // ejemplo: "23/04/2025"
                    const partes = textoFecha.split("/");

                    if (partes.length === 3) {
                        const dia = parseInt(partes[0]);
                        const mes = parseInt(partes[1]) - 1;
                        const anio = parseInt(partes[2]);

                        const fechaSolicitud = new Date(anio, mes, dia);

                        const mostrar = (fechaSolicitud >= fechaInicio && fechaSolicitud <= fechaFin);
                        fila.style.display = mostrar ? "" : "none";

                        // DEPURACIÓN
                        console.log(`Fila: ${textoFecha} | Fecha parsed: ${fechaSolicitud.toLocaleDateString()} | Mostrar: ${mostrar}`);
                    } else {
                        fila.style.display = "none";
                    }
                }
            });
        });
    }
</script>

</body>
</html>