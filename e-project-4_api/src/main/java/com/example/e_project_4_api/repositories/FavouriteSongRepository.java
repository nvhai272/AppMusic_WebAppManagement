package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.FavouriteSongs;
import com.example.e_project_4_api.models.PlaylistSong;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository

public interface FavouriteSongRepository extends JpaRepository<FavouriteSongs, Integer> {
    @Query("SELECT fs FROM FavouriteSongs fs WHERE fs.userId.id = :userId AND fs.songId.id = :songId")
    Optional<FavouriteSongs> findByUserIdAndSongId(@Param("userId") Integer userId, @Param("songId") Integer songId);

    @Query("SELECT fs FROM FavouriteSongs fs WHERE fs.userId.id = :userId AND fs.songId.isDeleted = :isDeleted")
    List<FavouriteSongs> findFSByUserId(@Param("userId") Integer userId, @Param("isDeleted") boolean isDeleted);

    @Query("SELECT fs FROM FavouriteSongs fs WHERE fs.userId.id = :userId AND fs.songId.isDeleted = :isDeleted")
    List<FavouriteSongs> findFSByUserIdPaging(@Param("userId") Integer userId, @Param("isDeleted") boolean isDeleted, Pageable pageable);

    @Query("SELECT fs FROM FavouriteSongs fs WHERE fs.songId.id = :songId AND fs.songId.isDeleted = :isDeleted")
    List<FavouriteSongs> findFSBySongId(@Param("songId") Integer songId, @Param("isDeleted") boolean isDeleted);
}