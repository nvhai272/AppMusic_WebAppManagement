package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.NewOrUpdateCategoryAlbum;
import com.example.e_project_4_api.dto.request.NewOrUpdateGenreSong;
import com.example.e_project_4_api.dto.response.common_response.GenreSongResponse;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.service.GenreSongService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class GenreSongController {

    @Autowired
    private GenreSongService service;


    @GetMapping("/public/genre-song")
    public ResponseEntity<List<GenreSongResponse>> findAll() {
        return new ResponseEntity<>(service.getAllGenreSongs(), HttpStatus.OK);
    }


    @GetMapping("/public/genre-song/{id}")
    public ResponseEntity<Object> findDetails(@PathVariable("id") int id) {
        GenreSongResponse genreSong = service.findById(id);
        return new ResponseEntity<>(genreSong, HttpStatus.OK);

    }

//    @PutMapping("admin/genre-song")
//    public ResponseEntity<Object> updateSubjectAlbumForAdmin(@RequestBody @Valid UpdateGenresForSong request) {
//        service.updateGenresForSong(request);
//        return new ResponseEntity<>(Map.of(
//                "message", "update successfully"
//        ), HttpStatus.OK);
//    }

    @DeleteMapping("/public/genre-song/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") int id) {
        service.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }


    @PostMapping("/public/genre-song")
    public ResponseEntity<Object> add(@RequestBody @Valid NewOrUpdateGenreSong request) {
        try {
            NewOrUpdateGenreSong newGenreSong = service.addNewGenreSong(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "GenreSong added successfully",
                            "data", newGenreSong
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


    @PutMapping("/public/genre-song")
    public ResponseEntity<Object> update(@RequestBody @Valid NewOrUpdateGenreSong request) {
        try {
            NewOrUpdateGenreSong updatedGenreSong = service.updateGenreSong(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "GenreSong updated successfully",
                            "data", updatedGenreSong
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
