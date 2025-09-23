/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modell;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author Desarrollo_GTIC
 */
@Entity
@Table(name = "activo_fijos")
@NamedQueries({
    @NamedQuery(name = "ActivoFijos.findAll", query = "SELECT a FROM ActivoFijos a"),
    @NamedQuery(name = "ActivoFijos.findByCodigo", query = "SELECT a FROM ActivoFijos a WHERE a.codigo = :codigo"),
    @NamedQuery(name = "ActivoFijos.findByNombre", query = "SELECT a FROM ActivoFijos a WHERE a.nombre = :nombre")})
public class ActivoFijos implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "codigo")
    private String codigo;
    @Basic(optional = false)
    @Column(name = "nombre")
    private String nombre;

    public ActivoFijos() {
    }

    public ActivoFijos(String codigo) {
        this.codigo = codigo;
    }

    public ActivoFijos(String codigo, String nombre) {
        this.codigo = codigo;
        this.nombre = nombre;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (codigo != null ? codigo.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ActivoFijos)) {
            return false;
        }
        ActivoFijos other = (ActivoFijos) object;
        if ((this.codigo == null && other.codigo != null) || (this.codigo != null && !this.codigo.equals(other.codigo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "modell.ActivoFijos[ codigo=" + codigo + " ]";
    }
    
}
