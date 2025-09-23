/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import modell.Rol;
import modell.Usuario;

/**
 *
 * @author Desarrollo_GTIC
 */
public class UsuarioJpaController implements Serializable {

    public UsuarioJpaController() {
        this.emf = Persistence.createEntityManagerFactory("APPSEGUIMIENTO_COMPRASPU");
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Usuario usuario) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Rol ROLcodigo = usuario.getROLcodigo();
            if (ROLcodigo != null) {
                ROLcodigo = em.getReference(ROLcodigo.getClass(), ROLcodigo.getCodigo());
                usuario.setROLcodigo(ROLcodigo);
            }
            em.persist(usuario);
            if (ROLcodigo != null) {
                ROLcodigo.getUsuarioList().add(usuario);
                ROLcodigo = em.merge(ROLcodigo);
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Usuario usuario) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Usuario persistentUsuario = em.find(Usuario.class, usuario.getId());
            Rol ROLcodigoOld = persistentUsuario.getROLcodigo();
            Rol ROLcodigoNew = usuario.getROLcodigo();
            if (ROLcodigoNew != null) {
                ROLcodigoNew = em.getReference(ROLcodigoNew.getClass(), ROLcodigoNew.getCodigo());
                usuario.setROLcodigo(ROLcodigoNew);
            }
            usuario = em.merge(usuario);
            if (ROLcodigoOld != null && !ROLcodigoOld.equals(ROLcodigoNew)) {
                ROLcodigoOld.getUsuarioList().remove(usuario);
                ROLcodigoOld = em.merge(ROLcodigoOld);
            }
            if (ROLcodigoNew != null && !ROLcodigoNew.equals(ROLcodigoOld)) {
                ROLcodigoNew.getUsuarioList().add(usuario);
                ROLcodigoNew = em.merge(ROLcodigoNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = usuario.getId();
                if (findUsuario(id) == null) {
                    throw new NonexistentEntityException("The usuario with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(Integer id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Usuario usuario;
            try {
                usuario = em.getReference(Usuario.class, id);
                usuario.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The usuario with id " + id + " no longer exists.", enfe);
            }
            Rol ROLcodigo = usuario.getROLcodigo();
            if (ROLcodigo != null) {
                ROLcodigo.getUsuarioList().remove(usuario);
                ROLcodigo = em.merge(ROLcodigo);
            }
            em.remove(usuario);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
     public Usuario findUsuarioByNombre(String nombre) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT u FROM Usuario u WHERE u.nombre = :nombre");
            query.setParameter("nombre", nombre);
            List<Usuario> usuarios = query.getResultList();
            return (usuarios.isEmpty()) ? null : usuarios.get(0); // Devuelve el primer usuario encontrado
        } finally {
            em.close();
        }
    }
    public List<Usuario> findUsuarioEntities() {
        return findUsuarioEntities(true, -1, -1);
    }

    public List<Usuario> findUsuarioEntities(int maxResults, int firstResult) {
        return findUsuarioEntities(false, maxResults, firstResult);
    }

    private List<Usuario> findUsuarioEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Usuario.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Usuario findUsuario(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Usuario.class, id);
        } finally {
            em.close();
        }
    }

    public int getUsuarioCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Usuario> rt = cq.from(Usuario.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
