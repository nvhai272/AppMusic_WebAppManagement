package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.Genres;
import com.example.e_project_4_api.models.Keywords;
import com.example.e_project_4_api.models.News;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NewsRepository extends JpaRepository<News, Integer> {
    Optional<News> findByTitle(String title);

    @Query("Select a from News a")
    List<News> findAllPaging(Pageable pageable);

    @Query("Select COUNT(a) from News a")
    int getNumberOfAll();

    @Query("Select a from News a where a.title Like %:searchTxt%")
    List<News> searchNotDeletedPaging(@Param("searchTxt") String searchTxt, Pageable pageable);
}
