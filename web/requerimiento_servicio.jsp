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
                    <i class="bi bi-search"></i> Consulta De Compras
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
        <h2><img src="asset/icons/seguimiento.gif" alt="GIF sin fondo" width="50px" style="background-color: transparent;"><strong>Requerimiento De Compras</strong></h2>
        <h4 style="text-align: center;" >CLINICA SALUD SOCIAL S.A.S</h4>
        <div class="form-container py-3">
            
            <form action="requerimiento_compras.jsp" method="POST" >
                <div class="row mb-4">
                    <div class="col-md-2">
                        <label class="form-label" for="consecutivo">Codigo<span style="color: red;">*</span></label>
                        <input type="text" class="form-control" id="codigo" name="codigo" placeholder=""  >
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
                        <label class="form-label" for="">Fecha<span style="color: red;">*</span></label>
                        <input type="date" class="form-control" id="fecha" name="fecha"  required>
                    </div>
                </div>
                <div class="row mb-4">

                    <div class="col-md-2">
                        <label class="form-label" for="">Consecutivo<span style="color: red;">*</span></label>
                        <input type="text" class="form-control" id="consecutivo" name="consecutivo" placeholder="Descripcion" required>
                    </div>
                    <div class="col-md-5">
                        <label class="form-label" for="">Tipo<span style="color: red;">*</span></label>
                        <input type="text" name="articulo" id="articulo" class="form-control" placeholder="" >
                    </div>
                    <div class="col-md-5">
                        <label class="form-label" for="">Descripcion de solicitud<span style="color: red;">*</span></label>
                        <textarea  class="form-control" id="descripcion" name="descripcion" placeholder="Descripcion" rows="1" required></textarea>
                    </div>
                </div>
                <div class="row mb-4">
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
                        <label class="form-label" for="">Cantidad<span style="color: red;">*</span></label>
                        <input type="text" name="cantidad" id="cantidad" class="form-control" placeholder="" >
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="">Usuario<span style="color: red;">*</span></label>
                        <input type="text" name="usuario" id="usuario" class="form-control" placeholder="" readonly value="<% if(u != null) {out.print(u.getEmpleado()); } %>">
                    </div>
                </div>
                <div class="row mb-4">
                    <div class="col-md-9">
                        <label class="form-label" for="observacion">Observacion<span style="color: red;">*</span></label>
                        <textarea class="form-control" id="observacion" name="observacion" placeholder="Observacion" rows="3" required></textarea>
                    </div>
                        <input type="hidden" id="visi" name="visi" >
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
     boolean guardadoExitoso = false;
    boolean errorGuardar = false;
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