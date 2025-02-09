package com.example.e_project_4_api.dto.response.display_for_admin;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class ArtistDisplayForAdmin implements Serializable {

    private Integer id;
    private String artistName;
    private String image;
    private String bio;
    private Boolean isDeleted;
    private Integer totalListenAmount;
    private Integer totalSong;
    private Integer totalAlbum;
    private String username;// nếu artist có acc thì trả username cho a hiện trên bảng, ko thì e trả rỗng ""
    private Boolean isActive;// thêm field này để a check cái nút xanh xanh noActive

}
