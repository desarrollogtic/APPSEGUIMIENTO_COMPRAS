<%@page import="modell.Requerimiento"%>
<%@page import="controller.RequerimientoJpaController"%>
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
<%
    Requerimiento pp=new Requerimiento();
    if (request.getParameter("id")!=null);
    {
        int id=Integer.parseInt(request.getParameter("id"));
        RequerimientoJpaController p= new RequerimientoJpaController();
        pp=p.findRequerimiento(id);
    }
%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar estado</title>
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
        <div class="container py-5" style=" border-radius: 7px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); background-color:  #ffffff;">
        <h2><strong></strong></h2>
        <div class="form-container ">
            <form action="estado.jsp" method="POST" >
                <div class="row mb-4">
                    <input type="hidden" name="id" value="<%=pp.getId()%>">
                    <div class="col-md-3">
                        <label class="form-label" for="area_solicitada">Estado:</label>
                        <select name="ar" id="ar" class="form-control" required>
                           <%
                                String areaGuardada = (pp.getArticulo()!= null) ? pp.getArticulo() : ""; 
                                String[] areas = {
                                    "PENDIENTE",
                                    "ENTREGADO",
                                    "ENTREGO-PARCIALMENTE",
                                    "RECHAZADO"
                                    
                                };

                                for (String articulo : areas) {
                            %>
                                <option value="<%= articulo %>" <%= articulo.equals(areaGuardada) ? "selected" : "" %>>
                                    <%= articulo %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                        <div class="col-md-4">
                            <label class="form-label" for="fecha_solicitud">Observacion<span style="color: red;">*</span></label>
                            <input type="text" class="form-control" id="observacion" name="observacion" value="<%=pp.getObservacion()%>" required>
                        </div>
                    
                </div>

                <div class="row mb-4">
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-submit w-100" name="actualizar" value="actualizar">Actualizar</button>
                    </div>
                </div>    
                
                
            </form>
        </div>
    </div>
     <script>
        function cerrarse() {
            opener.location.reload();
            window.close();
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
<% if (request.getParameter("actualizar") != null) { %>
            Swal.fire({
                icon: 'success',
                title: '�Guardado correctamente!',
                text: 'Los datos han sido guardados exitosamente.',
                confirmButtonText: 'Aceptar'
            });
      <% } %>
</script>

<%
    if (request.getParameter("actualizar") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            // Capturar fecha y convertir a java.sql.Date
            String articulo = request.getParameter("ar");
            String observacion = request.getParameter("observacion");
            
            // Crear objeto ControlTemperatura y asignar valores
            RequerimientoJpaController cp = new RequerimientoJpaController();
            Requerimiento ct = cp.findRequerimiento(id);
            ct.setObservacion(observacion);
            ct.setArticulo(articulo);
            // Guardar en la base de datos
            cp.create(ct);
    %>
    <script>
      cerrarse();
    </script>
       <%
    }  
%>
