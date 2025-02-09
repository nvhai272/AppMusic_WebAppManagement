/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.e_project_4_api.models;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * @author admin
 */
@Entity
@Table(name = "artists")
@Getter
@Setter
@NoArgsConstructor
public class Artists implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @Column(name = "artist_name")
    private String artistName;
    @Column(name = "image")
    private String image;
    @Lob
    @Column(name = "bio")
    private String bio;
    @Column(name = "is_deleted")
    private Boolean isDeleted;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "modified_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedAt;
    @OneToMany(mappedBy = "artistId")
    private Collection<Albums> albumsCollection;
    @OneToMany(mappedBy = "artistId")
    private Collection<Songs> songsCollection;
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @ManyToOne
    private Users userId;

    public Artists(String artistName, String image, String bio, Boolean isDeleted, Date createdAt, Date modifiedAt, Users userId) {
        this.artistName = artistName;
        this.image = image;
        this.bio = bio;
        this.userId = userId;
        this.isDeleted = isDeleted;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }
    public Artists(String artistName, String image, String bio, Boolean isDeleted, Date createdAt, Date modifiedAt) {
        this.artistName = artistName;
        this.image = image;
        this.bio = bio;
        this.isDeleted = isDeleted;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
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
        if (!(object instanceof Artists)) {
            return false;
        }
        Artists other = (Artists) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Artists[ id=" + id + " ]";
    }

}
