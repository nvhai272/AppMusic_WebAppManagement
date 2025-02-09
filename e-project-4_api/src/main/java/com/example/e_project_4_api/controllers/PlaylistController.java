package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.NewOrUpdatePlaylist;
import com.example.e_project_4_api.dto.response.common_response.PlaylistResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.GenreDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.PlaylistDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_response.PlaylistDisplay;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.service.PlaylistService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class PlaylistController {
    @Autowired
    private PlaylistService service;

    @GetMapping("/public/playlists")
    public ResponseEntity<List<PlaylistResponse>> findAll() {
        return new ResponseEntity<>(service.getAllPlaylists(), HttpStatus.OK);
    }

    @GetMapping("/public/playlists/display")
    public ResponseEntity<List<PlaylistDisplay>> findAllPlaylistsForDisplay() {
        return new ResponseEntity<>(service.getAllPlaylistsForDisplay(), HttpStatus.OK);
    }

    @GetMapping("/admin/playlists/count")
    public ResponseEntity<Object> getQuantity() {
        return new ResponseEntity<>(Map.of("qty", service.getNumberOfPlaylist()), HttpStatus.OK);
    }

    @GetMapping("/admin/playlists/display/search")
    public ResponseEntity<List<PlaylistDisplayForAdmin>> getSearchedPlaylistsDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page, @RequestParam(value = "searchTxt", defaultValue = "") String searchTxt) {
        return new ResponseEntity<>(service.getSearchPlaylistsDisplayForAdmin(searchTxt, page), HttpStatus.OK);
    }

    @GetMapping("/admin/playlists/display")
    public ResponseEntity<List<PlaylistDisplayForAdmin>> findAllPlaylistsDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page) {
        return new ResponseEntity<>(service.getAllPlaylistsDisplayForAdmin(page), HttpStatus.OK);
    }

    @GetMapping("/public/playlists/byUser/display/{id}")
    public ResponseEntity<List<PlaylistDisplay>> findAllPlaylistsByUserIdForDisplay(@PathVariable("id") int id) {
        return new ResponseEntity<>(service.getAllPlaylistsByUserIdForDisplay(id), HttpStatus.OK);
    }

    @GetMapping("/public/playlists/{id}")
    public ResponseEntity<Object> findDetails(@PathVariable("id") int id) {
        PlaylistResponse playlist = service.findById(id);
        return new ResponseEntity<>(playlist, HttpStatus.OK);
    }

    @GetMapping("/public/playlists/display/{id}")
    public ResponseEntity<Object> findDisplayDetails(@PathVariable("id") int id) {
        PlaylistDisplay playlist = service.findDisplayById(id);
        return new ResponseEntity<>(playlist, HttpStatus.OK);
    }

    @GetMapping("/admin/playlists/display/{id}")
    public ResponseEntity<Object> findDisplayDetailsForAdmin(@PathVariable("id") int id) {
        PlaylistDisplayForAdmin playlist = service.findDisplayForAdminById(id);
        return new ResponseEntity<>(playlist, HttpStatus.OK);
    }

    @DeleteMapping("/public/playlists/{id}")
    public ResponseEntity<Object> delete(@PathVariable("id") int id) {
        service.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }

    @PostMapping("/public/playlists")
    public ResponseEntity<Object> add(@RequestBody @Valid NewOrUpdatePlaylist request) {
        try {

            NewOrUpdatePlaylist newPlaylist = service.addNewPlaylist(request);
            return new ResponseEntity<>(
                    Map.of(
                            "message", "Playlist added successfully",
                            "data", newPlaylist
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

    @PutMapping("/public/playlists")
    public ResponseEntity<Object> update(@RequestBody @Valid NewOrUpdatePlaylist request) {
        try {

            NewOrUpdatePlaylist updatedPlaylist = service.updatePlaylist(request);

            return new ResponseEntity<>(
                    Map.of(
                            "message", "Playlist updated successfully",
                            "data", updatedPlaylist
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
