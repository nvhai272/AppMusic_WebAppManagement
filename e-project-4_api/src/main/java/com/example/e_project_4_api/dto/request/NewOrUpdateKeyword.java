package com.example.e_project_4_api.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class NewOrUpdateKeyword {
    private Integer id;
    @NotBlank(message = "content is required")
    private String content;
    @NotNull(message = "isActive is required")
    private Boolean isActive;

}
