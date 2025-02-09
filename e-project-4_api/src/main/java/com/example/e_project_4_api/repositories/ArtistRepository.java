package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.Albums;
import com.example.e_project_4_api.models.Artists;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ArtistRepository extends JpaRepository<Artists, Integer> {
    Optional<Artists> findByArtistName(String artistName);

    Optional<Artists> findByIdAndIsDeleted(Integer id, boolean isDeleted);

    @Query("Select a from Artists a where a.artistName Like %:searchTxt% AND a.isDeleted = :isDeleted")
    List<Artists> searchNotDeletedPaging(@Param("searchTxt") String searchTxt, boolean isDeleted, Pageable pageable);

    @Query("SELECT a FROM Artists a WHERE a.userId.id = :userId AND a.isDeleted = :isDeleted")
    Optional<Artists> findByUserId(@Param("userId") Integer userId, @Param("isDeleted") boolean isDeleted);

    @Query("Select a from Artists a where a.isDeleted = :isDeleted")
    List<Artists> findAllNotDeleted(boolean isDeleted);

    @Query("Select a from Artists a where a.isDeleted = :isDeleted")
    List<Artists> findAllNotDeletedPaging(boolean isDeleted, Pageable pageable);

    @Query("Select COUNT(a) from Artists a where a.isDeleted = :isDeleted")
    int getNumberOfAllNotDeleted(@Param("isDeleted") boolean isDeleted);
}
