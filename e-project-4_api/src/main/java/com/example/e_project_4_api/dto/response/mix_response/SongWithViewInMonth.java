package com.example.e_project_4_api.dto.response.mix_response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SongWithViewInMonth {
    private int songId;
    private String songName;
    private String artistName;
    private String albumName;
    private int listenInMonth;

}
