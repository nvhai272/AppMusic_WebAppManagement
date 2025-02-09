package com.example.e_project_4_api.repositories;

import com.example.e_project_4_api.models.Colors;
import com.example.e_project_4_api.models.ViewInMonth;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ColorRepository extends JpaRepository<Colors, Integer> {
}
