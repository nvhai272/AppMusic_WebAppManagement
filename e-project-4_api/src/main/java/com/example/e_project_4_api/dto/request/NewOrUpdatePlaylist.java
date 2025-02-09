package com.example.e_project_4_api.dto.request;

import com.example.e_project_4_api.models.Users;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.util.Date;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class NewOrUpdatePlaylist {
    private Integer id;
    @NotBlank(message = "title is required")
    private String title;
    @NotNull(message = "userId is required")
    private Integer userId;


}
