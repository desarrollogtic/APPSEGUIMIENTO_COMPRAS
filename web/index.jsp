<%@page import="controller.RolJpaController"%>
<%@page import="modell.Usuario"%>
<%@page import="modell.Rol"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="java.util.List"%>
<!doctype html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="asset1/login.css">
    <link rel="shortcut icon" href="asset1/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- CDN para SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <style>
        body{
            background-image: url('asset1/img/baner.jpg');
            background-size: cover; /* Para que la imagen cubra toda la pantalla */
            background-position: center; /* Centra la imagen */
            background-repeat: no-repeat; /* Evita que la imagen se repita */
            height: 75vh;
        }
    
    </style>
    <div class="wrapper" style="background-color: rgba(68, 85, 135, 0.4);">
        <div class="logo" style="text-align: center; ">
            <a href="http://192.168.1.59:8080/Menu/" style="text-decoration: none;">
                <img src="asset1/img/fondo.png" width="150px" alt="Ir a otra página">
            </a>
        </div>
        <form class="p-3 mt-3" method="post">
            <div class="form-field d-flex align-items-center py-3" >
                <select name="ro" id="ro" required>
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
                <input type="text" name="nombre" id="nombre" class="bi bi-person-check" placeholder="Usuario" required>
            </div>
            <div class="form-field d-flex align-items-center">
                <input type="password" name="clave" id="clave" class="bi bi-key" placeholder="Contraseña" required>
            </div>
            
            <br><br>
            <button type="submit" class="btn mt-3" name="boton1" value="boton1">INICIAR</button>
            <center>
                <label for="#"><a href="#" class="p-0">¿Olvidastes tu contraseña?</a></label>
            </center>
            
        </form>
       
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
    <script type="text/javascript">
        document.addEventListener('contextmenu', function(event) {
            event.preventDefault();
        });
    </script>

    <script type="text/javascript">
        document.onkeydown = function (e) {
            if (e.keyCode == 123) { // F12
                return false;
            }
            if (e.ctrlKey && (e.keyCode == 85)) { // Ctrl+U
                return false;
            }
            if (e.ctrlKey && (e.keyCode == 83)) { // Ctrl+S
                return false;
            }
        };
    </script>
  </body>
</html>

  
<% 
    if (request.getParameter("boton1") != null) {
        String nombre = request.getParameter("nombre");
        String clave = request.getParameter("clave");

        // Buscar al usuario por nombre
        UsuarioJpaController td = new UsuarioJpaController();
        Usuario usuario = td.findUsuarioByNombre(nombre); // Metodo nuevo para buscar por nombre
        
        if (usuario == null) {
%>            
        <script>
            Swal.fire({
                title: "Ingrese los datos nuevamente",
                text: "El usuario no existe",
                icon: "error"
            });
        </script>
<%
        } else {
            if (usuario.getClave().equals(clave)) {
                HttpSession sesion=request.getSession();
                sesion.setAttribute("user", usuario);
                response.sendRedirect("dashboard.jsp");
            } else {
%>
                <script>
                    Swal.fire({
                        title: "Clave incorrecta",
                        text: "Vuelvalo  a intentar",
                        icon: "error"
                    });
                </script>
<%
            }
        }
    }
%>