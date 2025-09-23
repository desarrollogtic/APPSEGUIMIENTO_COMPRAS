<%@page import="controller.ComprasJpaController"%>
<%@page import="modell.Compras"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="modell.Estado"%>
<%@page import="java.util.List"%>
<%@page import="controller.EstadoJpaController"%>
<%@page import="modell.Usuario"%>
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
    <title>Solicitud De Compras</title>
    <link rel="stylesheet" href="asset/css/normaliz.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="asset/css/style.css">
    <link rel="stylesheet" href="asset/css/compras.css">
    <link rel="shortcut icon" href="asset/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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
            <a class="navbar-brand" href="compras.jsp">Solicitud de compras</a>
            <a class="navbar-brand" href="compras.jsp"><img src="https://www.clinicasaludsocial.com/images/logo-full-color.jpg" alt="GIF sin fondo" width="150px" style="background-color: transparent;"></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </div>
    </nav>
    <!-- Main Content -->
    <div class="main-content py-5" style="">
        <div class="container py-5" style=" border-radius: 7px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); background-color:  #f4f6f6;">
        <h2><img src="asset/icons/seguimiento.gif" alt="GIF sin fondo" width="50px" style="background-color: transparent;"><strong>Seguimiento De La Solicitudes De Compras</strong></h2>
        <h4 style="text-align: center;" >CLINICA SALUD SOCIAL S.A.S</h4>
        <div class="form-container py-3">
            <script>
                // Función que genera el código automáticamente
                    function generarCodigoSCP() {
                        let numeros = "0123456789".split(""); // Convertimos la cadena en un array
                        let codigo = "SCP"; // Prefijo fijo
                        let codigoNumerico = "";

                        // Desordenamos el array para evitar repeticiones
                        for (let i = 0; i < 5; i++) {
                            let randomIndex = Math.floor(Math.random() * numeros.length);
                            codigoNumerico += numeros.splice(randomIndex, 1); // Eliminamos el número ya usado
                        }

                        document.getElementById("consecutivo").value = codigo + codigoNumerico;
                    }

                    // Llamamos a la función cuando la página se carga
                    window.onload = function() {
                        generarCodigoSCP();
                    };

            </script>
            <form action="compras.jsp" method="POST" >
                <div class="col-md-2 ms-auto py-3">
                    <label class="form-label" for="consecutivo">Codigo<span style="color: red;">*</span></label>
                    <input type="text" class="form-control" id="consecutivo" name="consecutivo" placeholder=""  readonly>
                </div>
                <div class="row mb-4">
                    <div class="col-md-3">
                        <label class="form-label" for="solicitud_num">Numero de solicitud<span style="color: red;">*</span></label>
                        <input type="text" class="form-control" id="solicitud_num" name="solicitud_num" placeholder="Numero de solicitud" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="area_solicitada">Area solicitada<span style="color: red;">*</span></label>
                        <select name="ar" id="ar" class="form-control" required>
                            <option value="">Seleccione</option>
                            <option value="URGENCIAS GENERAL">URGENCIAS GENERAL</option>
                            <option value="URGENCIAS PEDIATRICA">URGENCIAS PEDIATRICA</option>
                            <option value="URGENCIAS GINECOLOGICA">URGENCIAS GINECOLOGICA</option>
                            <option value="UCI ADULTO">UCI ADULTO</option>
                            <option value="UCI NEONATAL">UCI NEONATAL</option>
                            <option value="CIRUGIA GENERAL">CIRUGIA GENERAL</option>
                            <option value="CIRUGIA GINECOLOGICA">CIRUGIA GINECOLOGICA</option>
                            <option value="HOSPITALIZACION SAN GABRIEL">HOSPITALIZACION SAN GABRIEL</option>
                            <option value="HOSPITALIZACION SAN LUCAS">HOSPITALIZACION SAN LUCAS</option>
                            <option value="HOSPITALIZACION SAN MIGUEL">HOSPITALIZACION SAN MIGUEL</option>
                            <option value="HOSPITALIZACION SAN RAFAEL">HOSPITALIZACION SAN RAFAEL</option>
                            <option value="HOSPITALIZACION SAN ANTONIO">HOSPITALIZACION SAN ANTONIO </option>
                            <option value="HOSPITALIZACION SAN ANTONIO 1">HOSPITALIZACION SAN ANTONIO 1</option>
                            <option value="HOSPITALIZACION SAGRADO CORAZON">HOSPITALIZACION SAGRADO CORAZON</option>
                            <option value="HOSPITALIZACION SAGRADO CORAZON 1">HOSPITALIZACION SAGRADO CORAZON 1</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="descripcion_solicitud">Descripcion de solicitud<span style="color: red;">*</span></label>
                        <input type="text" class="form-control" id="descripcion_solicitud" name="descripcion_solicitud" placeholder="Descripcion" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="fecha_solicitud">Fecha de solicitud<span style="color: red;">*</span></label>
                        <input type="date" class="form-control" id="fechaSolicitud" name="fechaSolicitud" placeholder="Solicitud" required>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-3">
                        <label class="form-label" for="vb_compras">Numero de orden de compra<span style="color: red;">*</span></label>
                        <input type="text" name="co" id="co" class="form-control" placeholder="" >
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="estado_solicitud">Estado de solicitud<span style="color: red;">*</span></label>
                        <select name="es" id="es" class="form-control" required>
                            <option value="">Seleccione</option>
                            <%
                                EstadoJpaController compras = new EstadoJpaController();
                                List<Estado> lista = compras.findEstadoEntities();
                                for(Estado ipt: lista) {
                                    out.print("<option value='"+ipt.getCodigo()+"'>"+ipt.getNombre()+"</option>");
                                }
                            %> 
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="proveedor">Nombre del proveedor<span style="color: red;">*</span></label>
                        <input type="text" class="form-control" id="proveedor" name="proveedor" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="fecha_envio">Fecha de envio<span style="color: red;">*</span></label>
                        <input type="date" class="form-control" id="fechaEnvio" name="fechaEnvio" placeholder="Envio" required>
                    </div>
                </div>
                <div class="row mb-4">
                    <div class="col-md-3">
                        <label class="form-label" for="fecha_entrada">Fecha de entrada<span style="color: red;">*</span></label>
                        <input type="date" class="form-control" id="fechaEntrada" name="fechaEntrada" required onchange="calcularDuracion()">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="fecha_entrega">Fecha de entrega<span style="color: red;">*</span></label>
                        <input type="date" class="form-control" id="fechaEntrega" name="fechaEntrega" placeholder="Entrega" required onchange="calcularDuracion()">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="duracion">Duracion<span style="color: red;">*</span></label>
                        <input type="text" class="form-control" id="duracion" name="duracion" placeholder="Tiempo total" readonly>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="observacion">Conformidad del solicitante<span style="color: red;">*</span></label>
                        <select name="con" id="con" class="form-control" required>
                            <option value="">Seleccione</option>
                            <option value="Si">Si</option>
                            <option value="No">No</option>
                            
                        </select>
                    </div>
                </div>
                <div class="row mb-4">
                    <div class="col-md-9">
                        <label class="form-label" for="observacion">Observacion<span style="color: red;">*</span></label>
                        <textarea class="form-control" id="observacion" name="observacion" placeholder="Observacion" rows="3" required></textarea>
                    </div>
                        <input type="hidden" id="visi" name="visi" value="<% if(u != null) {out.print(u.getEmpleado()); } %>">
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-submit w-100" name="Boton" value="Boton">Guardar</button>
                    </div>
                </div>    
                
            </form>
        </div>
    </div>
    </div>
    
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
        
            // Capturar fecha y convertir a java.sql.Date
            String numeros = request.getParameter("solicitud_num");
            String area = request.getParameter("ar");
            String descripcion = request.getParameter("descripcion_solicitud");
            String vbcompras = request.getParameter("co");
            String provedorId = request.getParameter("proveedor");
            String duracionId = request.getParameter("duracion");
            String conformidad = request.getParameter("co");
            String observacionId = request.getParameter("observacion");
            String visibleId = request.getParameter("visi");
            String consecutivo = request.getParameter("consecutivo");
            
            String fechaStr = request.getParameter("fechaSolicitud");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date mFecha = sdf.parse(fechaStr);
            java.sql.Date fecha_sql = new java.sql.Date(mFecha.getTime());
            
            String fechaenvioStr = request.getParameter("fechaEnvio");
            SimpleDateFormat sdfenvio = new SimpleDateFormat("yyyy-MM-dd");
            Date EFecha = sdfenvio.parse(fechaenvioStr);
            java.sql.Date fechaenvio_sql = new java.sql.Date(EFecha.getTime());
            
            String fechaentradaStr = request.getParameter("fechaEntrada");
            SimpleDateFormat sdfentrada = new SimpleDateFormat("yyyy-MM-dd");
            Date EnFecha = sdfentrada.parse(fechaentradaStr);
            java.sql.Date fechaentrada_sql = new java.sql.Date(EnFecha.getTime());
            
            String fechaentregaStr = request.getParameter("fechaEntrega");
            SimpleDateFormat sdfentrega = new SimpleDateFormat("yyyy-MM-dd");
            Date EntFecha = sdfentrega.parse(fechaentregaStr);
            java.sql.Date fechaentrega_sql = new java.sql.Date(EntFecha.getTime());
            
            int estadoId = Integer.parseInt(request.getParameter("es"));
            EstadoJpaController jornadaController = new EstadoJpaController();
            Estado es = jornadaController.findEstado(estadoId);
            
            
           

            // Crear objeto ControlTemperatura y asignar valores
            Compras ct = new Compras();
            ct.setNumeroSolicitud(numeros);
            ct.setArea(area);
            ct.setDescripcion(descripcion);
            ct.setVbComprar(vbcompras);
            ct.setNombreProveedor(provedorId);
            ct.setDuracion(duracionId);
            ct.setConformidad(conformidad);
            ct.setObservacion(observacionId);
            ct.setESTADOcodigo(es);
            ct.setFechaSolicitud(fecha_sql);
            ct.setFechaEnvio(fechaenvio_sql);
            ct.setFechaEntrada(fechaentrada_sql);
            ct.setFechaEntrega(fechaentrega_sql);
            ct.setGenerado(visibleId);
            ct.setConsecutivo(consecutivo);
            // Guardar en la base de datos
            ComprasJpaController cp = new ComprasJpaController();
            cp.create(ct);
        }
%>
