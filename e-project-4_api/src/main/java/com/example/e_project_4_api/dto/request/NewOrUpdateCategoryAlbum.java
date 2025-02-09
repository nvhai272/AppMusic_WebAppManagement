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
@AllArgsConstructor
@NoArgsConstructor
public class NewOrUpdateCategoryAlbum {

    private Integer id;
    @NotNull(message = "albumId is required")
    private Integer albumId;
    @NotNull(message = "categoryId is required")
    private Integer categoryId;

}
