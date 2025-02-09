package com.example.e_project_4_api.dto.request;


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
public class NewOrUpdateFavouriteAlbum {
    private Integer id;
    @NotNull(message = "album is required")
    private Integer albumId;
    @NotNull(message = "userId is required")
    private Integer userId;
}