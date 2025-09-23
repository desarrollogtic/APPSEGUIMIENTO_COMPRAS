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
import modell.Requerimiento;

/**
 *
 * @author Desarrollo_GTIC
 */
public class RequerimientoJpaController implements Serializable {

    public RequerimientoJpaController() {
        this.emf = Persistence.createEntityManagerFactory("APPSEGUIMIENTO_COMPRASPU");
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Requerimiento requerimiento) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(requerimiento);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Requerimiento requerimiento) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            requerimiento = em.merge(requerimiento);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = requerimiento.getId();
                if (findRequerimiento(id) == null) {
                    throw new NonexistentEntityException("The requerimiento with id " + id + " no longer exists.");
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
            Requerimiento requerimiento;
            try {
                requerimiento = em.getReference(Requerimiento.class, id);
                requerimiento.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The requerimiento with id " + id + " no longer exists.", enfe);
            }
            em.remove(requerimiento);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Requerimiento> findRequerimientoEntities() {
        return findRequerimientoEntities(true, -1, -1);
    }

    public List<Requerimiento> findRequerimientoEntities(int maxResults, int firstResult) {
        return findRequerimientoEntities(false, maxResults, firstResult);
    }

    private List<Requerimiento> findRequerimientoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Requerimiento.class));
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

    public Requerimiento findRequerimiento(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Requerimiento.class, id);
        } finally {
            em.close();
        }
    }

    public int getRequerimientoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Requerimiento> rt = cq.from(Requerimiento.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
