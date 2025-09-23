/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modell;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author Desarrollo_GTIC
 */
@Entity
@Table(name = "requerimiento")
@NamedQueries({
    @NamedQuery(name = "Requerimiento.findAll", query = "SELECT r FROM Requerimiento r"),
    @NamedQuery(name = "Requerimiento.findById", query = "SELECT r FROM Requerimiento r WHERE r.id = :id"),
    @NamedQuery(name = "Requerimiento.findByCodigo", query = "SELECT r FROM Requerimiento r WHERE r.codigo = :codigo"),
    @NamedQuery(name = "Requerimiento.findByFecha", query = "SELECT r FROM Requerimiento r WHERE r.fecha = :fecha"),
    @NamedQuery(name = "Requerimiento.findByConsecutivo", query = "SELECT r FROM Requerimiento r WHERE r.consecutivo = :consecutivo"),
    @NamedQuery(name = "Requerimiento.findByArticulo", query = "SELECT r FROM Requerimiento r WHERE r.articulo = :articulo"),
    @NamedQuery(name = "Requerimiento.findByDescripcion", query = "SELECT r FROM Requerimiento r WHERE r.descripcion = :descripcion"),
    @NamedQuery(name = "Requerimiento.findByCentrocosto", query = "SELECT r FROM Requerimiento r WHERE r.centrocosto = :centrocosto"),
    @NamedQuery(name = "Requerimiento.findByCantidad", query = "SELECT r FROM Requerimiento r WHERE r.cantidad = :cantidad"),
    @NamedQuery(name = "Requerimiento.findByUsuario", query = "SELECT r FROM Requerimiento r WHERE r.usuario = :usuario"),
    @NamedQuery(name = "Requerimiento.findByObservacion", query = "SELECT r FROM Requerimiento r WHERE r.observacion = :observacion")})
public class Requerimiento implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @Column(name = "codigo")
    private String codigo;
    @Basic(optional = false)
    @Column(name = "fecha")
    @Temporal(TemporalType.DATE)
    private Date fecha;
    @Basic(optional = false)
    @Column(name = "consecutivo")
    private String consecutivo;
    @Basic(optional = false)
    @Column(name = "articulo")
    private String articulo;
    @Basic(optional = false)
    @Column(name = "descripcion")
    private String descripcion;
    @Basic(optional = false)
    @Column(name = "centrocosto")
    private String centrocosto;
    @Basic(optional = false)
    @Column(name = "cantidad")
    private String cantidad;
    @Basic(optional = false)
    @Column(name = "usuario")
    private String usuario;
    @Basic(optional = false)
    @Column(name = "observacion")
    private String observacion;

    public Requerimiento() {
    }

    public Requerimiento(Integer id) {
        this.id = id;
    }

    public Requerimiento(Integer id, String codigo, Date fecha, String consecutivo, String articulo, String descripcion, String centrocosto, String cantidad, String usuario, String observacion) {
        this.id = id;
        this.codigo = codigo;
        this.fecha = fecha;
        this.consecutivo = consecutivo;
        this.articulo = articulo;
        this.descripcion = descripcion;
        this.centrocosto = centrocosto;
        this.cantidad = cantidad;
        this.usuario = usuario;
        this.observacion = observacion;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getConsecutivo() {
        return consecutivo;
    }

    public void setConsecutivo(String consecutivo) {
        this.consecutivo = consecutivo;
    }

    public String getArticulo() {
        return articulo;
    }

    public void setArticulo(String articulo) {
        this.articulo = articulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getCentrocosto() {
        return centrocosto;
    }

    public void setCentrocosto(String centrocosto) {
        this.centrocosto = centrocosto;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Requerimiento)) {
            return false;
        }
        Requerimiento other = (Requerimiento) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "modell.Requerimiento[ id=" + id + " ]";
    }
    
}
