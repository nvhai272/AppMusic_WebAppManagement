package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.NewOrUpdateGenres;
import com.example.e_project_4_api.dto.request.UpdateFileModel;
import com.example.e_project_4_api.dto.response.common_response.GenresResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.CategoryDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.GenreDisplayForAdmin;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.Colors;
import com.example.e_project_4_api.service.GenresService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api")
public class GenresController {

    @Autowired
    private GenresService service;


    @GetMapping("/public/genres")
    public ResponseEntity<List<GenresResponse>> findAll() {
        return new ResponseEntity<>(service.getAllGenres(), HttpStatus.OK);
    }

    @GetMapping("/admin/genres/display")
    public ResponseEntity<List<GenreDisplayForAdmin>> findAllGenreDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page) {
        return new ResponseEntity<>(service.getAllGenreDisplayForAdmin(page), HttpStatus.OK);
    }

    @GetMapping("/admin/genres/display/search")
    public ResponseEntity<List<GenreDisplayForAdmin>> getSearchedGenresDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page, @RequestParam(value = "searchTxt", defaultValue = "") String searchTxt) {
        return new ResponseEntity<>(service.getSearchGenresDisplayForAdmin(searchTxt, page), HttpStatus.OK);
    }

    @GetMapping("/admin/genres/count")
    public ResponseEntity<Object> getQuantity() {
        return new ResponseEntity<>(Map.of("qty", service.getNumberOfGenre()), HttpStatus.OK);
    }

    @GetMapping("/public/genres/{id}")
    public ResponseEntity<Object> findDetails(@PathVariable("id") int id) {
        GenresResponse genre = service.findById(id);
        return new ResponseEntity<>(genre, HttpStatus.OK);
    }

    @GetMapping("/admin/genres/display/{id}")
    public ResponseEntity<Object> findDetailsForAdmin(@PathVariable("id") int id) {
        GenreDisplayForAdmin genre = service.findGenreDisplayForAdminById(id);
        return new ResponseEntity<>(genre, HttpStatus.OK);
    }


    @DeleteMapping("/public/genres/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") int id) {
        service.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }

    @PostMapping("/public/genres")
    public ResponseEntity<Object> add(@RequestBody @Valid NewOrUpdateGenres request) {
        try {
            NewOrUpdateGenres newGenre = service.addNewGenre(request);
            return new ResponseEntity<>(
                    Map.of(
                            "message", "Genre added successfully",
                            "data", newGenre
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

    @PutMapping("/admin/genres/change/image")
    public ResponseEntity<Object> changeImage(@RequestBody @Valid UpdateFileModel request) {
        service.updateGenreImage(request);
        return new ResponseEntity<>(
                Map.of(
                        "message", "changes successfully"
                ),
                HttpStatus.OK
        );
    }

    @PutMapping("/public/genres")
    public ResponseEntity<Object> update(@RequestBody @Valid NewOrUpdateGenres request) {
        try {
            NewOrUpdateGenres updatedGenre = service.updateGenre(request);
            return new ResponseEntity<>(
                    Map.of(
                            "message", "Genre updated successfully",
                            "data", updatedGenre
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

    @GetMapping("/public/colors")
    public ResponseEntity<List<Colors>> findAllColors() {
        return new ResponseEntity<>(service.getAllColors(), HttpStatus.OK);
    }
}
