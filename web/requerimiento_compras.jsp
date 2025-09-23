<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="modell.ActivoFijos"%>
<%@page import="controller.ActivoFijosJpaController"%>
<%@page import="controller.RequerimientoJpaController"%>
<%@page import="modell.Requerimiento"%>
<%@page import="controller.ComprasJpaController"%>
<%@page import="modell.Compras"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="modell.Estado"%>
<%@page import="java.util.List"%>
<%@page import="controller.EstadoJpaController"%>
<%@page import="modell.Usuario"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    Usuario u = (Usuario) sesion.getAttribute("user");

    if (u == null) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Requerimiento De Compras</title>
        <link rel="stylesheet" href="asset/css/normaliz.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="asset/css/style.css">
        <link rel="stylesheet" href="asset/css/compras.css">
        <link rel="shortcut icon" href="asset/img/favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <!-- Asegúrate de incluir Bootstrap 5 y Bootstrap Icons en tu proyecto -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <!-- CDN para SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    </head>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Winky+Sans:ital,wght@0,300..900;1,300..900&display=swap');
        body{
            font-family: "Winky Sans", sans-serif;
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
                        <i class="bi bi-clipboard-check"></i> Requerimiento a Compras
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
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="compras.jsp">Requerimientpo de compras</a>
                <a class="navbar-brand" href="compras.jsp"><img src="https://www.clinicasaludsocial.com/images/logo-full-color.jpg" alt="GIF sin fondo" width="150px" style="background-color: transparent;"></a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </div>
        </nav>
        <!-- Main Content -->
        <div class="main-content py-5" style="">
            <div class="container py-5" style=" border-radius: 7px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); background-color:  #f4f6f6;">
                <h2><img src="asset/icons/seguimiento.gif" alt="GIF sin fondo" width="50px" style="background-color: transparent;"><strong>Requerimiento a Compras</strong></h2>
                <h4 style="text-align: center;" >CLINICA SALUD SOCIAL S.A.S</h4>
                <div class="form-container py-3">

                    <form action="requerimiento_compras.jsp" method="POST" >
                        <div class="row mb-4">
                            <div class="col-md-2">
                                <label class="form-label" for="consecutivo">Codigo<span style="color: red;">*</span></label>
                                <input type="text" class="form-control" id="codigo" name="codigo" placeholder="" readonly >
                            </div>
                            <script>
                                fetch('generarCodigo') // URL de tu servlet
                                        .then(response => response.text())
                                        .then(codigo => {
                                            document.getElementById("codigo").value = codigo;
                                        })
                                        .catch(error => console.error('Error:', error));
                            </script>
                            <div class="col-md-2">
                                <label class="form-label" for="fecha_solicitud">Fecha<span style="color: red;">*</span></label>
                                <input type="date" class="form-control" id="fecha" name="fecha"  required>
                            </div>
                        </div>
                        <div class="row mb-4">
                            <!-- Campo Consecutivo con icono de búsqueda -->
                            <div class="col-md-2">
                                <label class="form-label" for="consecutivoss">Consecutivo<span style="color: red;">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" id="consecutivos"  placeholder="" >
                                    <button class="btn btn-outline-secondary" type="button" data-bs-toggle="modal" data-bs-target="#modalBusqueda">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Campo Artículo -->
                            <div class="col-md-3">
                                <label class="form-label" for="articulos">Artículo<span style="color: red;">*</span></label>
                                <input type="text" id="articulos" class="form-control" placeholder="">
                            </div>

                            <!-- Campo Descripción -->
                            <div class="col-md-3">
                                <label class="form-label" for="descripcions">Descripción de solicitud<span style="color: red;">*</span></label>
                                <textarea class="form-control" id="descripcions"  placeholder="Descripcion" rows="1" ></textarea>
                            </div>

                            <!-- Campo Cantidad -->
                            <div class="col-md-2">
                                <label class="form-label" for="cantidads">Cantidad<span style="color: red;">*</span></label>
                                <input type="text" id="cantidads" class="form-control" placeholder="">
                            </div>
                            <div class="col-md-2" style="margin-top:30px">
                                <button type="button" class="btn btn-primary" onclick="guardarInformacion()"><i class="bi bi-plus-circle"></i></button>
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#infoModal">
                                    Crear activo fijo
                                </button>
                            </div>
                            <!-- Modal de búsqueda -->
                            <div class="modal fade" id="modalBusqueda" tabindex="-1" aria-labelledby="modalBusquedaLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="modalBusquedaLabel">Buscar Consecutivo</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                                        </div>
                                        <div class="modal-body">

                                            <!-- Barra de búsqueda y cantidad -->
                                            <div class="row mb-3">
                                                <div class="col-md-8">
                                                    <input type="text" id="buscarInput" class="form-control"
                                                           placeholder="Buscar por código o artículo..." 
                                                           onkeyup="filtrarTabla()">
                                                </div>
                                                <div class="col-md-4 d-flex align-items-center">
                                                    <label for="cantidadInput" class="form-label me-2" style="font-weight:bold;">Registros:</label>
                                                    <input type="number" id="cantidadInput" class="form-control"
                                                           min="1" value="10" style="width:100px;" onchange="mostrarRegistros()">
                                                </div>
                                            </div>

                                            <!-- Tabla de resultados -->
                                            <table class="table table-striped" id="tablaBusqueda">
                                                <thead>
                                                    <tr style="text-align: center;">
                                                        <th style="min-width:150px;">Código</th>
                                                        <th>Artículo</th>
                                                        <th>Acción</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        ActivoFijosJpaController solicitudController = new ActivoFijosJpaController();
                                                        List<ActivoFijos> solicitudes = solicitudController.findActivoFijosEntities();
                                                        Collections.sort(solicitudes, new Comparator<ActivoFijos>() {
                                                            @Override
                                                            public int compare(ActivoFijos o1, ActivoFijos o2) {
                                                                if (o1.getCodigo() == null || o2.getCodigo() == null) {
                                                                    return 0;
                                                                }
                                                                return o2.getCodigo().compareTo(o1.getCodigo()); // Descendente
                                                            }
                                                        });
                                                        for (ActivoFijos solicitud : solicitudes) {
                                                    %>
                                                    <tr>
                                                        <td style="text-align: center;"><%= solicitud.getCodigo()%></td>
                                                        <td style="text-align: center;"><%= solicitud.getNombre()%></td>
                                                        <td style="text-align: center;">
                                                            <button type="button" 
                                                                    class="btn btn-gradient btn-sm btn-shadow"
                                                                    onclick="seleccionarConsecutivo('<%= solicitud.getCodigo()%>', '<%= solicitud.getNombre()%>')">
                                                                <i class="bi bi-check-circle-fill"></i>
                                                            </button>
                                                        </td>

                                                <style>
                                                    /* Botón profesional con gradiente y sombra */
                                                    .btn-gradient {
                                                        background: linear-gradient(135deg, #4e73df, #1cc88a);
                                                        color: white;
                                                        border: none;
                                                        border-radius: 8px;
                                                        padding: 0.45rem 0.6rem; /* Ajusta tamaño para el ícono */
                                                        transition: transform 0.2s, box-shadow 0.2s, background 0.3s;
                                                        font-size: 1.2rem; /* Tamaño del ícono */
                                                    }

                                                    .btn-gradient:hover {
                                                        transform: translateY(-2px);
                                                        box-shadow: 0 8px 16px rgba(0,0,0,0.3);
                                                        background: linear-gradient(135deg, #1cc88a, #4e73df); /* Cambio de gradiente al pasar mouse */
                                                    }

                                                    .btn-shadow {
                                                        box-shadow: 0 4px 6px rgba(0,0,0,0.2);
                                                    }

                                                    /* Opcional: efecto de escala al hacer click */
                                                    .btn:active {
                                                        transform: scale(0.95);
                                                    }
                                                </style>

                                                </tr>
                                                <%
                                                    }
                                                %>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <script>
                                let filas = [];

                                document.addEventListener("DOMContentLoaded", () => {
                                    filas = Array.from(document.querySelectorAll("#tablaBusqueda tbody tr"));
                                    mostrarRegistros(); // al inicio muestra solo 20
                                });

                                function mostrarRegistros() {
                                    let cantidad = parseInt(document.getElementById("cantidadInput").value) || 10;
                                    filas.forEach((fila, index) => {
                                        if (index < cantidad) {
                                            fila.style.display = "";
                                        } else {
                                            fila.style.display = "none";
                                        }
                                    });
                                }

                                function filtrarTabla() {
                                    let input = document.getElementById("buscarInput").value.toLowerCase();
                                    let cantidad = parseInt(document.getElementById("cantidadInput").value) || 10;
                                    let visibles = 0;

                                    filas.forEach(fila => {
                                        let codigo = fila.cells[0].textContent.toLowerCase();
                                        let articulo = fila.cells[1].textContent.toLowerCase();

                                        if ((codigo.includes(input) || articulo.includes(input)) && visibles < cantidad) {
                                            fila.style.display = "";
                                            visibles++;
                                        } else {
                                            fila.style.display = "none";
                                        }
                                    });
                                }
                            </script>
                            <!-- Script para pasar valores seleccionados -->
                            <script>
                                function seleccionarConsecutivo(codigo, articulo, cantidad = "") {
                                    document.getElementById("consecutivos").value = codigo;
                                    document.getElementById("articulos").value = articulo;
                                    document.getElementById("cantidads").value = cantidad;

                                    // Cerrar modal automáticamente
                                    var modal = bootstrap.Modal.getInstance(document.getElementById('modalBusqueda'));
                                    modal.hide();
                                }
                            </script>

                            <!-- Botón Guardar -->

                            <!-- Grilla de detalle (inicia oculta) -->
                            <div class="col-md-12 mt-4" id="contenedorGrilla" style="display:none;">
                                <h5>Detalle del Requerimiento</h5>
                                <table class="table table-bordered" id="tablaDetalle">
                                    <thead class="table-light">
                                        <tr >
                                            <th>Consecutivo</th>
                                            <th>Artículo</th>
                                            <th>Descripción</th>
                                            <th>Cantidad</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody id="detalleRequerimiento">
                                    <template id="filaTemplate">
                                        <tr>
                                            <td class="consecutivos">
                                                <input type="hidden">
                                            </td>
                                            <td class="articulos">
                                                <input type="hidden"  >
                                            </td>
                                            <td class="descripcions">
                                                <input type="hidden" >
                                            </td>
                                            <td class="cantidads">
                                                <input type="hidden" >
                                            </td>
                                            <td><button type="button" class="btn btn-danger btn-sm">Eliminar</button></td>
                                        </tr>
                                    </template>
                                    </tbody>
                                </table>
                            </div>
                            <div class="row mb-4 py-3">
                                <div class="col-md-4">
                                    <label class="form-label" for="">Centro de costo<span style="color: red;">*</span></label>
                                    <select id="costo" name="costo" class="form-control" required>
                                        <option value="">Seleccione</option>
                                        <option value="URGENCIAS">URGENCIA</option>
                                        <option value="UCI ADULTO">UCI ADULTO</option>
                                        <option value="UCI NEONATAL">UCI NEONATAL</option>
                                        <option value="CIRUGIA">CIRUGIA</option>
                                        <option value="ONCOLOGIA">ONCOLOGIA</option>
                                        <option value="CONSULTA EXTERNA">CONSULTA EXTERNA</option>
                                        <option value="HOSPITALIZACION">HOSPITALIZACION</option>
                                        <option value="IMAGENEOLOGIA">IMAGENEOLOGIA</option>
                                        <option value="LABORATORIO">LABORATORIO</option>
                                        <option value="TRANSFUCIONAL">TRANSFUCIONAL</option>
                                        <option value="ADMINISTRACION">ADMINISTRACION</option>
                                        <option value="AMBULANCIA">AMBULANCIA</option>
                                        <option value="RESTAURANTE Y CAFETERIA">RESTAURANTE Y CAFETERIA</option>
                                        <option value="LAVANDERIA">LAVANDERIA</option>
                                    </select>
                                </div>   

                                <div class="col-md-4">
                                    <label class="form-label" for="">Usuario<span style="color: red;">*</span></label>
                                    <input type="text" name="usuario" id="usuario" class="form-control" placeholder="" readonly value="<% if (u != null) {
                                            out.print(u.getEmpleado());
                                        } %>">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label" for="">Estado<span style="color: red;">*</span></label>
                                    <select id="articulo" name="articulo" class="form-control" required>
                                        <option value="">Seleccione</option>
                                        <option value="PENDIENTE">PENDIENTE</option>
                                        <option value="ENTREGADO">ENTREGADO</option>
                                        <option value="RECHAZADO">RECHAZADO</option>
                                        <option value="ENTREGO - PARCIALMENTE">ENTREGO - PARCIALMENTE</option>
                                    </select>
                                </div>  
                            </div>
                            <div class="row mb-4">
                                <div class="col-md-9">
                                    <label class="form-label" for="observacion">Observacion<span style="color: red;">*</span></label>
                                    <textarea class="form-control" id="observacion" name="observacion" placeholder="Observacion" rows="3" required></textarea>
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-submit w-100" 
                                            name="Boton" value="Boton" 
                                            style="background-color: #28539C; color: white; font-weight: bold;">
                                        Guardar
                                    </button>
                                </div>
                            </div> 
                            <div class="row mb-4">
                                <div class="col-md-9">
                                    <label class="form-label" for="descripcion"></label>
                                    <textarea hidden class="form-control" id="descripcion" name="descripcion" placeholder="descripcion" rows="3" required></textarea>
                                </div>

                                <input type="hidden" name="cantidad" id="cantidad" ><!-- comment -->
                                <input type="hidden" name="articulo" id="articulo" ><!-- comment -->
                                <input type="hidden" name="consecutivo" id="consecutivo" >
                            </div>   
                        </div> 
                    </form>
                </div>
            </div>
        </div>
        <div class="modal fade" id="infoModal" tabindex="-1" aria-labelledby="infoModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <%
                    boolean guardadoExitoso = false;
                    boolean errorGuardar = false;
                    if (request.getParameter("modal") != null) {
                        try {
                            // Capturar fecha y convertir a java.sql.Date
                            String codigo = request.getParameter("codigo");
                            String nombres = request.getParameter("nombre");
                           
                            // Crear objeto ControlTemperatura y asignar valores
                            ActivoFijos ct = new ActivoFijos();
                            ct.setCodigo(codigo);
                            ct.setNombre(nombres);
                            
                            // Guardar en la base de datos
                            ActivoFijosJpaController cp = new ActivoFijosJpaController();
                            cp.create(ct);
                            guardadoExitoso = true;
                        } catch (Exception e) {
                            errorGuardar = true;
                            e.printStackTrace(new java.io.PrintWriter(out)); // Opcional: solo para desarrollo
                        }
                    }
                %>

                <!-- Incluye SweetAlert2 -->
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                <!-- ? Alerta de éxito -->
                <% if (guardadoExitoso) { %>
                <script>
                    Swal.fire({
                        icon: 'success',
                        title: '¡Guardado correctamente!',
                        text: 'Los datos se guardaron correctamente.',
                        confirmButtonText: 'Aceptar'
                    });
                </script>
                <% } %>

                <!-- ? Alerta de error -->
                <% if (errorGuardar) { %>
                <script>
                    Swal.fire({
                        icon: 'error',
                        title: '¡Error!',
                        text: 'No se pudo guardar el registro. Verifica los campos o intenta más tarde.',
                        confirmButtonText: 'Aceptar'
                    });
                </script>
                <% }%>
                <div class="modal-content">

                    <!-- Encabezado -->
                    <div class="modal-header">
                        <h5 class="modal-title" id="infoModalLabel">Información del Artículo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>

                    <!-- Cuerpo -->
                    <div class="modal-body">
                        
                        <form action="requerimiento_compras.jsp" method="post">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="codigo" class="form-label"><strong>Código</strong></label>
                                    <input type="text" class="form-control" id="codigo" name="codigo" placeholder="Ingrese el código" required>
                                </div>
                                <div class="mb-3">
                                    <label for="articulo" class="form-label"><strong>Artículo</strong></label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Ingrese el artículo" required>
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-submit w-100" 
                                            name="modal" value="modal" 
                                            style="background-color: #28539C; color: white; font-weight: bold;">
                                        Guardar
                                    </button>
                                </div>
                            </div>

                            
                        </form>
                    <!-- Pie -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function guardarInformacion() {
                // Tomar valores de los campos
                let consecutivo = document.getElementById("consecutivos").value;
                let articulo = document.getElementById("articulos").value;
                let descripcion = document.getElementById("descripcions").value;
                let cantidad = document.getElementById("cantidads").value;

                if (!consecutivo || !articulo || !descripcion || !cantidad) {
                    alert("Todos los campos son obligatorios");
                    return;
                }

                // Mostrar la grilla si estaba oculta
                document.getElementById("contenedorGrilla").style.display = "block";

                // Crear fila en tabla detalle
                let template = document.getElementById("filaTemplate");
                let nuevaFila = template.content.cloneNode(true);

                nuevaFila.querySelector(".consecutivos input").value = consecutivo;
                nuevaFila.querySelector(".articulos input").value = articulo;
                nuevaFila.querySelector(".descripcions input").value = descripcion;
                nuevaFila.querySelector(".cantidads input").value = cantidad;

                // Poner texto visible en las celdas también
                nuevaFila.querySelector(".consecutivos").append(consecutivo);
                nuevaFila.querySelector(".articulos").append(articulo);
                nuevaFila.querySelector(".descripcions").append(descripcion);
                nuevaFila.querySelector(".cantidads").append(cantidad);

                // Botón eliminar
                nuevaFila.querySelector(".btn-danger").addEventListener("click", function () {
                    this.closest("tr").remove();
                    actualizarDescripcionPedidos();
                });

                document.getElementById("detalleRequerimiento").appendChild(nuevaFila);

                // Actualizar textarea de pedidos
                actualizarDescripcionPedidos();

                // Limpiar campos de entrada
                document.getElementById("consecutivos").value = "";
                document.getElementById("articulos").value = "";
                document.getElementById("descripcions").value = "";
                document.getElementById("cantidads").value = "";
            }

            // Función que recorre la tabla y construye el texto
            function actualizarDescripcionPedidos() {
                let filas = document.querySelectorAll("#detalleRequerimiento tr");
                let descripcionPedidos = "";

                filas.forEach((fila, i) => {
                    let consecutivo = fila.querySelector(".consecutivos input").value;
                    let articulo = fila.querySelector(".articulos input").value;
                    let descripcion = fila.querySelector(".descripcions input").value;
                    let cantidad = fila.querySelector(".cantidads input").value;

                    descripcionPedidos +=
                            (i + 1) + ". " + articulo + " (" + consecutivo + ") - " +
                            descripcion + " - Cantidad: " + cantidad + "\n";
                });

                document.querySelector("textarea[name='descripcion']").value = descripcionPedidos;
            }
        </script>

        <script>
            function calcularDuracion() {
                // Obtener los valores de las fechas
                let fechaEntrada = document.getElementById("fechaEntrada").value;
                let fechaEntrega = document.getElementById("fechaEntrega").value;

                // Verificar que ambas fechas estï¿½n seleccionadas
                if (fechaEntrada && fechaEntrega) {
                    // Convertir a objetos Date
                    let entrada = new Date(fechaEntrada);
                    let entrega = new Date(fechaEntrega);

                    // Calcular la diferencia en milisegundos
                    let diferencia = entrega - entrada;

                    // Convertir de milisegundos a dï¿½as
                    let dias = diferencia / (1000 * 60 * 60 * 24);

                    // Mostrar el resultado en el campo de duraciï¿½n
                    if (dias >= 0) {
                        document.getElementById("duracion").value = dias + " días";
                    } else {
                        document.getElementById("duracion").value = "Fecha invalida";
                    }
                }
            }
        </script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

        <script>
            $(document).ready(function () {
                $(".navbar-toggler").click(function () {
                    $("#sidebar").toggleClass("show");
                });
            });
        </script>
    </body>

</html>
<script>
    <% if (request.getParameter("Boton") != null) { %>
    Swal.fire({
        icon: 'success',
        title: '¡Guardado correctamente!',
        text: 'Los datos han sido guardados exitosamente.',
        confirmButtonText: 'Aceptar'
    });
    <% } %>
</script>

<%
    
    if (request.getParameter("Boton") != null) {
        try {
            // Capturar fecha y convertir a java.sql.Date
            String codigo = request.getParameter("codigo");
            String consecutivo = request.getParameter("consecutivo");
            String articulo = request.getParameter("articulo");
            String descripcion = request.getParameter("descripcion");
            String centrocosto = request.getParameter("costo");
            String cantidad = request.getParameter("cantidad");
            String usuario = request.getParameter("usuario");
            String observacion = request.getParameter("observacion");

            String fechaStr = request.getParameter("fecha");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date mFecha = sdf.parse(fechaStr);
            java.sql.Date fecha_sql = new java.sql.Date(mFecha.getTime());

            // Crear objeto ControlTemperatura y asignar valores
            Requerimiento ct = new Requerimiento();
            ct.setFecha(fecha_sql);
            ct.setCodigo(codigo);
            ct.setConsecutivo(consecutivo);
            ct.setDescripcion(descripcion);
            ct.setArticulo(articulo);
            ct.setCentrocosto(centrocosto);
            ct.setCantidad(cantidad);
            ct.setUsuario(usuario);
            ct.setObservacion(observacion);
            ct.setConsecutivo(consecutivo);
            // Guardar en la base de datos
            RequerimientoJpaController cp = new RequerimientoJpaController();
            cp.create(ct);
            guardadoExitoso = true;
        } catch (Exception e) {
            errorGuardar = true;
            e.printStackTrace(new java.io.PrintWriter(out)); // Opcional: solo para desarrollo
        }
    }
%>

<!-- Incluye SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- ? Alerta de éxito -->
<% if (guardadoExitoso) { %>
<script>
    Swal.fire({
        icon: 'success',
        title: '¡Guardado correctamente!',
        text: 'Los datos se guardaron correctamente.',
        confirmButtonText: 'Aceptar'
    });
</script>
<% } %>

<!-- ? Alerta de error -->
<% if (errorGuardar) { %>
<script>
    Swal.fire({
        icon: 'error',
        title: '¡Error!',
        text: 'No se pudo guardar el registro. Verifica los campos o intenta más tarde.',
        confirmButtonText: 'Aceptar'
    });
</script>
<% }%>