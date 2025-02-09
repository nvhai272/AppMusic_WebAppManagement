package com.example.e_project_4_api.dto.response.common_response;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FavouriteSongResponse {

    private Integer id;
    private Integer songId;
    private Integer userId;
}
