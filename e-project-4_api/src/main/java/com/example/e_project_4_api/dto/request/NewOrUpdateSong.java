package com.example.e_project_4_api.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NewOrUpdateSong {
    private Integer id;
    @NotBlank(message = "title is required")
    private String title;
    private String audioPath;
    private Integer listenAmount;
    private String lyricFilePath;
    @NotNull(message = "featureArtist is required")
    private String featureArtist;
    private Integer albumId;
    @NotNull(message = "artistId is required")
    private Integer artistId;
    @NotNull
    @Size(min = 1, message = "The genreIds list must have at least one element.")
    private List<Integer> genreIds;

}
