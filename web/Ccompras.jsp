<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="modell.Requerimiento"%>
<%@page import="controller.RequerimientoJpaController"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="controller.ComprasJpaController"%>
<%@page import="modell.Compras"%>
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
        ComprasJpaController rg = new ComprasJpaController();
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
            font-family: "Winky Sans", sans-serif;
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
                    </ul>
                </li>
                <% if (u != null && u.getROLcodigo() != null && "ADMINISTRADOR".equals(u.getROLcodigo().getNombre())) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="compras.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-clipboard-check"></i> Solicitudes De Compras
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="compras.jsp">Solicitud Compras</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="solicitud.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-search"></i> Consulta De Compras
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="solicitud.jsp">Consulta Compras</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="requerimiento_compras.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-clipboard-check"></i> Requerimiento De Compras
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="requerimiento_compras.jsp">Requerimiento</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="Ccompras.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-search"></i> Consulta De Requerimiento
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="Ccompras.jsp">Consulta</a></li>
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
                    <a class="nav-link dropdown-toggle" href="cerrarsecion" id="logoutDropdown" role="button" data-bs-toggle="dropdown"
                       aria-expanded="false">
                        <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="logoutDropdown">
                        <li><a class="dropdown-item" href="cerrarsecion.jsp">Cerrar sesión</a></li>
                    </ul>
                </li>
                <% } else if (u != null && u.getROLcodigo() != null && "COMPRAS".equals(u.getROLcodigo().getNombre())) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="compras.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-clipboard-check"></i> Solicitudes De Compras
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="compras.jsp">Solicitud Compras</a></li>
                    </ul>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="solicitud.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-search"></i> Consulta De Compras
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="solicitud.jsp">Consulta Compras</a></li>
                    </ul>
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
                    <a class="nav-link dropdown-toggle" href="cerrarsecion" id="logoutDropdown" role="button" data-bs-toggle="dropdown"
                       aria-expanded="false">
                        <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="logoutDropdown">
                        <li><a class="dropdown-item" href="cerrarsecion.jsp">Cerrar sesión</a></li>
                    </ul>
                </li>
                <% } else { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="compras.jsp" id="overviewDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-clipboard-check"></i> Solicitudes De Compras
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="overviewDropdown">
                        <li><a class="dropdown-item" href="compras.jsp">Solicitud Compras</a></li>
                    </ul>
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
                    <a class="nav-link dropdown-toggle" href="cerrarsecion" id="logoutDropdown" role="button" data-bs-toggle="dropdown"
                       aria-expanded="false">
                        <i class="fas fa-sign-out-alt"></i> Cerrar sesión
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="logoutDropdown">
                        <li><a class="dropdown-item" href="cerrarsecion.jsp">Cerrar sesión</a></li>
                    </ul>
                </li>
                <% } %>   
            </ul>
        </div>
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="compras.jsp">Consulta De Requerimiento</a>
                <img src="https://www.clinicasaludsocial.com/images/logo-full-color.jpg" alt="GIF sin fondo" width="150px" style="background-color: transparent;">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </div>
        </nav>
        <!-- Main Content -->
        <div class="main-content py-5">
            <div class="container py-5" style="border-radius: 7px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); background-color: #f4f6f6;">
                <h2>
                    <img src="asset/icons/verifica.gif" alt="GIF sin fondo" width="50px" style="background-color: transparent;">
                    <strong>Listado De requerimiento de Compras</strong>
                </h2>

                <div class="form-container">
                    <form action="Ccompras.jsp" method="post">
                        <div class="row mb-4">
                            <div class="col md-10 position-relative">
                                <input type="text" id="searchInput" onkeyup="searchTable()" placeholder="Buscar por N° de Solicitud" class="form-control pr-5">
                                <i class="fas fa-filter position-absolute" style="top: 50%; right: 20px; transform: translateY(-50%);"></i>
                            </div>
                            <div class="col md-2">
                                <input type="number" id="cantidadInput" class="form-control" placeholder="" min="1" value="50">
                            </div>
                            <div class="col md-2">
                                <button type="button" onclick="mostrarCantidad()" class="btn btn-primary">Aceptar</button>
                                <button type="button" onclick="exportTableToExcel()" class="btn btn-success">Descargar Excel</button>
                            </div>
                        </div>

                        <form action="Ccompras.jsp" method="get" class="row g-3">
                            <div class="row g-3">
                                <div class="col-md-4">
                                <label for="fechaInicio" class="form-label fw-semibold">Desde</label>
                                <input type="date" name="fechaInicio" class="form-control" value="<%= request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : ""%>" required>
                            </div>
                            <div class="col-md-4">
                                <label for="fechaFin" class="form-label fw-semibold">Hasta</label>
                                <input type="date" name="fechaFin" class="form-control" value="<%= request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : ""%>" required>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-50">
                                    <i class="fa-solid fa-calendar-check me-1"></i> Filtrar
                                </button>
                            </div>
                            </div>
                        </form>

                        <div style="max-width: 1500px;" class="control">
                            <%
                                RequerimientoJpaController solicitudController = new RequerimientoJpaController();
                                List<Requerimiento> solicitudes = solicitudController.findRequerimientoEntities();

                                // Ordenar descendente
                                Collections.sort(solicitudes, new Comparator<Requerimiento>() {
                                    @Override
                                    public int compare(Requerimiento o1, Requerimiento o2) {
                                        if (o1.getId() == null || o2.getId() == null) {
                                            return 0;
                                        }
                                        return o2.getId().compareTo(o1.getId());
                                    }
                                });

                                // Estados que quieres mostrar
                                String[] estados = {"pendiente", "entregado", "rechazado"};

                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                
                                
                            %>

                            <!-- Botones de filtros -->
                            <div class="btn-group my-3" role="group" aria-label="Filtrar por estado">
                                <button type="button" class="btn btn-outline-primary" onclick="filtrarPorEstado('todos')">Todos</button>
                                <button type="button" class="btn btn-outline-warning" onclick="filtrarPorEstado('pendiente')">Pendientes</button>
                                <button type="button" class="btn btn-outline-success" onclick="filtrarPorEstado('entregado')">Entregados</button>
                                <button type="button" class="btn btn-outline-danger" onclick="filtrarPorEstado('rechazado')">Rechazados</button>
                            </div>

                            <!-- Secciones por estado -->
                            <% for (String estado : estados) {%>
                            <div class="estado-section" id="estado-<%=estado%>">
                                <h3 class="mt-4 text-capitalize">
                                    <span class="badge
                                          <%= estado.equals("pendiente") ? "bg-warning text-dark"
                                            : estado.equals("entregado") ? "bg-success"
                                            : "bg-danger"%>">
                                        <%= estado%>
                                    </span>
                                </h3>

                                <table class="table table-bordered table-hover mt-2 solicitudes-tabla" >
                                    <thead class="table-light">
                                        <tr style="font-size: 12px">
                                            <th style="text-align: center; width: 120px;">Código</th>
                                            <th style="text-align: center; width: 130px;">Fecha</th> 
                                            <th style="text-align: center; width: 200px;">Centro de costo</th>
                                            <th style="text-align: center; width: 350px;">Descripción</th>
                                            <th style="text-align: center; width: 200px;">Usuario</th>
                                            <th style="text-align: center; width: 150px;">Estado</th>
                                            <th style="text-align: center; width: 250px;">Observación</th>
                                            <th style="text-align: center; width: 50px;">Accion</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Requerimiento solicitud : solicitudes) {
                                                    String fechaInicioParam = request.getParameter("fechaInicio");
                                                    String fechaFinParam = request.getParameter("fechaFin");

                                                    Date fechaInicio = null;
                                                    Date fechaFin = null;

                                                    if (fechaInicioParam != null && fechaFinParam != null) {
                                                        SimpleDateFormat sdfFiltro = new SimpleDateFormat("yyyy-MM-dd");
                                                        try {
                                                            fechaInicio = sdfFiltro.parse(fechaInicioParam);
                                                            fechaFin = sdfFiltro.parse(fechaFinParam);
                                                        } catch (ParseException e) {
                                                            e.printStackTrace(); // puedes manejar esto con un mensaje de error
                                                        }
                                                    }
                                                    if (fechaInicio != null && fechaFin != null) {
                                                        if (solicitud.getFecha().before(fechaInicio)
                                                                || solicitud.getFecha().after(fechaFin)) {
                                                            continue;
                                                        }
                                                    }
                                                if (solicitud.getArticulo() != null
                                                        && solicitud.getArticulo().equalsIgnoreCase(estado)) {
                                                    
                                        %>
                                        <tr style="vertical-align: middle; font-size: 12px"> 
                                            <td style="text-align: center;"><%= solicitud.getCodigo()%></td>
                                            <td style="text-align: center;">
                                                <%= (solicitud.getFecha() != null) ? sdf.format(solicitud.getFecha()) : ""%>
                                            </td>
                                            <td style="text-align: center;"><%= solicitud.getCentrocosto()%></td>
                                            <td style="text-align: left;">
                                                <ol>
                                                    <%
                                                        String[] items = solicitud.getDescripcion().split("\\d+\\. ");
                                                        for (String item : items) {
                                                            if (!item.trim().isEmpty()) {
                                                    %>
                                                    <li><%= item.trim()%></li>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                </ol>
                                            </td>
                                            <td style="text-align: center;"><%= solicitud.getUsuario()%></td>
                                            <td style="text-align: center;"><%= solicitud.getArticulo()%></td>
                                            <td style="text-align: center;"><%= solicitud.getObservacion()%></td>
                                            <td>
                                                <button onclick="abrirEstado(<%= solicitud.getId()%>)"
                                                        style="background: none; border: none; padding: 0; cursor: pointer; font-size: 1.8rem; color: #007bff;">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                            <% }%>
                        </div>
                    </form>
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
function abrirEstado(id) {
           window.open('estados.jsp?id=' + id, 'Formulario de Registro', 'width=300,height=300');
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