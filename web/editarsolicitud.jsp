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
    Compras pp=new Compras();
    if (request.getParameter("id")!=null);
    {
        int id=Integer.parseInt(request.getParameter("id"));
        ComprasJpaController p= new ComprasJpaController();
        pp=p.findCompras(id);
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
        <div class="container py-5" style=" border-radius: 7px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); background-color:  #ffffff;">
        <h2><strong>Seguimiento De La Solicitudes De Compras</strong></h2>
        <div class="form-container ">
            <form action="editarsolicitud.jsp" method="POST" >
                <div class="row mb-4">
                    <input type="hidden" name="id" value="<%=pp.getId()%>">
                    <div class="col-md-3">
                        <label class="form-label" for="solicitud_num">Numero de solicitud:</label>
                        <input type="text" class="form-control" id="solicitud_num" name="solicitud_num" placeholder="Numero de solicitud" required value="<%=pp.getNumeroSolicitud()%>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="area_solicitada">Area solicitada:</label>
                        <select name="ar" id="ar" class="form-control" required>
                           <%
                                String areaGuardada = (pp.getArea()!= null) ? pp.getArea() : ""; 
                                String[] areas = {
                                    "URGENCIAS GENERAL",
                                    "URGENCIAS PEDIATRICA",
                                    "URGENCIAS GINECOLOGICA",
                                    "UCI ADULTO",
                                    "UCI NEONATAL",
                                    "CIRUGIA GENERAL",
                                    "CIRUGIA GINECOLOGICA",
                                    "HOSPITALIZACION SAN GABRIEL",
                                    "HOSPITALIZACION SAN LUCAS",
                                    "HOSPITALIZACION SAN MIGUEL",
                                    "HOSPITALIZACION SAN RAFAEL",
                                    "HOSPITALIZACION SAN ANTONIO",
                                    "HOSPITALIZACION SAN ANTONIO 1",
                                    "HOSPITALIZACION SAGRADO CORAZON",
                                    "HOSPITALIZACION SAGRADO CORAZON 1"
                                };
                                for (String area : areas) {
                            %>
                                <option value="<%= area %>" <%= area.equals(areaGuardada) ? "selected" : "" %>>
                                    <%= area %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="descripcion_solicitud">Descripcion de solicitud:</label>
                        <input type="text" class="form-control" id="descripcion_solicitud" name="descripcion_solicitud" placeholder="Descripcion" required value="<%=pp.getDescripcion()%>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="fecha_solicitud">Fecha de solicitud:</label>
                        <input type="date" class="form-control" id="fechaSolicitud" name="fechaSolicitud" placeholder="Solicitud" required value="<%= new SimpleDateFormat("yyyy-MM-dd").format(pp.getFechaSolicitud()) %>">
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-3">
                        <label class="form-label" for="vb_compras">Numero de orden de compra<span style="color: red;">*</span></label>
                        <input type="text" name="co" id="co" class="form-control" placeholder="" value="<%=pp.getVbComprar()%>" >
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="estado_solicitud">Estado de solicitud:</label>
                        <select name="es" id="es" class="form-control" required>
                            <option value="">Seleccione</option>
                            <%
                                EstadoJpaController compras = new EstadoJpaController();
                                List<Estado> lista = compras.findEstadoEntities();
                                for(Estado ipt: lista) {
                                    if (pp.getESTADOcodigo().getCodigo()==ipt.getCodigo()){
                                            out.print("<option value='" + ipt.getCodigo() + "' selected>" + ipt.getNombre() + "</option>");
                                        } else {
                                        out.print("<option value='"+ipt.getCodigo()+"'>"+ipt.getNombre()+"</option>");
                                    }
                                }
                            %> 
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="proveedor">Nombre del proveedor:</label>
                        <input type="text" class="form-control" id="proveedor" name="proveedor" required value="<%=pp.getNombreProveedor()%>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="fecha_envio">Fecha de envio:</label>
                        <input type="date" class="form-control" id="fechaEnvio" name="fechaEnvio" placeholder="Envio" required value="<%= new SimpleDateFormat("yyyy-MM-dd").format(pp.getFechaEnvio()) %>">
                    </div>
                </div>
                <div class="row mb-4">
                    <div class="col-md-3">
                        <label class="form-label" for="fecha_entrada">Fecha de entrada:</label>
                        <input type="date" class="form-control" id="fechaEntrada" name="fechaEntrada" required onchange="calcularDuracion()" value="<%= new SimpleDateFormat("yyyy-MM-dd").format(pp.getFechaEntrada()) %>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="fecha_entrega">Fecha de entrega:</label>
                        <input type="date" class="form-control" id="fechaEntrega" name="fechaEntrega" placeholder="Entrega" required onchange="calcularDuracion()" value="<%= new SimpleDateFormat("yyyy-MM-dd").format(pp.getFechaEntrega()) %>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="duracion">Duracion:</label>
                        <input type="text" class="form-control" id="duracion" name="duracion" placeholder="Tiempo total" readonly value="<%=pp.getDuracion()%>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label" for="observacion">Conformidad del solicitante:</label>
                        <select name="con" id="con" class="form-control" required>
                              <%
                                    String observacionGuardada = (pp.getConformidad()!= null) ? pp.getConformidad(): ""; 
                                    String[] conformidades = {
                                        "SI", 
                                        "NO"
                                    };

                                    for (String con : conformidades) {
                                %>
                                    <option value="<%= con%>" <%= con.equals(observacionGuardada) ? "selected" : "" %>>
                                        <%= con %>
                                    </option>
                                <% } %>
                            
                        </select>
                    </div>
                </div>
                <div class="row mb-4">
                    <div class="col-md-9">
                        <label class="form-label" for="observacion">Observacion:</label>
                        <textarea class="form-control" id="observacion" name="observacion" placeholder="Observacion" rows="3" required><%=pp.getObservacion()%></textarea>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-submit w-100" name="actualizar" value="actualizar">Editar</button>
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
      <script>
            function calcularDuracion() {
                // Obtener los valores de las fechas
                let fechaEntrada = document.getElementById("fechaEntrada").value;
                let fechaEntrega = document.getElementById("fechaEntrega").value;

                // Verificar que ambas fechas est�n seleccionadas
                if (fechaEntrada && fechaEntrega) {
                    // Convertir a objetos Date
                    let entrada = new Date(fechaEntrada);
                    let entrega = new Date(fechaEntrega);

                    // Calcular la diferencia en milisegundos
                    let diferencia = entrega - entrada;

                    // Convertir de milisegundos a d�as
                    let dias = diferencia / (1000 * 60 * 60 * 24);

                    // Mostrar el resultado en el campo de duraci�n
                    if (dias >= 0) {
                        document.getElementById("duracion").value = dias + " d�as";
                    } else {
                        document.getElementById("duracion").value = "Fecha inv�lida";
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
            String numeros = request.getParameter("solicitud_num");
            String area = request.getParameter("ar");
            String descripcion = request.getParameter("descripcion_solicitud");
            String vbcompras = request.getParameter("co");
            String provedorId = request.getParameter("proveedor");
            String duracionId = request.getParameter("duracion");
            String conformidad = request.getParameter("co");
            String observacionId = request.getParameter("observacion");
            
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
            ComprasJpaController cp = new ComprasJpaController();
            Compras ct = cp.findCompras(id);
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
            // Guardar en la base de datos
            cp.edit(ct);
    %>
    <script>
      cerrarse();
    </script>
       <%
    }  
%>
