package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.*;
import com.example.e_project_4_api.dto.response.common_response.AlbumResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.AlbumDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.ArtistDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_response.AlbumDisplay;
import com.example.e_project_4_api.dto.response.display_response.SongDisplay;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.service.AlbumService;
import com.example.e_project_4_api.service.FavouriteAlbumService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class AlbumController {
    @Autowired
    private AlbumService service;
    @Autowired
    private FavouriteAlbumService favService;

    @GetMapping("/public/albums")
    public ResponseEntity<List<AlbumResponse>> findAll() {
        return new ResponseEntity<>(service.getAllAlbums(), HttpStatus.OK);
    }

    @GetMapping("/public/albums/display")
    public ResponseEntity<List<AlbumDisplay>> findAllAlbumsForDisplay() {
        return new ResponseEntity<>(service.getAllAlbumsForDisplay(), HttpStatus.OK);
    }

    @GetMapping("/admin/albums/display")
    public ResponseEntity<List<AlbumDisplayForAdmin>> findAllAlbumsDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page) {
        return new ResponseEntity<>(service.getAllAlbumsDisplayForAdmin(page), HttpStatus.OK);
    }

    @GetMapping("/admin/albums/display/search")
    public ResponseEntity<List<AlbumDisplayForAdmin>> getSearchedAlbumsDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page, @RequestParam(value = "searchTxt", defaultValue = "") String searchTxt) {
        return new ResponseEntity<>(service.getSearchAlbumsDisplayForAdmin(searchTxt, page), HttpStatus.OK);
    }

    @GetMapping("/admin/albums/count")
    public ResponseEntity<Object> getQuantity() {
        return new ResponseEntity<>(Map.of("qty", service.getNumberOfAlbum()), HttpStatus.OK);
    }

    @GetMapping("/public/albums/byArtist/display/{id}")
    public ResponseEntity<List<AlbumDisplay>> findAllAlbumsByArtistIdForDisplay(@PathVariable("id") int id) {
        return new ResponseEntity<>(service.getAllAlbumsByArtistIdForDisplay(id), HttpStatus.OK);
    }

    @GetMapping("/admin/albums/byArtist/display/{id}")
    public ResponseEntity<List<AlbumDisplayForAdmin>> findAllAlbumsByArtistIdForAdmin
            (@PathVariable("id") int id, @RequestParam(value = "page", defaultValue = "0") int page) {
        return new ResponseEntity<>(service.getAllAlbumsByArtistIdForAdmin(id, page), HttpStatus.OK);
    }

    @GetMapping("/public/albums/{id}")
    public ResponseEntity<Object> findDetails(@PathVariable("id") int id) {
        AlbumResponse album = service.findById(id);
        return new ResponseEntity<>(album, HttpStatus.OK);

    }

    @GetMapping("/public/albums/search/{text}")
    public ResponseEntity<List<AlbumDisplay>> search(@PathVariable("text") String searchTxt) {
        return new ResponseEntity<>(service.search(searchTxt), HttpStatus.OK);
    }

    @GetMapping("/public/albums/display/{id}")
    public ResponseEntity<Object> findDisplayDetails(@PathVariable("id") int id) {
        AlbumDisplay album = service.findDisplayById(id);
        return new ResponseEntity<>(album, HttpStatus.OK);
    }

    @GetMapping("/admin/albums/display/{id}")
    public ResponseEntity<Object> findDisplayDetailsForAdmin(@PathVariable("id") int id) {
        AlbumDisplayForAdmin album = service.findDisplayForAdminById(id);
        return new ResponseEntity<>(album, HttpStatus.OK);
    }

    @GetMapping("/public/albums/byUser/display/{id}")
    public ResponseEntity<List<AlbumDisplay>> findAllAlbumsByUserIdForDisplay(@PathVariable("id") int id) {
        return new ResponseEntity<>(service.getAllFavAlbumsByUserId(id), HttpStatus.OK);
    }

    @GetMapping("/admin/albums/byUser/display/{id}")
    public ResponseEntity<List<AlbumDisplayForAdmin>> findAllAlbumsByUserIdForAdmin
            (@PathVariable("id") int id, @RequestParam(value = "page", defaultValue = "0") int page) {
        return new ResponseEntity<>(service.getAllFavAlbumsByUserIdForAdmin(id, page), HttpStatus.OK);
    }

    @GetMapping("/public/albums/byCategory/display/{id}")
    public ResponseEntity<List<AlbumDisplay>> findAllAlbumsBySubjectIdForDisplay(@PathVariable("id") int id) {
        List<AlbumDisplay> album = service.getAllAlbumsBySubjectIdForDisplay(id);
        return new ResponseEntity<>(album, HttpStatus.OK);
    }

    @GetMapping("/admin/albums/byCategory/display/{id}")
    public ResponseEntity<List<AlbumDisplayForAdmin>> findAllAlbumsBySubjectIdForDisplay
            (@PathVariable("id") int id, @RequestParam(value = "page", defaultValue = "0") int page) {
        List<AlbumDisplayForAdmin> album = service.getAllAlbumsBySubjectIdForAdmin(id, page);
        return new ResponseEntity<>(album, HttpStatus.OK);
    }

    @DeleteMapping("/public/albums/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") int id) {
        service.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }

    @PostMapping("/public/albums")
    public ResponseEntity<Object> add(@RequestBody @Valid NewOrUpdateAlbum request) {
        try {
            NewOrUpdateAlbum newAlbum = service.addNewAlbum(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "Album added successfully",
                            "data", newAlbum
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

    @PutMapping("/public/albums")
    public ResponseEntity<Object> update(@RequestBody @Valid NewOrUpdateAlbum request) {
        try {
            NewOrUpdateAlbum updatedAlbum = service.updateAlbum(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "Album updated successfully",
                            "data", updatedAlbum
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

    @PostMapping("/public/albums/like")
    public ResponseEntity<Object> likeAlbum(@RequestBody @Valid LikeBaseModel request) {
        service.like(request);
        return new ResponseEntity<>(
                Map.of(
                        "message", "like successfully"
                ),
                HttpStatus.OK
        );
    }

    @PutMapping("/admin/albums/toggle/release/{id}")
    public ResponseEntity<Object> toggleReleaseAlbum(@PathVariable("id") int id) {
        service.toggleAlbumReleaseStatus(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "changes successfully"
                ),
                HttpStatus.OK
        );
    }

    @PutMapping("/admin/albums/change/image")
    public ResponseEntity<Object> changeImage(@RequestBody @Valid UpdateFileModel request) {
        service.updateAlbumImage(request);
        return new ResponseEntity<>(
                Map.of(
                        "message", "changes successfully"
                ),
                HttpStatus.OK
        );
    }

    @DeleteMapping("public/albums/unlike")
    public ResponseEntity<Object> unlikeAlbum(@RequestBody @Valid LikeBaseModel request) {
        service.unlikeAlbum(request);
        return new ResponseEntity<>(
                Map.of(
                        "message", "unlike successfully"
                ),
                HttpStatus.OK
        );
    }
}
