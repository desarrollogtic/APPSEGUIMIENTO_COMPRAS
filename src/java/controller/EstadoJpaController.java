/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.IllegalOrphanException;
import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import modell.Compras;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import modell.Estado;

/**
 *
 * @author Desarrollo_GTIC
 */
public class EstadoJpaController implements Serializable {

    public EstadoJpaController() {
        this.emf = Persistence.createEntityManagerFactory("APPSEGUIMIENTO_COMPRASPU");
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Estado estado) throws PreexistingEntityException, Exception {
        if (estado.getComprasList() == null) {
            estado.setComprasList(new ArrayList<Compras>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            List<Compras> attachedComprasList = new ArrayList<Compras>();
            for (Compras comprasListComprasToAttach : estado.getComprasList()) {
                comprasListComprasToAttach = em.getReference(comprasListComprasToAttach.getClass(), comprasListComprasToAttach.getId());
                attachedComprasList.add(comprasListComprasToAttach);
            }
            estado.setComprasList(attachedComprasList);
            em.persist(estado);
            for (Compras comprasListCompras : estado.getComprasList()) {
                Estado oldESTADOcodigoOfComprasListCompras = comprasListCompras.getESTADOcodigo();
                comprasListCompras.setESTADOcodigo(estado);
                comprasListCompras = em.merge(comprasListCompras);
                if (oldESTADOcodigoOfComprasListCompras != null) {
                    oldESTADOcodigoOfComprasListCompras.getComprasList().remove(comprasListCompras);
                    oldESTADOcodigoOfComprasListCompras = em.merge(oldESTADOcodigoOfComprasListCompras);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findEstado(estado.getCodigo()) != null) {
                throw new PreexistingEntityException("Estado " + estado + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Estado estado) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Estado persistentEstado = em.find(Estado.class, estado.getCodigo());
            List<Compras> comprasListOld = persistentEstado.getComprasList();
            List<Compras> comprasListNew = estado.getComprasList();
            List<String> illegalOrphanMessages = null;
            for (Compras comprasListOldCompras : comprasListOld) {
                if (!comprasListNew.contains(comprasListOldCompras)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Compras " + comprasListOldCompras + " since its ESTADOcodigo field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            List<Compras> attachedComprasListNew = new ArrayList<Compras>();
            for (Compras comprasListNewComprasToAttach : comprasListNew) {
                comprasListNewComprasToAttach = em.getReference(comprasListNewComprasToAttach.getClass(), comprasListNewComprasToAttach.getId());
                attachedComprasListNew.add(comprasListNewComprasToAttach);
            }
            comprasListNew = attachedComprasListNew;
            estado.setComprasList(comprasListNew);
            estado = em.merge(estado);
            for (Compras comprasListNewCompras : comprasListNew) {
                if (!comprasListOld.contains(comprasListNewCompras)) {
                    Estado oldESTADOcodigoOfComprasListNewCompras = comprasListNewCompras.getESTADOcodigo();
                    comprasListNewCompras.setESTADOcodigo(estado);
                    comprasListNewCompras = em.merge(comprasListNewCompras);
                    if (oldESTADOcodigoOfComprasListNewCompras != null && !oldESTADOcodigoOfComprasListNewCompras.equals(estado)) {
                        oldESTADOcodigoOfComprasListNewCompras.getComprasList().remove(comprasListNewCompras);
                        oldESTADOcodigoOfComprasListNewCompras = em.merge(oldESTADOcodigoOfComprasListNewCompras);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                Integer id = estado.getCodigo();
                if (findEstado(id) == null) {
                    throw new NonexistentEntityException("The estado with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(Integer id) throws IllegalOrphanException, NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Estado estado;
            try {
                estado = em.getReference(Estado.class, id);
                estado.getCodigo();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The estado with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<Compras> comprasListOrphanCheck = estado.getComprasList();
            for (Compras comprasListOrphanCheckCompras : comprasListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Estado (" + estado + ") cannot be destroyed since the Compras " + comprasListOrphanCheckCompras + " in its comprasList field has a non-nullable ESTADOcodigo field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            em.remove(estado);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Estado> findEstadoEntities() {
        return findEstadoEntities(true, -1, -1);
    }

    public List<Estado> findEstadoEntities(int maxResults, int firstResult) {
        return findEstadoEntities(false, maxResults, firstResult);
    }

    private List<Estado> findEstadoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Estado.class));
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

    public Estado findEstado(Integer id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Estado.class, id);
        } finally {
            em.close();
        }
    }

    public int getEstadoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Estado> rt = cq.from(Estado.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
