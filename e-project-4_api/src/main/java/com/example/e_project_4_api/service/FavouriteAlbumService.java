package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.LikeBaseModel;
import com.example.e_project_4_api.dto.request.NewOrUpdateFavouriteAlbum;
import com.example.e_project_4_api.dto.response.common_response.FavouriteAlbumResponse;
import com.example.e_project_4_api.ex.AlreadyExistedException;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.models.*;
import com.example.e_project_4_api.repositories.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FavouriteAlbumService {
    @Autowired
    FavouriteAlbumRepository repo;

    @Autowired
    UserRepository userRepo;
    @Autowired
    AlbumRepository albumRepo;

    public List<FavouriteAlbumResponse> getAllFavouriteAlbum() {
        return repo.findAll()
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public FavouriteAlbumResponse findById(int id) {
        Optional<FavouriteAlbums> op = repo.findById(id);
        if (op.isPresent()) {
            FavouriteAlbums fs = op.get();
            return toResponse(fs);
        } else {
            throw new NotFoundException("Can't find any FavouriteAlbum with id: " + id);
        }
    }

    public void deleteById(int id) {
        if (!repo.existsById(id)) {
            throw new NotFoundException("Can't find any FavouriteAlbum with id: " + id);
        }
        repo.deleteById(id);
    }

    public NewOrUpdateFavouriteAlbum addNewFA(NewOrUpdateFavouriteAlbum request) {
        Optional<FavouriteAlbums> existingFavouriteSong = repo.findByUserIdAndAlbumId(request.getUserId(), request.getAlbumId());
        if (existingFavouriteSong.isPresent()) {
            throw new AlreadyExistedException("A FavouriteAlbum already exists");
        }
        Users u = userRepo.findByIdAndIsDeleted(request.getUserId(), false)
                .orElseThrow(() -> new NotFoundException("User not found with id: " + request.getUserId()));
        Albums album = albumRepo.findByIdAndIsDeleted(request.getAlbumId(), false)
                .orElseThrow(() -> new NotFoundException("Album not found with id: " + request.getAlbumId()));
        FavouriteAlbums newPS = new FavouriteAlbums(album, u);
        repo.save(newPS);
        return request;
    }

    public NewOrUpdateFavouriteAlbum updateFA(NewOrUpdateFavouriteAlbum request) {
        Optional<FavouriteAlbums> op = repo.findById(request.getId());
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any FavouriteAlbum with id: " + request.getId());
        }
        Users u = userRepo.findByIdAndIsDeleted(request.getUserId(), false)
                .orElseThrow(() -> new NotFoundException("User not found with id: " + request.getUserId()));
        Albums album = albumRepo.findByIdAndIsDeleted(request.getAlbumId(), false)
                .orElseThrow(() -> new NotFoundException("Album not found with id: " + request.getAlbumId()));
        FavouriteAlbums ps = op.get();
        ps.setUserId(u);
        ps.setAlbumId(album);

        repo.save(ps);
        return request;
    }

    public boolean checkIsLikeAlbum(LikeBaseModel request) {
        Optional<FavouriteAlbums> op = repo.findByUserIdAndAlbumId(request.getUserId(), request.getItemId());
        return op.isPresent();
    }

    private FavouriteAlbumResponse toResponse(FavouriteAlbums ps) {
        FavouriteAlbumResponse res = new FavouriteAlbumResponse();
        res.setUserId(ps.getUserId().getId());
        res.setAlbumId(ps.getAlbumId().getId());
        BeanUtils.copyProperties(ps, res);
        return res;
    }
}