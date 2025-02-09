package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.NewOrUpdateArtist;
import com.example.e_project_4_api.dto.request.UpdateFileModel;
import com.example.e_project_4_api.dto.response.common_response.ArtistResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.ArtistDisplayForAdmin;
import com.example.e_project_4_api.service.ArtistService;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ArtistController {

    @Autowired
    private ArtistService artistService;


    @GetMapping("/public/artists")
    public ResponseEntity<List<ArtistResponse>> getAllArtists() {
        return new ResponseEntity<>(artistService.getAllArtists(), HttpStatus.OK);
    }

    @GetMapping("/admin/artists/display")
    public ResponseEntity<List<ArtistDisplayForAdmin>> getAllArtistsDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page) {
        return new ResponseEntity<>(artistService.getAllArtistsDisplayForAdmin(page), HttpStatus.OK);
    }

    @GetMapping("/admin/artists/display/search")
    public ResponseEntity<List<ArtistDisplayForAdmin>> getSearchedArtistsDisplayForAdmin
            (@RequestParam(value = "page", defaultValue = "0") int page, @RequestParam(value = "searchTxt", defaultValue = "") String searchTxt) {
        return new ResponseEntity<>(artistService.getSearchArtistsDisplayForAdmin(searchTxt, page), HttpStatus.OK);
    }

    @GetMapping("/admin/artists/count")
    public ResponseEntity<Object> getQuantity() {
        return new ResponseEntity<>(Map.of("qty", artistService.getNumberOfArtist()), HttpStatus.OK);
    }

    @GetMapping("/public/artists/{id}")
    public ResponseEntity<Object> getArtistById(@PathVariable int id) {
        ArtistResponse artist = artistService.findById(id);
        return new ResponseEntity<>(artist, HttpStatus.OK);
    }

    @GetMapping("/admin/artists/display/{id}")
    public ResponseEntity<Object> getArtistDisplayForAdminById(@PathVariable int id) {
        ArtistDisplayForAdmin artist = artistService.findByIdForAdmin(id);
        return new ResponseEntity<>(artist, HttpStatus.OK);
    }


    @PostMapping("/public/artists")
    public ResponseEntity<Object> addNewArtist(@RequestBody @Valid NewOrUpdateArtist request) {
        try {
            NewOrUpdateArtist newArtist = artistService.addNewArtist(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(newArtist);
        } catch (ValidationException e) {
            return new ResponseEntity<>(
                    Map.of(
                            "listError", e.getErrors()
                    ),
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    @PutMapping("/admin/artists/change/image")
    public ResponseEntity<Object> changeImage(@RequestBody @Valid UpdateFileModel request) {
        artistService.updateArtistImage(request);
        return new ResponseEntity<>(
                Map.of(
                        "message", "changes successfully"
                ),
                HttpStatus.OK
        );
    }

    @PutMapping("/public/artists")
    public ResponseEntity<Object> updateArtist(@RequestBody @Valid NewOrUpdateArtist request) {
        try {
            NewOrUpdateArtist updatedArtist = artistService.updateArtist(request);
            return ResponseEntity.ok(updatedArtist);
        } catch (ValidationException ex) {
            return new ResponseEntity<>(
                    Map.of(
                            "listError", ex.getErrors()
                    ),
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    @DeleteMapping("/public/artists/{id}")
    public ResponseEntity<Object> deleteArtist(@PathVariable int id) {
        artistService.deleteById(id);
        return new ResponseEntity<>(
                Map.of(
                        "message", "Deleted successfully"
                ),
                HttpStatus.OK
        );
    }
}
