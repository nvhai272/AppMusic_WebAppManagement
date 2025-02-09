package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.ViewInMonth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

@Repository
public interface ViewInMonthRepository extends JpaRepository<ViewInMonth, Integer> {
    @Query("SELECT SUM(o.listenAmount) FROM ViewInMonth o WHERE o.monthId.id = :monthId")
    Optional<Integer> findTotalListenAmount(@Param("monthId") Integer monthId);

    @Query("SELECT o FROM ViewInMonth o WHERE o.monthId.id = :monthId ORDER BY o.listenAmount DESC")
    List<ViewInMonth> findSongsWithMaxListenAmount(@Param("monthId") Integer monthId, Pageable pageable);

    @Query("SELECT sa FROM ViewInMonth sa WHERE sa.monthId.id = :monthId AND sa.songId.id = :songId")
    Optional<ViewInMonth> findBySongIdAndMonthId(@Param("monthId") Integer monthId, @Param("songId") Integer songId);
}
