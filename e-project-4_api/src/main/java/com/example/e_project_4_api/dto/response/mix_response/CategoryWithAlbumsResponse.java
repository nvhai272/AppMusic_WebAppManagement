package com.example.e_project_4_api.dto.response.mix_response;

import com.example.e_project_4_api.dto.response.display_response.AlbumDisplay;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CategoryWithAlbumsResponse implements Serializable {
    private Integer id;
    private String title;
    private String description;
    private Boolean isDeleted;
    private Date createdAt;
    private Date modifiedAt;
    private List<AlbumDisplay> albums;
}
