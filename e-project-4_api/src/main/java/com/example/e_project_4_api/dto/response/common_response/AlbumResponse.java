package com.example.e_project_4_api.dto.response.common_response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class AlbumResponse {
    private Integer id;
    private String title;
    private String image;
    private Boolean isReleased;
    private Date releaseDate;
    private Integer artistId;
    private Boolean isDeleted;
    private Date createdAt;
    private Date modifiedAt;
    private List<Integer> categoryIds;

}
