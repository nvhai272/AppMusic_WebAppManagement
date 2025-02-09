/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.e_project_4_api.models;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * @author admin
 */
@Entity
@Table(name = "songs")
@Getter
@Setter
@NoArgsConstructor
public class Songs implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @Column(name = "title")
    private String title;
    @Column(name = "audio_path")
    private String audioPath;
    @Column(name = "listen_amount")
    private Integer listenAmount;
    @Column(name = "feature_artist")
    private String featureArtist;
    @Column(name = "lyric_file_path")
    private String lyricFilePath;
    @Column(name = "is_pending")
    private Boolean isPending;
    @Column(name = "is_deleted")
    private Boolean isDeleted;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "modified_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedAt;
    @JoinColumn(name = "album_id", referencedColumnName = "id")
    @ManyToOne
    private Albums albumId;
    @JoinColumn(name = "artist_id", referencedColumnName = "id")
    @ManyToOne
    private Artists artistId;
    @OneToMany(mappedBy = "songId")
    private Collection<FavouriteSongs> favouriteSongsCollection;
    @OneToMany(mappedBy = "songId")
    private Collection<PlaylistSong> playlistSongCollection;
    @OneToMany(mappedBy = "songId")
    private Collection<GenreSong> genreSongCollection;
    @OneToMany(mappedBy = "songId")
    private Collection<ViewInMonth> likeAndViewInMonthCollection;

    public Songs(String title, String audioPath, Integer listenAmount, String featureArtist, String lyricFilePath, Boolean isPending, Boolean isDeleted, Date createdAt, Date modifiedAt, Artists artistId) {
        this.title = title;
        this.audioPath = audioPath;
        this.listenAmount = listenAmount;
        this.featureArtist = featureArtist;
        this.lyricFilePath = lyricFilePath;
        this.isPending = isPending;
        this.isDeleted = isDeleted;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
        this.artistId = artistId;
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
        if (!(object instanceof Songs)) {
            return false;
        }
        Songs other = (Songs) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "models.Songs[ id=" + id + " ]";
    }

}
