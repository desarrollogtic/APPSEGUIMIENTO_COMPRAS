package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/generarCodigo1")
public class GenerarCodigoServlet1 extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("APPACCESOPU");
    }

    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nuevoCodigo = "";
        response.setContentType("text/plain;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            EntityManager em = emf.createEntityManager();

            try {
                // Consulta para obtener el máximo número en el código (sin prefijo)
                Query query = em.createNativeQuery(
                    "SELECT MAX(CAST(SUBSTRING(codigo, 4, LEN(codigo)) AS INT)) FROM ACCESO_INTERNO"
                );
                Object result = query.getSingleResult();

                int ultimoCodigo = (result != null) ? ((Number) result).intValue() : 0;
                int siguienteCodigo = ultimoCodigo + 1;

                // Convertir número a cadena con al menos 6 dígitos (rellena con ceros)
                String numStr = Integer.toString(siguienteCodigo);
                if (numStr.length() < 6) {
                    numStr = String.format("%06d", siguienteCodigo);
                }
                // Código final con prefijo
                nuevoCodigo = "ACE" + numStr;

                out.print(nuevoCodigo);

            } catch (Exception e) {
                e.printStackTrace();
                out.print("ERROR: " + e.getMessage());
            } finally {
                em.close();
            }
        }
    }
}
