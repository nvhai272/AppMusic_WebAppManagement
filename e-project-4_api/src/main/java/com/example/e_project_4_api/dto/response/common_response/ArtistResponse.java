package com.example.e_project_4_api.dto.response.common_response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class ArtistResponse implements Serializable {

    private Integer id;
    private String artistName;
    private String image;
    private String bio;
    private Boolean isDeleted;

}
