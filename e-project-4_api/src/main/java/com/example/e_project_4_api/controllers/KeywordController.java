package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.NewOrUpdateKeyword;
import com.example.e_project_4_api.dto.request.NewOrUpdateNews;
import com.example.e_project_4_api.dto.response.common_response.KeywordResponse;
import com.example.e_project_4_api.dto.response.common_response.NewsResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.GenreDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.KeywordDisplayForAdmin;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.service.KeywordService;
import com.example.e_project_4_api.service.NewsService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api")
public class KeywordController {

    @Autowired
    private KeywordService service;


    @GetMapping("/public/keywords")
    public ResponseEntity<List<KeywordResponse>> findAll() {
        return new ResponseEntity<>(service.getAllKeywords(), HttpStatus.OK);
    }

    @GetMapping("/admin/keywords/display")
    public ResponseEntity<List<KeywordDisplayForAdmin>> findAllForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page) {
        return new ResponseEntity<>(service.getAllKeywordsForAdmin(page), HttpStatus.OK);
    }

    @GetMapping("/admin/keywords/display/search")
    public ResponseEntity<List<KeywordDisplayForAdmin>> getSearchedKeywordsDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page, @RequestParam(value = "searchTxt", defaultValue = "") String searchTxt) {
        return new ResponseEntity<>(service.getSearchKeywordsDisplayForAdmin(searchTxt, page), HttpStatus.OK);
    }

    @GetMapping("/admin/keywords/count")
    public ResponseEntity<Object> getQuantity() {
        return new ResponseEntity<>(Map.of("qty", service.getNumberOfKeywords()), HttpStatus.OK);
    }

    @GetMapping("/public/keywords/{id}")
    public ResponseEntity<Object> findDetails(@PathVariable("id") int id) {
        KeywordResponse keyword = service.findById(id);
        return new ResponseEntity<>(keyword, HttpStatus.OK);
    }

    @GetMapping("/admin/keywords/display/{id}")
    public ResponseEntity<Object> findDetailsForAdmin(@PathVariable("id") int id) {
        KeywordDisplayForAdmin keyword = service.findByIdForAdmin(id);
        return new ResponseEntity<>(keyword, HttpStatus.OK);
    }


    @DeleteMapping("/public/keywords/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") int id) {
        service.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }

    @PostMapping("/public/keywords")
    public ResponseEntity<Object> add(@RequestBody @Valid NewOrUpdateKeyword request) {
        try {
            NewOrUpdateKeyword keyword = service.addNew(request);
            return new ResponseEntity<>(
                    Map.of(
                            "message", "Keyword added successfully",
                            "data", keyword
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


    @PutMapping("/public/keywords")
    public ResponseEntity<Object> update(@RequestBody @Valid NewOrUpdateKeyword request) {
        try {
            NewOrUpdateKeyword updatedKeyword = service.updateKeyword(request);
            return new ResponseEntity<>(
                    Map.of(
                            "message", "Keyword updated successfully",
                            "data", updatedKeyword
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

    @PutMapping("/admin/keywords/toggle/active/{id}")
    public ResponseEntity<Object> toggleKeywordActive(@PathVariable("id") int id) {
        service.toggleKeywordActiveStatus(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "changes successfully"
                ),
                HttpStatus.OK
        );
    }
}
