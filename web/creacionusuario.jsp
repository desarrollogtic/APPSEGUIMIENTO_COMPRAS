<%@page import="modell.Rol"%>
<%@page import="controller.RolJpaController"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="modell.Estado"%>
<%@page import="controller.EstadoJpaController"%>
<%@page import="modell.Compras"%>
<%@page import="java.util.List"%>
<%@page import="controller.ComprasJpaController"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
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
    <title>Creacion de Usuario</title>
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
            <a class="navbar-brand" href="compras.jsp">Crear usuario</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </div>
    </nav>
    <!-- Main Content -->
    <div class="main-content" style="">
        <div class="container py-5" style=" border-radius: 7px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); background-color:  #ffffff;">
        <h2><img src="asset/icons/usuario.gif" alt="GIF sin fondo" width="50px" style="background-color: transparent;"><strong>Crear usuario</strong></h2>
        <form class="p-3 mt-3" method="post">
            <div class="form-field d-flex align-items-center py-3" >
                <select name="ro" id="ro" class="form-select"   required>
                    <option value="">Seleccione</option>
                    <%
                            RolJpaController rol = new RolJpaController();
                            List<Rol> lista = rol.findRolEntities();
                            for(Rol ipt: lista) {
                                    out.print("<option value='"+ipt.getCodigo()+"'>"+ipt.getNombre()+"</option>");
                                }
                            %>
                </select>
                
            </div>
            <div class="form-field d-flex align-items-center py-3">
                <input type="text" name="nombre" id="nombre" class="bi bi-person-check form-control" placeholder="Usuario" required>
            </div>
            <div class="form-field d-flex align-items-center py-3">
                <input type="text" name="empleado" id="empleado" class="bi bi-person-check form-control" placeholder="Nombre" required>
            </div>
            <div class="form-field d-flex align-items-center">
                <input type="password" name="clave" id="clave" class="bi bi-key form-control" placeholder="Contrasena" required>
            </div>
            
            <br><br>
            <button type="submit" class="btn btn-submit w-100" name="crear" value="crear">CREAR</button>  
        </form>

    </div>
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
    <script>
    <% if (request.getParameter("cambiarClave") != null) { %>
            Swal.fire({
                icon: 'success',
                title: '¡Cambiada correctamente!s',
                text: 'Los datos han sido guardados exitosamente.',
                confirmButtonText: 'Aceptar'
            });
      <% } %>
</script>
</body>

</html>

<% 
    if (request.getParameter("crear") != null) {
        String nombres = request.getParameter("nombre");
        String empleados = request.getParameter("empleado");
        String claves = request.getParameter("clave");
        
        int Rol = Integer.parseInt(request.getParameter("ro"));
        RolJpaController rolController = new RolJpaController();
        Rol ro = rolController.findRol(Rol);
        
        Usuario usua = new  Usuario();
        usua.setNombre(nombres);
        usua.setEmpleado(empleados);
        usua.setClave(claves);
        usua.setROLcodigo(ro);
        
        UsuarioJpaController us = new UsuarioJpaController();
        us.create(usua);
    }
        

%>            


