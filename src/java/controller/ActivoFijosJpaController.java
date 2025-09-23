/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import modell.ActivoFijos;

/**
 *
 * @author Desarrollo_GTIC
 */
public class ActivoFijosJpaController implements Serializable {

    public ActivoFijosJpaController() {
        this.emf = Persistence.createEntityManagerFactory("APPSEGUIMIENTO_COMPRASPU");
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(ActivoFijos activoFijos) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(activoFijos);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findActivoFijos(activoFijos.getCodigo()) != null) {
                throw new PreexistingEntityException("ActivoFijos " + activoFijos + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(ActivoFijos activoFijos) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            activoFijos = em.merge(activoFijos);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = activoFijos.getCodigo();
                if (findActivoFijos(id) == null) {
                    throw new NonexistentEntityException("The activoFijos with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(String id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            ActivoFijos activoFijos;
            try {
                activoFijos = em.getReference(ActivoFijos.class, id);
                activoFijos.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The activoFijos with id " + id + " no longer exists.", enfe);
            }
            em.remove(activoFijos);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<ActivoFijos> findActivoFijosEntities() {
        return findActivoFijosEntities(true, -1, -1);
    }

    public List<ActivoFijos> findActivoFijosEntities(int maxResults, int firstResult) {
        return findActivoFijosEntities(false, maxResults, firstResult);
    }

    private List<ActivoFijos> findActivoFijosEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(ActivoFijos.class));
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

    public ActivoFijos findActivoFijos(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(ActivoFijos.class, id);
        } finally {
            em.close();
        }
    }

    public int getActivoFijosCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<ActivoFijos> rt = cq.from(ActivoFijos.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
