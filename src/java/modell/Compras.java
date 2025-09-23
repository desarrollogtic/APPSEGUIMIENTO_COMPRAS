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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
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
@Table(name = "compras")
@NamedQueries({
    @NamedQuery(name = "Compras.findAll", query = "SELECT c FROM Compras c"),
    @NamedQuery(name = "Compras.findById", query = "SELECT c FROM Compras c WHERE c.id = :id"),
    @NamedQuery(name = "Compras.findByNumeroSolicitud", query = "SELECT c FROM Compras c WHERE c.numeroSolicitud = :numeroSolicitud"),
    @NamedQuery(name = "Compras.findByArea", query = "SELECT c FROM Compras c WHERE c.area = :area"),
    @NamedQuery(name = "Compras.findByDescripcion", query = "SELECT c FROM Compras c WHERE c.descripcion = :descripcion"),
    @NamedQuery(name = "Compras.findByFechaSolicitud", query = "SELECT c FROM Compras c WHERE c.fechaSolicitud = :fechaSolicitud"),
    @NamedQuery(name = "Compras.findByVbComprar", query = "SELECT c FROM Compras c WHERE c.vbComprar = :vbComprar"),
    @NamedQuery(name = "Compras.findByNombreProveedor", query = "SELECT c FROM Compras c WHERE c.nombreProveedor = :nombreProveedor"),
    @NamedQuery(name = "Compras.findByFechaEnvio", query = "SELECT c FROM Compras c WHERE c.fechaEnvio = :fechaEnvio"),
    @NamedQuery(name = "Compras.findByFechaEntrada", query = "SELECT c FROM Compras c WHERE c.fechaEntrada = :fechaEntrada"),
    @NamedQuery(name = "Compras.findByFechaEntrega", query = "SELECT c FROM Compras c WHERE c.fechaEntrega = :fechaEntrega"),
    @NamedQuery(name = "Compras.findByDuracion", query = "SELECT c FROM Compras c WHERE c.duracion = :duracion"),
    @NamedQuery(name = "Compras.findByConformidad", query = "SELECT c FROM Compras c WHERE c.conformidad = :conformidad"),
    @NamedQuery(name = "Compras.findByObservacion", query = "SELECT c FROM Compras c WHERE c.observacion = :observacion"),
    @NamedQuery(name = "Compras.findByGenerado", query = "SELECT c FROM Compras c WHERE c.generado = :generado"),
    @NamedQuery(name = "Compras.findByConsecutivo", query = "SELECT c FROM Compras c WHERE c.consecutivo = :consecutivo")})
public class Compras implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @Column(name = "numero_solicitud")
    private String numeroSolicitud;
    @Basic(optional = false)
    @Column(name = "area")
    private String area;
    @Basic(optional = false)
    @Column(name = "descripcion")
    private String descripcion;
    @Basic(optional = false)
    @Column(name = "fecha_solicitud")
    @Temporal(TemporalType.DATE)
    private Date fechaSolicitud;
    @Basic(optional = false)
    @Column(name = "vb_comprar")
    private String vbComprar;
    @Basic(optional = false)
    @Column(name = "nombre_proveedor")
    private String nombreProveedor;
    @Basic(optional = false)
    @Column(name = "fecha_envio")
    @Temporal(TemporalType.DATE)
    private Date fechaEnvio;
    @Basic(optional = false)
    @Column(name = "fecha_entrada")
    @Temporal(TemporalType.DATE)
    private Date fechaEntrada;
    @Basic(optional = false)
    @Column(name = "fecha_entrega")
    @Temporal(TemporalType.DATE)
    private Date fechaEntrega;
    @Basic(optional = false)
    @Column(name = "duracion")
    private String duracion;
    @Basic(optional = false)
    @Column(name = "conformidad")
    private String conformidad;
    @Basic(optional = false)
    @Column(name = "observacion")
    private String observacion;
    @Basic(optional = false)
    @Column(name = "generado")
    private String generado;
    @Basic(optional = false)
    @Column(name = "consecutivo")
    private String consecutivo;
    @JoinColumn(name = "ESTADO_codigo", referencedColumnName = "codigo")
    @ManyToOne(optional = false)
    private Estado eSTADOcodigo;

    public Compras() {
    }

    public Compras(Integer id) {
        this.id = id;
    }

    public Compras(Integer id, String numeroSolicitud, String area, String descripcion, Date fechaSolicitud, String vbComprar, String nombreProveedor, Date fechaEnvio, Date fechaEntrada, Date fechaEntrega, String duracion, String conformidad, String observacion, String generado, String consecutivo) {
        this.id = id;
        this.numeroSolicitud = numeroSolicitud;
        this.area = area;
        this.descripcion = descripcion;
        this.fechaSolicitud = fechaSolicitud;
        this.vbComprar = vbComprar;
        this.nombreProveedor = nombreProveedor;
        this.fechaEnvio = fechaEnvio;
        this.fechaEntrada = fechaEntrada;
        this.fechaEntrega = fechaEntrega;
        this.duracion = duracion;
        this.conformidad = conformidad;
        this.observacion = observacion;
        this.generado = generado;
        this.consecutivo = consecutivo;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNumeroSolicitud() {
        return numeroSolicitud;
    }

    public void setNumeroSolicitud(String numeroSolicitud) {
        this.numeroSolicitud = numeroSolicitud;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Date getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(Date fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    public String getVbComprar() {
        return vbComprar;
    }

    public void setVbComprar(String vbComprar) {
        this.vbComprar = vbComprar;
    }

    public String getNombreProveedor() {
        return nombreProveedor;
    }

    public void setNombreProveedor(String nombreProveedor) {
        this.nombreProveedor = nombreProveedor;
    }

    public Date getFechaEnvio() {
        return fechaEnvio;
    }

    public void setFechaEnvio(Date fechaEnvio) {
        this.fechaEnvio = fechaEnvio;
    }

    public Date getFechaEntrada() {
        return fechaEntrada;
    }

    public void setFechaEntrada(Date fechaEntrada) {
        this.fechaEntrada = fechaEntrada;
    }

    public Date getFechaEntrega() {
        return fechaEntrega;
    }

    public void setFechaEntrega(Date fechaEntrega) {
        this.fechaEntrega = fechaEntrega;
    }

    public String getDuracion() {
        return duracion;
    }

    public void setDuracion(String duracion) {
        this.duracion = duracion;
    }

    public String getConformidad() {
        return conformidad;
    }

    public void setConformidad(String conformidad) {
        this.conformidad = conformidad;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public String getGenerado() {
        return generado;
    }

    public void setGenerado(String generado) {
        this.generado = generado;
    }

    public String getConsecutivo() {
        return consecutivo;
    }

    public void setConsecutivo(String consecutivo) {
        this.consecutivo = consecutivo;
    }

    public Estado getESTADOcodigo() {
        return eSTADOcodigo;
    }

    public void setESTADOcodigo(Estado eSTADOcodigo) {
        this.eSTADOcodigo = eSTADOcodigo;
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
        if (!(object instanceof Compras)) {
            return false;
        }
        Compras other = (Compras) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "modell.Compras[ id=" + id + " ]";
    }
    
}
