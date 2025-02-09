package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.Categories;
import com.example.e_project_4_api.models.Genres;
import com.example.e_project_4_api.models.Keywords;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface KeywordRepository extends JpaRepository<Keywords, Integer> {
    Optional<Keywords> findByContent(String content);

    @Query("Select a from Keywords a")
    List<Keywords> findAllPaging(Pageable pageable);

    @Query("Select COUNT(a) from Keywords a")
    int getNumberOfAll();

    @Query("Select a from Keywords a where a.content Like %:searchTxt%")
    List<Keywords> searchNotDeletedPaging(@Param("searchTxt") String searchTxt, Pageable pageable);
}
