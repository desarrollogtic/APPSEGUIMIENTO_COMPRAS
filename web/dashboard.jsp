<%@page import="modell.Compras"%>
<%@page import="java.util.List"%>
<%@page import="controller.ComprasJpaController"%>
<%@page import="modell.Usuario"%>
<% 
    HttpSession sesion = request.getSession();
    Usuario u = (Usuario) sesion.getAttribute("user");

    if (u == null) {
        response.sendRedirect("index.jsp");
    }
%>
<%
    ComprasJpaController solicitudController = new ComprasJpaController();
    List<Compras> solicitudes = solicitudController.findComprasEntities();
    
    int solicitudesPendientes = 0;
    int solicitudesSolicitado = 0;
    int solicitudesEntregado = 0;
    int solicitudesRechazado = 0;
    for (Compras solicitud : solicitudes) {
        if ("Pendiente".equalsIgnoreCase(solicitud.getESTADOcodigo().getNombre())) {
            solicitudesPendientes++;
        }
    }
    for (Compras solicitud : solicitudes) {
        if ("solicitado".equalsIgnoreCase(solicitud.getESTADOcodigo().getNombre())) {
            solicitudesSolicitado++;
        }
    }
    for (Compras solicitud : solicitudes) {
        if ("entregado".equalsIgnoreCase(solicitud.getESTADOcodigo().getNombre())) {
            solicitudesEntregado++;
        }
    }
    for (Compras solicitud : solicitudes) {
        if ("rechazado".equalsIgnoreCase(solicitud.getESTADOcodigo().getNombre())) {
            solicitudesRechazado++;
        }
    }
%>

<%
    // Recuperar las solicitudes de GTIC guardadas 
    int totalSolicitudes = solicitudes.size();
    
%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link rel="shortcut icon" href="asset/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="asset/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

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
                <% if(u != null) {
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
            <% if ( u != null && u.getROLcodigo() != null && "ADMINISTRADOR".equals(u.getROLcodigo().getNombre())) { %>
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
             <% } else if ( u != null && u.getROLcodigo() != null && "COMPRAS".equals(u.getROLcodigo().getNombre())) { %>
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
            <% } else{ %>
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
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </div>
    </nav>
    <!-- Main Content -->
    <div class="main-content p-4">
        <div class="container-fluid">
            <div class="row g-3">
                <div class="col-md-6 col-lg-3">
                    <div class="card bg-one overview-card border-0" style="background-color: rgba(251, 188, 4);">
                        <div class="card-body text-center">
                            <div ><img src="asset/icons/pendiente.png" alt="" width="50px"></div>
                            <h5>Pendiente</h5>
                            <h1><%= solicitudesPendientes %></h1>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card bg-two overview-card border-0" style="background-color: rgb(52, 187, 228);">
                        <div class="card-body text-center">
                            <div ><img src="asset/icons/solicitantes.png" alt="" width="50px"></div>
                            <h5>Solicitado</h5>
                            <h1><%= solicitudesSolicitado %></h1>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card bg-three overview-card border-0" style="background-color: rgb(196, 35, 35);">
                        <div class="card-body text-center">
                            <div ><img src="asset/icons/rechazar.png" alt="" width="50px"></div>
                            <h5>Rechazado</h5>
                            <h1><%= solicitudesRechazado %></h1>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card bg-four overview-card border-0" style="background-color: rgba(52, 168, 83);">
                        <div class="card-body text-center">
                            <div ><img src="asset/icons/entrega.png" alt="" width="50px"></div>
                            <h5>Entregado</h5>
                            <h1><%= solicitudesEntregado %></h1>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row mt-4 cd">
                <div class="col-md-6 col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="cd">
                                <p style="font-size: 45px">CLINICA SALUD SOCIAL S.A.S</p>
                                 <p><em>Con pasión para servir</em></p>
                            </div>
                        </div>
                        <style>
                            .cd {
                                margin: 0;
                                padding: 0;
                                text-align: center;
                            }
                            .cd p {
                                margin: 0;
                                padding: 0;
                            }
                        </style>
                    </div>
                </div>
                <div class="col-md-6 col-lg-6">
                    <div class="card border-0">
                        <div class="card-body">
                            <div class="container py-5">
                                <h2 style="text-align: center;"><strong>Grafica de estados de solicitudes</strong></h2>
                                <canvas id="solicitudesChart" width="5" height="5"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Today's Appointments Table -->
               <script>
                // Crear una funciï¿½n que se ejecute cuando se haya cargado el contenido de la pï¿½gina
                window.onload = function() {
                    // Aquï¿½ se agregan los datos obtenidos del backend para crear el grï¿½fico
                    var estados = ["Pendiente", "Solicitado", "Rechazado", "Entregado"]; // Estados posibles
                    var cantidadSolicitudes = [<%= solicitudesPendientes %>, <%= solicitudesSolicitado %>, <%= solicitudesRechazado %>, <%= solicitudesEntregado %>];

                    // Configuraciï¿½n del grï¿½fico
                    var ctx = document.getElementById('solicitudesChart').getContext('2d');
                    var chart = new Chart(ctx, {
                        type: 'pie', // Cambiar tipo a 'pie' para grï¿½fica circular
                        data: {
                            labels: estados, // Las etiquetas serï¿½n los estados de las solicitudes
                            datasets: [{
                                label: 'Estados de Solicitudes',
                                data: cantidadSolicitudes, // Datos de cantidad de solicitudes
                                backgroundColor: [
                                    'rgba(251, 188, 4, 0.5)',  // Color para "Pendiente"
                                    'rgba(52, 187, 228, 0.5)',  // Color para "Solicitado"
                                    'rgba(196, 37, 34, 0.5)',  // Color para "Rechazado"
                                    'rgba(52, 168, 83, 0.5)'   // Color para "Entregado"
                                ],
                                borderColor: [
                                    'rgba(251, 188, 4, 1)',    // Color del borde para "Pendiente"
                                    'rgba(52, 187, 228, 1)',    // Color del borde para "Solicitado"
                                    'rgba(196, 37, 34, 1)',    // Color del borde para "Rechazado"
                                    'rgba(52, 168, 83, 1)'     // Color del borde para "Entregado"
                                ],
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {
                                    position: 'top'
                                },
                                tooltip: {
                                    enabled: true
                                }
                            }
                        }
                    });
                };
                </script>          
        </div>
    </div>

        
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