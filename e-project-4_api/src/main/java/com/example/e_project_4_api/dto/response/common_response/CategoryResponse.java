package com.example.e_project_4_api.dto.response.common_response;

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
public class CategoryResponse implements Serializable {
    private Integer id;
    private String title;
    private String description;
    private Boolean isDeleted;
    private Date createdAt;
    private Date modifiedAt;
}
