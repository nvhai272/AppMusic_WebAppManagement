package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.Albums;
import com.example.e_project_4_api.models.Artists;
import com.example.e_project_4_api.models.Songs;
import com.example.e_project_4_api.models.Users;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AlbumRepository extends JpaRepository<Albums, Integer>, JpaSpecificationExecutor<Albums> {
    Optional<Albums> findByTitle(String title);

    Optional<Albums> findByIdAndIsDeleted(Integer id, boolean isDeleted);

    @Query("Select a from Albums a where a.artistId.id = :arId AND a.isDeleted = :isDeleted AND a.isReleased = true")
    List<Albums> findAllByArtistId(@Param("arId") Integer artistId, @Param("isDeleted") boolean isDeleted);

    @Query("Select a from Albums a where a.artistId.id = :arId AND a.isDeleted = :isDeleted")
    List<Albums> findAllByArtistIdPaging(@Param("arId") Integer artistId, @Param("isDeleted") boolean isDeleted, Pageable pageable);

    @Query("Select a from Albums a where a.isDeleted = :isDeleted")
    List<Albums> findAllNotDeleted(boolean isDeleted);

    @Query("Select a from Albums a where a.title Like %:searchTxt% AND a.isDeleted = :isDeleted")
    List<Albums> searchNotDeletedPaging(@Param("searchTxt") String searchTxt, boolean isDeleted, Pageable pageable);

    @Query("Select a from Albums a where a.isDeleted = :isDeleted")
    List<Albums> findAllNotDeletedPaging(boolean isDeleted, Pageable pageable);

    @Query("Select COUNT(a) from Albums a where a.isDeleted = :isDeleted")
    int getNumberOfAllNotDeleted(@Param("isDeleted") boolean isDeleted);

}
