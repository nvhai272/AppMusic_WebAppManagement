/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.e_project_4_api.dto.response.display_for_admin;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class SongDisplayForAdmin implements Serializable {


    private Integer id;
    private String title;
    private String audioPath;
    private Integer listenAmount;//total view
    private Integer totalFavourite;//field thiếu
    private String lyricFilePath;
    private String featureArtist;
    private Boolean isPending;// giao diện song thiếu cột này a nhé
    private Boolean isDeleted;
    private Date createdAt;
    private Date modifiedAt;
    private String albumTitle;// giao diện song nên có
    private String albumImage;
    private String artistName;// giao diện song nên có
    private List<String> genreNames;
    // bảng song mới có 5 cột nên e gợi ý thêm cho nhiều cột, các cột e ko note là ko cần cho vào cột đâu, cho vào chi tiết thì hơn

}
