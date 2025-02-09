package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.MonthOfYear;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MonthRepository extends JpaRepository<MonthOfYear, Integer> {
}
