package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.Albums;
import com.example.e_project_4_api.models.Genres;
import com.example.e_project_4_api.models.Playlists;
import com.example.e_project_4_api.models.Users;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PlaylistRepository extends JpaRepository<Playlists, Integer> {
    @Query("Select a from Playlists a where a.userId.id = :uId AND a.isDeleted = :isDeleted")
    List<Playlists> findAllByUserId(@Param("uId") Integer userId, @Param("isDeleted") boolean isDeleted);

    Optional<Playlists> findByIdAndIsDeleted(Integer id, boolean isDeleted);


    @Query("Select a from Playlists a where a.isDeleted = :isDeleted")
    List<Playlists> findAllNotDeleted(boolean isDeleted);
    @Query("Select a from Playlists a where a.isDeleted = :isDeleted")
    List<Playlists> findAllNotDeletedPaging(boolean isDeleted, Pageable pageable);

    @Query("Select COUNT(a) from Playlists a where a.isDeleted = :isDeleted")
    int getNumberOfAllNotDeleted(@Param("isDeleted") boolean isDeleted);

    @Query("Select a from Playlists a where a.title Like %:searchTxt% AND a.isDeleted = :isDeleted")
    List<Playlists> searchNotDeletedPaging(@Param("searchTxt") String searchTxt, boolean isDeleted, Pageable pageable);
}
