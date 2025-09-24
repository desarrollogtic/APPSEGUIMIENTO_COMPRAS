<%@page import="modell.Requerimiento"%>
<%@page import="controller.RequerimientoJpaController"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
    Requerimiento pp = new Requerimiento();
    if (request.getParameter("id") != null) {
        int id = Integer.parseInt(request.getParameter("id"));
        RequerimientoJpaController p = new RequerimientoJpaController();
        pp = p.findRequerimiento(id);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Actualizar Estado</title>
  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

  <div class="container py-5">
    <div class="card shadow-lg rounded-4">
      <div class="card-body">
        <form>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    let hoy = new Date().toISOString().split("T")[0];
                    document.getElementById("fecha").value = hoy;
                });
            </script>
          <div class="row g-3">
            <!-- Campo Estado -->
            <input type="hidden"  name="id" value="<%=pp.getId()%>">
            <%
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                String fechaFormateada = "";
                if (pp.getFecha()!= null) {
                    fechaFormateada = sdf.format(pp.getFecha());
                }
            %>
            <input type="hidden" id="fecha" name="fecha" class="form-control" value="<%= fechaFormateada%>" required>
            <div class="col-md-3">
              <label for="estado" class="form-label">Estado</label>
              <select id="estado" name="estado" class="form-select" required>
                <option value="">Seleccione...</option>
                <%
                    String cargadaGuardada = (pp.getArticulo()!= null) ? pp.getArticulo() : "";
                    String[] cinformidades = {
                        "PENDIENTE",
                        "ENTREGADO",
                        "RECHAZADO",
                        "ENTREGO-PARCIALMENTE"
                    };

                    for (String estado : cinformidades) {
                %>
                <option value="<%= estado%>" <%= estado.equals(cargadaGuardada) ? "selected" : ""%>>
                    <%= estado%>
                </option>
                <% }%>
              </select>
            </div>
          </div>

          <div class="mt-4">
              <button type="submit" class="btn btn-primary px-4" value="guardar" name="guardar">Guardar</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
            function cerrarse() {
                opener.location.reload();
                window.close();
            }
        </script>

</body>
</html>
<%
    if (request.getParameter("guardar") != null) {
        try {
            // Capturar parámetros del formulario
            int id = Integer.parseInt(request.getParameter("id"));
            String estados = request.getParameter("estado");

            // Crear objeto Inventario y asignar valores
            RequerimientoJpaController cpa = new RequerimientoJpaController();
            Requerimiento en = cpa.findRequerimiento(id);
            en.setId(id);
            en.setArticulo(estados);
            // Guardar en la base de datos
            cpa.create(en);

        } catch (Exception e) {
            out.println("<p style='color: red;'>Error al procesar la solicitud: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out)); // Muestra traza detallada en el navegador
            out.println("</pre>");
        }
%>
<script>
  cerrarse();
</script>
<%
    }
%>