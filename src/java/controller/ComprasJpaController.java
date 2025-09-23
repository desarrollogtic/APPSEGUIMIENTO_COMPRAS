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
import modell.Compras;
import modell.Estado;

/**
 *
 * @author Desarrollo_GTIC
 */
public class ComprasJpaController implements Serializable {

    public ComprasJpaController() {
        this.emf = Persistence.createEntityManagerFactory("APPSEGUIMIENTO_COMPRASPU");
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Compras compras) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Estado ESTADOcodigo = compras.getESTADOcodigo();
            if (ESTADOcodigo != null) {
                ESTADOcodigo = em.getReference(ESTADOcodigo.getClass(), ESTADOcodigo.getCodigo());
                compras.setESTADOcodigo(ESTADOcodigo);
            }
            em.persist(compras);
            if (ESTADOcodigo != null) {
                ESTADOcodigo.getComprasList().add(compras);
                ESTADOcodigo = em.merge(ESTADOcodigo);
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Compras compras) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Compras persistentCompras = em.find(Compras.class, compras.getId());
            Estado ESTADOcodigoOld = persistentCompras.getESTADOcodigo();
            Estado ESTADOcodigoNew = compras.getESTADOcodigo();
            if (ESTADOcodigoNew != null) {
                ESTADOcodigoNew = em.getReference(ESTADOcodigoNew.getClass(), ESTADOcodigoNew.getCodigo());
                compras.setESTADOcodigo(ESTADOcodigoNew);
            }
            compras = em.merge(compras);
            if (ESTADOcodigoOld != null && !ESTADOcodigoOld.equals(ESTADOcodigoNew)) {
                ESTADOcodigoOld.getComprasList().remove(compras);
                ESTADOcodigoOld = em.merge(ESTADOcodigoOld);
            }
            if (ESTADOcodigoNew != null && !ESTADOcodigoNew.equals(ESTADOcodigoOld)) {
                ESTADOcodigoNew.getComprasList().add(compras);
                ESTADOcodigoNew = em.merge(ESTADOcodigoNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = compras.getId();
                if (findCompras(id) == null) {
                    throw new NonexistentEntityException("The compras with id " + id + " no longer exists.");
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
            Compras compras;
            try {
                compras = em.getReference(Compras.class, id);
                compras.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The compras with id " + id + " no longer exists.", enfe);
            }
            Estado ESTADOcodigo = compras.getESTADOcodigo();
            if (ESTADOcodigo != null) {
                ESTADOcodigo.getComprasList().remove(compras);
                ESTADOcodigo = em.merge(ESTADOcodigo);
            }
            em.remove(compras);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Compras> findComprasEntities() {
        return findComprasEntities(true, -1, -1);
    }

    public List<Compras> findComprasEntities(int maxResults, int firstResult) {
        return findComprasEntities(false, maxResults, firstResult);
    }

    private List<Compras> findComprasEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Compras.class));
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

    public Compras findCompras(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Compras.class, id);
        } finally {
            em.close();
        }
    }

    public int getComprasCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Compras> rt = cq.from(Compras.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
