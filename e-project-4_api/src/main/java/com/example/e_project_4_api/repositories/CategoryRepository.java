package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.Albums;
import com.example.e_project_4_api.models.Artists;
import com.example.e_project_4_api.models.Categories;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Categories, Integer> {
    Optional<Categories> findByTitle(String title);

    Optional<Categories> findByIdAndIsDeleted(Integer id, boolean isDeleted);

    @Query("Select a from Categories a where a.isDeleted = :isDeleted")
    List<Categories> findAllNotDeleted(boolean isDeleted);

    @Query("Select a from Categories a where a.isDeleted = :isDeleted")
    List<Categories> findAllNotDeletedPaging(boolean isDeleted, Pageable pageable);

    @Query("Select COUNT(a) from Categories a where a.isDeleted = :isDeleted")
    int getNumberOfAllNotDeleted(@Param("isDeleted") boolean isDeleted);

    @Query("Select a from Categories a where a.title Like %:searchTxt% AND a.isDeleted = :isDeleted")
    List<Categories> searchNotDeletedPaging(@Param("searchTxt") String searchTxt, boolean isDeleted, Pageable pageable);
}
