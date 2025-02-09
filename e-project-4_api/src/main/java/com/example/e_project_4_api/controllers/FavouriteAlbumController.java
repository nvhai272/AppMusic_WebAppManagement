package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.LikeBaseModel;
import com.example.e_project_4_api.dto.request.NewOrUpdateFavouriteAlbum;
import com.example.e_project_4_api.dto.response.common_response.FavouriteAlbumResponse;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.service.FavouriteAlbumService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
class FavouriteAlbumController {
    @Autowired
    public FavouriteAlbumService service;

    @GetMapping("/public/favourite-albums")
    public ResponseEntity<List<FavouriteAlbumResponse>> findAll() {
        return new ResponseEntity<>(service.getAllFavouriteAlbum(), HttpStatus.OK);
    }

    @GetMapping("/public/favourite-albums/{id}")
    public ResponseEntity<Object> findDetails(@PathVariable("id") int id) {

        FavouriteAlbumResponse sub = service.findById(id);
        return new ResponseEntity<>(sub, HttpStatus.OK);

    }

    @PostMapping("/public/favourite-albums/check")
    public ResponseEntity<Object> checkIsLike(@RequestBody @Valid LikeBaseModel request) {

        boolean result = service.checkIsLikeAlbum(request);
        return new ResponseEntity<>(Map.of(
                "isLike", result
        ), HttpStatus.OK);

    }

    @DeleteMapping("/public/favourite-albums/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") int id) {

        service.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }

    @PostMapping("/public/favourite-albums")
    public ResponseEntity<Object> add(@RequestBody @Valid NewOrUpdateFavouriteAlbum request) {
        try {
            NewOrUpdateFavouriteAlbum newSub = service.addNewFA(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "FavouriteAlbum added successfully",
                            "data", newSub
                    ),
                    HttpStatus.OK
            );
        } catch (ValidationException e) {
            return new ResponseEntity<>(
                    Map.of(
                            "listError", e.getErrors()
                    ),
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    @PutMapping("/public/favourite-albums")
    public ResponseEntity<Object> update(@RequestBody @Valid NewOrUpdateFavouriteAlbum request) {
        try {
            NewOrUpdateFavouriteAlbum updatedSub = service.updateFA(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "FavouriteAlbum updated successfully",
                            "data", updatedSub
                    ),
                    HttpStatus.OK
            );
        } catch (ValidationException e) {
            return new ResponseEntity<>(
                    Map.of(
                            "listError", e.getErrors()
                    ),
                    HttpStatus.BAD_REQUEST
            );
        }
    }
}