package com.example.e_project_4_api.dto.response.display_for_admin;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GenreDisplayForAdmin implements Serializable {
    private Integer id;
    private String title;
    private String image;
    private Boolean isDeleted;
    private Date createdAt;
    private Date modifiedAt;
    private Integer totalSong;
    private String color;

}
