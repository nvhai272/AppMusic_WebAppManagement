package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.NewOrUpdateGenres;
import com.example.e_project_4_api.dto.request.UpdateFileModel;
import com.example.e_project_4_api.dto.response.common_response.GenresResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.CategoryDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.GenreDisplayForAdmin;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.Albums;
import com.example.e_project_4_api.models.Artists;
import com.example.e_project_4_api.models.Colors;
import com.example.e_project_4_api.models.Genres;
import com.example.e_project_4_api.repositories.ColorRepository;
import com.example.e_project_4_api.repositories.GenreSongRepository;
import com.example.e_project_4_api.repositories.GenresRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class GenresService {
    @Autowired
    private GenresRepository repo;
    @Autowired
    private GenreSongRepository gSRepo;
    @Autowired
    private ColorRepository colorRepository;
    @Autowired
    private FileService fileService;

    @Cacheable("genresDisplay")
    public List<GenresResponse> getAllGenres() {
        return repo.findAllNotDeleted(false)
                .stream()
                .map(this::toGenreResponse)
                .collect(Collectors.toList());
    }

    public int getNumberOfGenre() {
        return repo.getNumberOfAllNotDeleted(false);
    }

    @Cacheable(value = "genresDisplayForAdmin", key = "#page")
    public List<GenreDisplayForAdmin> getAllGenreDisplayForAdmin(int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.findAllNotDeletedPaging(false, pageable)
                .stream()
                .map(this::toGenreDisplayForAdmin)
                .collect(Collectors.toList());
    }
    public List<GenreDisplayForAdmin> getSearchGenresDisplayForAdmin(String searchTxt, int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.searchNotDeletedPaging(searchTxt, false, pageable)
                .stream()
                .map(this::toGenreDisplayForAdmin)
                .collect(Collectors.toList());
    }

    public GenresResponse findById(int id) {
        Optional<Genres> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any genre with id: " + id);
        }
        return toGenreResponse(op.get());
    }

    public GenreDisplayForAdmin findGenreDisplayForAdminById(int id) {
        Optional<Genres> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any genre with id: " + id);
        }
        return toGenreDisplayForAdmin(op.get());
    }

    @CacheEvict(value = {"genresDisplay", "genresDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs", "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public boolean deleteById(int id) {
        Optional<Genres> genre = repo.findById(id);
        if (genre.isEmpty()) {
            throw new NotFoundException("Can't find any genre with id: " + id);
        }
        Genres existing = genre.get();
        existing.setIsDeleted(true);
        repo.save(existing);
        return true;
    }

    @CacheEvict(value = {"genresDisplay", "genresDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs", "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public NewOrUpdateGenres addNewGenre(NewOrUpdateGenres request) {
        try {

            List<Map<String, String>> errors = new ArrayList<>();


            Optional<Genres> op = repo.findByTitle(request.getTitle());
            if (op.isPresent()) {
                errors.add(Map.of("titleError", "Already exist title"));
            }
            Optional<Colors> colorOp = colorRepository.findById(request.getColorId());
            if (colorOp.isEmpty()) {
                errors.add(Map.of("colorError", "Can't find color"));
            }

            if (!errors.isEmpty()) {
                throw new ValidationException(errors);
            }

            Genres newGenre = new Genres(
                    request.getTitle(),
                    request.getImage(),
                    false,
                    colorOp.get(),
                    new Date(),
                    new Date()
            );

            repo.save(newGenre);

            return request;
        } catch (RuntimeException e) {
            // Xóa file nếu insert database thất bại
            fileService.deleteImageFile(request.getImage());
            throw e;
        }
    }

    @CacheEvict(value = {"genresDisplay", "genresDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs", "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public void updateGenreImage(UpdateFileModel request) {
        Optional<Genres> op = repo.findByIdAndIsDeleted(request.getId(), false);
        //check sự tồn tại
        if (op.isEmpty()) {
            fileService.deleteImageFile(request.getFileName());
            throw new NotFoundException("Can't find any genre with id: " + request.getId());
        }
        Genres genre = op.get();
        fileService.deleteImageFile(genre.getImage());
        genre.setImage(request.getFileName());

        genre.setModifiedAt(new Date());
        repo.save(genre);

    }

    @CacheEvict(value = {"genresDisplay", "genresDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs", "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public NewOrUpdateGenres updateGenre(NewOrUpdateGenres request) {
        List<Map<String, String>> errors = new ArrayList<>();


        Optional<Genres> op = repo.findByIdAndIsDeleted(request.getId(), false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any genre with id: " + request.getId());
        }


        Optional<Genres> opTitle = repo.findByTitle(request.getTitle());
        if (opTitle.isPresent() && opTitle.get().getTitle() != op.get().getTitle()) {
            errors.add(Map.of("titleError", "Already exist title"));
        }

        Optional<Colors> colorOp = colorRepository.findById(request.getColorId());
        if (colorOp.isEmpty()) {
            errors.add(Map.of("colorError", "Can't find color"));
        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }


        Genres genre = op.get();
        if (!StringUtils.isEmpty(request.getImage())) {
            //check xem có ảnh ko, có thì thay mới, ko thì thôi
            fileService.deleteImageFile(genre.getImage());
            genre.setImage(request.getImage());
        }
        genre.setTitle(request.getTitle());
        genre.setModifiedAt(new Date());
        genre.setColorId(colorOp.get());
        repo.save(genre);

        return request;
    }


    public GenresResponse toGenreResponse(Genres genre) {
        GenresResponse res = new GenresResponse();
        res.setColor(genre.getColorId().getTitle());
        res.setColor(genre.getColorId().getTitle());
        res.setColorId(genre.getColorId().getId());
        BeanUtils.copyProperties(genre, res);
        return res;
    }

    public GenreDisplayForAdmin toGenreDisplayForAdmin(Genres genre) {
        GenreDisplayForAdmin res = new GenreDisplayForAdmin();
        BeanUtils.copyProperties(genre, res);
        res.setTotalSong(gSRepo.findByGenreId(genre.getId(), false)
                .stream()
                .toList()
                .size());
        res.setColor(genre.getColorId().getTitle());
        return res;
    }

    public List<Colors> getAllColors() {
        return colorRepository.findAll();
    }
}
