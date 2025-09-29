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
        <title>Consulta De Compras</title>
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
                        <i class="bi bi-search"></i> Consulta de Compras
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
            <div class="container py-5" style="border-radius: 7px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); background-color: #e5e7eb;;">
                <h2><img src="asset/icons/verifica.gif" alt="GIF sin fondo" width="50px" style="background-color: transparent;"><strong>Listado De Solicitudes Realizadas A Compras</strong></h2>
                <div class="form-container">
                    <form action="solicitud.jsp" method="post">
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
                        <div class="row mb-4">
                            <div class="col md-2">
                                <label for="fechaInicio">Desde:</label>
                                <input type="date" id="fechaInicio" class="form-control">
                            </div>
                            <div class="col md-2">
                                <label for="fechaFin">Hasta:</label>
                                <input type="date" id="fechaFin" class="form-control">
                            </div>
                            <div class="col md-2" style="margin-top:23px">
                                <button type="button" onclick="filtrarPorFecha()" class="btn btn-primary">Filtrar</button>
                            </div>
                        </div>

                        <div class="btn-group my-3" role="group" aria-label="Filtrar por estado">
                            <button type="button" class="btn btn-outline-primary" onclick="filtrarPorEstado('todos')">Todos</button>
                            <button type="button" class="btn btn-outline-warning" onclick="filtrarPorEstado('pendiente')">Pendientes</button>
                            <button type="button" class="btn btn-outline-info" onclick="filtrarPorEstado('solicitado')">Solicitados</button>
                            <button type="button" class="btn btn-outline-success" onclick="filtrarPorEstado('entregado')">Entregados</button>
                            <button type="button" class="btn btn-outline-danger" onclick="filtrarPorEstado('rechazado')">Rechazados</button>
                        </div>
                        <div style="max-width: 1500px;" class="control">
                            <div style=" max-width: 1500px;" class="control" >
                                <%

                                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                                    ComprasJpaController solicitudController = new ComprasJpaController();
                                    List<Compras> solicitudes = solicitudController.findComprasEntities();

                                    // Agrupar por estado
                                    Map<String, List<Compras>> solicitudesAgrupadas = new HashMap<>();
                                    for (Compras solicitud : solicitudes) {
                                        if (solicitud.getESTADOcodigo() != null && solicitud.getESTADOcodigo().getNombre() != null) {
                                            String estado = solicitud.getESTADOcodigo().getNombre().trim().toLowerCase();
                                            solicitudesAgrupadas.computeIfAbsent(estado, k -> new ArrayList<>()).add(solicitud);
                                        }
                                    }

                                    // Estados que quieres mostrar en orden
                                    String[] estadosOrden = {"pendiente", "solicitado", "entregado", "rechazado"};

                                    for (String estadoActual : estadosOrden) {
                                        List<Compras> grupo = solicitudesAgrupadas.get(estadoActual);
                                        if (grupo != null && !grupo.isEmpty()) {
                                %>

                                <h3 style="margin-top: 30px; background-color: #f1f1f1; padding: 10px; border-left: 5px solid #007bff;">
                                    Solicitudes en estado: <%= estadoActual.substring(0, 1).toUpperCase() + estadoActual.substring(1)%>
                                </h3>
                                <table  class="table table-bordered solicitudes-tabla" id="tabla-<%= estadoActual%>" >
                                    <thead class="table-light">
                                        <!-- Aquí van tus encabezados como los tienes -->
                                        <tr>
                                            <th style="min-width: 150px; text-align: center;">Codigo</th>
                                            <th style="min-width: 200px; text-align: center;">Numero de Solicitud</th>
                                            <th style="min-width: 150px; text-align: center;">Area</th>
                                            <th style="min-width: 500px; text-align: center;">Descripcion</th>
                                            <th style="min-width: 150px; text-align: center;">Fecha de solicitud</th>
                                            <th style="min-width: 150px; text-align: center;">Numero de orden de compra</th>
                                            <th style="min-width: 150px; text-align: center;">Estado</th>
                                            <th style="min-width: 300px; text-align: center;">Nombre del proveedor</th>
                                            <th style="min-width: 150px; text-align: center;">Fecha de envio</th>
                                            <th style="min-width: 150px; text-align: center;">Fecha de entrada</th>
                                            <th style="min-width: 150px; text-align: center;">Fecha de entrega</th>
                                            <th style="min-width: 150px; text-align: center;">Duracion</th>
                                            <th style="min-width: 150px; text-align: center;">Conformidad</th>
                                            <th style="min-width: 500px; text-align: center;">Observacion</th>
                                            <th style="min-width: 150px; text-align: center;">Generado por</th>
                                            <th style="min-width: 150px; text-align: center;">Actualizar y Editar</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Compras solicitud : grupo) {
                                                String fecha1 = dateFormat.format(solicitud.getFechaSolicitud());
                                                String fecha2 = dateFormat.format(solicitud.getFechaEnvio());
                                                String fecha3 = dateFormat.format(solicitud.getFechaEntrada());
                                                String fecha4 = dateFormat.format(solicitud.getFechaEntrega());

                                                String estado = solicitud.getESTADOcodigo().getNombre().trim();
                                                String estiloEstado = "text-align: center;";
                                                switch (estado.toLowerCase()) {
                                                    case "pendiente":
                                                        estiloEstado += " background-color: rgba(251, 188, 4, 0.2); font-weight: bold;";
                                                        break;
                                                    case "solicitado":
                                                        estiloEstado += " background-color: rgba(52, 187, 228, 0.2); font-weight: bold;";
                                                        break;
                                                    case "entregado":
                                                        estiloEstado += " background-color: rgba(52, 168, 83, 0.2); font-weight: bold;";
                                                        break;
                                                    case "rechazado":
                                                        estiloEstado += " background-color: rgba(196, 37, 34, 0.2); font-weight: bold;";
                                                        break;
                                                    default:
                                                        estiloEstado += " background-color: #f0f0f0; color: black;";
                                                }
                                        %>
                                        <tr>
                                            <td style="<%= estiloEstado%> "><%= solicitud.getConsecutivo()%></td>
                                            <td style="text-align: center;"><%= solicitud.getNumeroSolicitud()%></td>
                                            <td style="text-align: center; "><%= solicitud.getArea()%></td>
                                            <td style="text-align: justify; " title="<%= solicitud.getDescripcion()%>">
                                                <div class="obs-container">
                                                    <span class="obs-preview">
                                                        <%= solicitud.getDescripcion().length() > 100
                                                    ? solicitud.getDescripcion().toUpperCase().substring(0, 100) + "..."
                                                    : solicitud.getDescripcion().toUpperCase()%>
                                                    </span>
                                                    <span class="obs-full" style="display:none;">
                                                        <%= solicitud.getDescripcion().toUpperCase()%>
                                                    </span>
                                                    <% if (solicitud.getDescripcion().length() > 100) { %>
                                                    <a href="#" onclick="toggleObs(this);
                                                return false;" title="Ver más">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>
                                                    <% }%>
                                                </div>
                                            </td>
                                            <td style="text-align: center; vertical-align: middle; "><%= fecha1%></td>
                                            <td style="text-align: center; vertical-align: middle; "><%= solicitud.getVbComprar()%></td>
                                            <td style="<%= estiloEstado%> vertical-align: middle; "><%= estado%></td>
                                            <td style="text-align: center; vertical-align: middle; "><%= solicitud.getNombreProveedor()%></td>
                                            <td style="text-align: center; vertical-align: middle; "><%= fecha2%></td>
                                            <td style="text-align: center; vertical-align: middle; "><%= fecha3%></td>
                                            <td style="text-align: center; vertical-align: middle; "><%= fecha4%></td>
                                            <td style="text-align: center; vertical-align: middle; "><%= solicitud.getDuracion()%></td>
                                            <td style="text-align: center; vertical-align: middle; "><%= solicitud.getConformidad()%></td>
                                            <td style="text-align: justify; vertical-align: middle; ">
                                                <div class="obs-container">
                                                    <span class="obs-preview">
                                                        <%= solicitud.getObservacion().length() > 100
                                                    ? solicitud.getObservacion().toUpperCase().substring(0, 100) + "..."
                                                    : solicitud.getObservacion().toUpperCase()%>
                                                    </span>
                                                    <span class="obs-full" style="display:none;">
                                                        <%= solicitud.getObservacion().toUpperCase()%>
                                                    </span>
                                                    <% if (solicitud.getObservacion().length() > 100) { %>
                                                    <a href="#" onclick="toggleObs(this);
                                                return false;" title="Ver más">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>
                                                    <% }%>
                                                </div>
                                            </td>
                                            <td style="text-align: center;"><%= solicitud.getGenerado()%></td>
                                            <td style="text-align: center;">
                                                <button class="btn btn-info" onclick="abrirActualizar(<%= solicitud.getId()%>)" style="background: none; border: none;">
                                                    <img src="asset/icons/actualizar.png" width="30px" title="Actualizar">
                                                </button>
                                                <button class="btn btn-info" onclick="abrirEditar(<%= solicitud.getId()%>)" style="background: none; border: none;">
                                                    <img src="asset/icons/editar.png" width="30px" title="Editar">
                                                </button>
                                            </td>
                                        </tr>
                                        <%
                                            } // Fin for de grupo
                                        %>
                                    </tbody>
                                </table>
                                <%
                                        } // Fin if grupo != null
                                    } // Fin for estadosOrden
%>

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

        <script>
                                                function mostrarCantidad() {
                                                    const cantidad = parseInt(document.getElementById("cantidadInput").value) || 2;
                                                    document.querySelectorAll(".solicitudes-tabla tbody").forEach(tbody => {
                                                        const filas = tbody.querySelectorAll("tr");
                                                        filas.forEach((fila, i) => {
                                                            fila.style.display = i < cantidad ? "" : "none";
                                                        });
                                                    });
                                                }
                                                window.onload = mostrarCantidad;

                                                document.getElementById("cantidadInput").addEventListener("input", mostrarCantidad);

                                                function filtrarPorEstado(estado) {
                                                    const tablas = document.querySelectorAll('.solicitudes-tabla');
                                                    tablas.forEach(tabla => {
                                                        if (estado === 'todos') {
                                                            tabla.style.display = '';
                                                            tabla.previousElementSibling.style.display = '';
                                                        } else {
                                                            if (tabla.id === 'tabla-' + estado) {
                                                                tabla.style.display = '';
                                                                tabla.previousElementSibling.style.display = '';
                                                            } else {
                                                                tabla.style.display = 'none';
                                                                tabla.previousElementSibling.style.display = 'none';
                                                            }
                                                        }
                                                    });
                                                }

                                                function toggleObs(link) {
                                                    const container = link.closest('.obs-container');
                                                    const preview = container.querySelector('.obs-preview');
                                                    const full = container.querySelector('.obs-full');
                                                    const icon = link.querySelector('i');

                                                    if (full.style.display === 'none') {
                                                        preview.style.display = 'none';
                                                        full.style.display = 'inline';
                                                        icon.classList.remove('fa-eye');
                                                        icon.classList.add('fa-eye-slash');
                                                    } else {
                                                        full.style.display = 'none';
                                                        preview.style.display = 'inline';
                                                        icon.classList.remove('fa-eye-slash');
                                                        icon.classList.add('fa-eye');
                                                    }
                                                }

                                                function abrirActualizar(id) {
                                                    window.open('./actualizadoCP.jsp?id=' + id, 'Formulario de Registro', 'width=1300,height=700');
                                                }
                                                function abrirEditar(id) {
                                                    window.open('./editarsolicitud.jsp?id=' + id, 'Formulario de Registro', 'width=1300,height=700');
                                                }

                                                function searchTable() {
                                                    var input = document.getElementById("searchInput");
                                                    var filter = input.value.toUpperCase();
                                                    var tablas = document.querySelectorAll(".solicitudes-tabla");
                                                    var visibleRows = [];
                                                    tablas.forEach(function (table) {
                                                        var tr = table.getElementsByTagName("tr");
                                                        for (var i = 1; i < tr.length; i++) {
                                                            var td = tr[i].getElementsByTagName("td");
                                                            let showRow = false;
                                                            if (td[1]) {
                                                                var txtValue = td[1].textContent || td[1].innerText;
                                                                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                                                    showRow = true;
                                                                }
                                                            }
                                                            if (showRow) {
                                                                visibleRows.push(tr[i]);
                                                                tr[i].style.display = "";
                                                            } else {
                                                                tr[i].style.display = "none";
                                                            }
                                                        }
                                                    });
                                                    var cantidad = parseInt(document.getElementById("cantidadInput").value) || visibleRows.length;
                                                    mostrarCantidadFiltrada(visibleRows, cantidad);
                                                }

                                                function mostrarCantidadFiltrada(visibleRows, cantidad) {
                                                    var filasAMostrar = visibleRows.slice(0, cantidad);
                                                    document.querySelectorAll(".solicitudes-tabla tbody tr").forEach(fila => fila.style.display = "none");
                                                    filasAMostrar.forEach(fila => fila.style.display = "");
                                                }
        </script>

    </body>
</html>