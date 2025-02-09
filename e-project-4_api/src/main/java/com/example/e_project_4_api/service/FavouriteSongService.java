package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.LikeBaseModel;
import com.example.e_project_4_api.dto.request.NewOrUpdateFavouriteSong;
import com.example.e_project_4_api.dto.response.common_response.FavouriteSongResponse;
import com.example.e_project_4_api.ex.AlreadyExistedException;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.models.FavouriteSongs;
import com.example.e_project_4_api.models.Songs;
import com.example.e_project_4_api.models.Users;
import com.example.e_project_4_api.repositories.FavouriteSongRepository;
import com.example.e_project_4_api.repositories.SongRepository;
import com.example.e_project_4_api.repositories.UserRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FavouriteSongService {
    @Autowired
    FavouriteSongRepository repo;

    @Autowired
    UserRepository userRepo;
    @Autowired
    SongRepository songRepo;

    public List<FavouriteSongResponse> getAllFavouriteSong() {
        return repo.findAll()
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public FavouriteSongResponse findById(int id) {
        Optional<FavouriteSongs> op = repo.findById(id);
        if (op.isPresent()) {
            FavouriteSongs fs = op.get();
            return toResponse(fs);
        } else {
            throw new NotFoundException("Can't find any FavouriteSong with id: " + id);
        }
    }

    public void deleteById(int id) {
        if (!repo.existsById(id)) {
            throw new NotFoundException("Can't find any FavouriteSong with id: " + id);
        }
        repo.deleteById(id);
    }

    public NewOrUpdateFavouriteSong addNewFS(NewOrUpdateFavouriteSong request) {
        Optional<FavouriteSongs> existingFavouriteSong = repo.findByUserIdAndSongId(request.getUserId(), request.getSongId());
        if (existingFavouriteSong.isPresent()) {
            throw new AlreadyExistedException("A FavouriteSong already exists");
        }
        Users u = userRepo.findByIdAndIsDeleted(request.getUserId(), false)
                .orElseThrow(() -> new NotFoundException("User not found with id: " + request.getUserId()));
        Songs song = songRepo.findByIdAndIsDeleted(request.getSongId(), false)
                .orElseThrow(() -> new NotFoundException("Song not found with id: " + request.getSongId()));
        FavouriteSongs newPS = new FavouriteSongs(song, u);
        repo.save(newPS);
        return request;
    }

    public NewOrUpdateFavouriteSong updateFS(NewOrUpdateFavouriteSong request) {
        Optional<FavouriteSongs> op = repo.findById(request.getId());
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any FavouriteSong with id: " + request.getId());
        }
        Users u = userRepo.findByIdAndIsDeleted(request.getUserId(), false)
                .orElseThrow(() -> new NotFoundException("Users not found with id: " + request.getUserId()));
        Songs song = songRepo.findByIdAndIsDeleted(request.getSongId(), false)
                .orElseThrow(() -> new NotFoundException("Song not found with id: " + request.getSongId()));
        FavouriteSongs ps = op.get();
        ps.setUserId(u);
        ps.setSongId(song);

        repo.save(ps);
        return request;
    }

    public boolean checkIsLikeSong(LikeBaseModel request) {
        Optional<FavouriteSongs> op = repo.findByUserIdAndSongId(request.getUserId(), request.getItemId());
        return op.isPresent();
    }

    private FavouriteSongResponse toResponse(FavouriteSongs ps) {
        FavouriteSongResponse res = new FavouriteSongResponse();
        res.setUserId(ps.getUserId().getId());
        res.setSongId(ps.getSongId().getId());
        BeanUtils.copyProperties(ps, res);
        return res;
    }
}