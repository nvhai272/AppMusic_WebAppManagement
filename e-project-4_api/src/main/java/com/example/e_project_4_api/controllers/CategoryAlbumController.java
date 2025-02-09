package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.NewOrUpdateCategoryAlbum;
import com.example.e_project_4_api.dto.response.common_response.CategoryAlbumResponse;
import com.example.e_project_4_api.service.CategoryAlbumService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class CategoryAlbumController {

    @Autowired
    private CategoryAlbumService subjectAlbumService;


    @GetMapping("/public/category-album")
    public ResponseEntity<List<CategoryAlbumResponse>> getAllSubjectAlbums() {
        List<CategoryAlbumResponse> subjectAlbums = subjectAlbumService.getAllSubjectAlbums();
        return new ResponseEntity<>(subjectAlbums, HttpStatus.OK);
    }

    @GetMapping("/public/category-album/{id}")
    public ResponseEntity<CategoryAlbumResponse> getSubjectAlbumById(@PathVariable int id) {
        CategoryAlbumResponse subjectAlbum = subjectAlbumService.findById(id);
        return new ResponseEntity<>(subjectAlbum, HttpStatus.OK);
    }

    @PostMapping("/public/category-album")
    public ResponseEntity<NewOrUpdateCategoryAlbum> createSubjectAlbum(@RequestBody @Valid NewOrUpdateCategoryAlbum request) {
        NewOrUpdateCategoryAlbum createdSubjectAlbum = subjectAlbumService.addNewCategoryAlbum(request);
        return new ResponseEntity<>(createdSubjectAlbum, HttpStatus.CREATED);
    }

    @PutMapping("public/category-album")
    public ResponseEntity<NewOrUpdateCategoryAlbum> updateSubjectAlbum(@RequestBody @Valid NewOrUpdateCategoryAlbum request) {
        NewOrUpdateCategoryAlbum updatedSubjectAlbum = subjectAlbumService.updateCategoryAlbum(request);
        return new ResponseEntity<>(updatedSubjectAlbum, HttpStatus.OK);
    }

//    @PutMapping("admin/category-album")
//    public ResponseEntity<Object> updateSubjectAlbumForAdmin(@RequestBody @Valid UpdateCategoriesForAlbum request) {
//        subjectAlbumService.updateCategoriesForAlbum(request);
//        return new ResponseEntity<>(Map.of(
//                "message", "update successfully"
//        ), HttpStatus.OK);
//    }

    @DeleteMapping("public/category-album/{id}")
    public ResponseEntity<Object> deleteSubjectAlbum(@PathVariable int id) {
        subjectAlbumService.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }
}
