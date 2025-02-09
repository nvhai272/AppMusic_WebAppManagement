package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.NewOrUpdateCategoryAlbum;
import com.example.e_project_4_api.dto.request.NewOrUpdateGenreSong;
import com.example.e_project_4_api.dto.response.common_response.GenreSongResponse;
import com.example.e_project_4_api.ex.AlreadyExistedException;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.CategoryAlbum;
import com.example.e_project_4_api.models.GenreSong;
import com.example.e_project_4_api.models.Genres;
import com.example.e_project_4_api.models.Songs;
import com.example.e_project_4_api.repositories.GenreSongRepository;
import com.example.e_project_4_api.repositories.GenresRepository;
import com.example.e_project_4_api.repositories.SongRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class GenreSongService {

    @Autowired
    private GenreSongRepository genreSongRepo;
    @Autowired
    private GenresRepository genreRepo;
    @Autowired
    private SongRepository songRepo;

    // Lấy tất cả GenreSong
    public List<GenreSongResponse> getAllGenreSongs() {
        return genreSongRepo.findAll()
                .stream()
                .map(this::toGenreSongResponse)
                .collect(Collectors.toList());
    }


    public GenreSongResponse findById(int id) {
        Optional<GenreSong> op = genreSongRepo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any genre-song relation with id: " + id);
        }
        return toGenreSongResponse(op.get());
    }


    public boolean deleteById(int id) {
        Optional<GenreSong> genreSong = genreSongRepo.findById(id);
        if (genreSong.isEmpty()) {
            throw new NotFoundException("Can't find any genre-song relation with id: " + id);
        }
        GenreSong existing = genreSong.get();
        genreSongRepo.delete(existing);
        return true;
    }


    public NewOrUpdateGenreSong addNewGenreSong(NewOrUpdateGenreSong request) {

        Optional<GenreSong> existingGenreSong = genreSongRepo.findByGenreIdAndSongId(request.getGenreId(), request.getSongId());
        if (existingGenreSong.isPresent()) {
            throw new AlreadyExistedException("A GenreSong already exists");
        }
        Optional<Genres> genre = genreRepo.findByIdAndIsDeleted(request.getGenreId(), false);
        if (genre.isEmpty()) {
            throw new NotFoundException("Can't find any genre with id: " + request.getGenreId());
        }


        Optional<Songs> song = songRepo.findByIdAndIsDeleted(request.getSongId(), false);
        if (song.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + request.getSongId());
        }


        GenreSong newGenreSong = new GenreSong(
                genre.get(),
                song.get()
        );

        genreSongRepo.save(newGenreSong);
        return request;
    }

    public void deleteByGenreIdAndSongId(int genreId, int songId) {
        Optional<GenreSong> genreSong = genreSongRepo.findByGenreIdAndSongId(genreId, songId);
        if (genreSong.isEmpty()) {
            throw new NotFoundException("Can't find any genre-song");
        }
        GenreSong existing = genreSong.get();
        genreSongRepo.delete(existing);
    }

    public void updateGenresForSong(Integer songId, List<Integer> newGenreIds) {
        List<Integer> oldList = genreSongRepo.findBySongId(songId, false)
                .stream()
                .map(it -> it.getGenreId().getId())
                .toList();
        if (newGenreIds.isEmpty()) {
            oldList.forEach(it -> deleteByGenreIdAndSongId(it, songId));
            return;
        }
        List<Integer> removedIds = oldList.stream()
                .filter(item -> !newGenreIds.contains(item))
                .toList();

        List<Integer> toAddIds = newGenreIds.stream()
                .filter(item -> !oldList.contains(item))
                .toList();

        toAddIds.stream()
                .map(it -> new NewOrUpdateGenreSong(null, it, songId))
                .forEach(this::addNewGenreSong);

        removedIds.forEach(it -> deleteByGenreIdAndSongId(it, songId));
    }

    public NewOrUpdateGenreSong updateGenreSong(NewOrUpdateGenreSong request) {

        Optional<GenreSong> existingGenreSong = genreSongRepo.findById(request.getId());
        if (existingGenreSong.isEmpty()) {
            throw new NotFoundException("Can't find any genre-song relation with id: " + request.getId());
        }


        Optional<Genres> genre = genreRepo.findByIdAndIsDeleted(request.getGenreId(), false);
        if (genre.isEmpty()) {
            throw new NotFoundException("Can't find any genre with id: " + request.getGenreId());
        }


        Optional<Songs> song = songRepo.findByIdAndIsDeleted(request.getSongId(), false);
        if (song.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + request.getSongId());
        }


        GenreSong genreSong = existingGenreSong.get();
        genreSong.setGenreId(genre.get());
        genreSong.setSongId(song.get());
        genreSongRepo.save(genreSong);

        return request;
    }

    public GenreSongResponse toGenreSongResponse(GenreSong genreSong) {
        GenreSongResponse res = new GenreSongResponse();
        BeanUtils.copyProperties(genreSong, res);
        res.setGenreId(genreSong.getGenreId().getId());
        res.setSongId(genreSong.getSongId().getId());
        return res;
    }
}
