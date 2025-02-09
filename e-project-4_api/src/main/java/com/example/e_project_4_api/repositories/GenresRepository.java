package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.Categories;
import com.example.e_project_4_api.models.Genres;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GenresRepository extends JpaRepository<Genres, Integer> {

    Optional<Genres> findByTitle(String title);

    Optional<Genres> findByIdAndIsDeleted(Integer id, boolean isDeleted);

    @Query("Select a from Genres a where a.isDeleted = :isDeleted")
    List<Genres> findAllNotDeleted(boolean isDeleted);
    @Query("Select a from Genres a where a.isDeleted = :isDeleted")
    List<Genres> findAllNotDeletedPaging(boolean isDeleted, Pageable pageable);

    @Query("Select COUNT(a) from Genres a where a.isDeleted = :isDeleted")
    int getNumberOfAllNotDeleted(@Param("isDeleted") boolean isDeleted);

    @Query("Select a from Genres a where a.title Like %:searchTxt% AND a.isDeleted = :isDeleted")
    List<Genres> searchNotDeletedPaging(@Param("searchTxt") String searchTxt, boolean isDeleted, Pageable pageable);
}
