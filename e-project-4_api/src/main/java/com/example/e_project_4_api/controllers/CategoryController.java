package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.NewOrUpdateCategory;
import com.example.e_project_4_api.dto.response.common_response.CategoryResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.AlbumDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.CategoryDisplayForAdmin;
import com.example.e_project_4_api.dto.response.mix_response.CategoryWithAlbumsResponse;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.service.CategoryService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class CategoryController {
    @Autowired
    public CategoryService service;

    @GetMapping("/public/categories")
    public ResponseEntity<List<CategoryResponse>> findAll() {
        return new ResponseEntity<>(service.getAllCategories(), HttpStatus.OK);
    }

    @GetMapping("/admin/categories/display")
    public ResponseEntity<List<CategoryDisplayForAdmin>> findAllForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page) {
        return new ResponseEntity<>(service.getAllCategoriesDisplayForAdmin(page), HttpStatus.OK);
    }

    @GetMapping("/admin/categories/display/search")
    public ResponseEntity<List<CategoryDisplayForAdmin>> getSearchedCategoriesDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page, @RequestParam(value = "searchTxt", defaultValue = "") String searchTxt) {
        return new ResponseEntity<>(service.getSearchCategoriesDisplayForAdmin(searchTxt, page), HttpStatus.OK);
    }

    @GetMapping("/admin/categories/count")
    public ResponseEntity<Object> getQuantity() {
        return new ResponseEntity<>(Map.of("qty", service.getNumberOfCate()), HttpStatus.OK);
    }

    @GetMapping("/public/categories/withAlbum")
    public ResponseEntity<List<CategoryWithAlbumsResponse>> findAllCateWithAlbums() {
        return new ResponseEntity<>(service.getAllCategoriesWithAlbums(), HttpStatus.OK);
    }

    @GetMapping("/public/categories/{id}")
    public ResponseEntity<Object> findDetails(@PathVariable("id") int id) {
        CategoryResponse sub = service.findById(id);
        return new ResponseEntity<>(sub, HttpStatus.OK);
    }

    @GetMapping("/admin/categories/display/{id}")
    public ResponseEntity<Object> findDetailsForAdmin(@PathVariable("id") int id) {
        CategoryDisplayForAdmin sub = service.findByIdForAdmin(id);
        return new ResponseEntity<>(sub, HttpStatus.OK);
    }

    @DeleteMapping("/public/categories/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") int id) {
        service.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }

    @PostMapping("/public/categories")
    public ResponseEntity<Object> add(@RequestBody @Valid NewOrUpdateCategory request) {
        try {
            NewOrUpdateCategory newSub = service.addNewSubject(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "Category added successfully",
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

    @PutMapping("/public/categories")
    public ResponseEntity<Object> update(@RequestBody @Valid NewOrUpdateCategory request) {
        try {
            NewOrUpdateCategory updatedSub = service.updateSubject(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "Category updated successfully",
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