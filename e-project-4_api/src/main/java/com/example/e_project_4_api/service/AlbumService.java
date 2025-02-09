package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.*;
import com.example.e_project_4_api.dto.response.common_response.AlbumResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.AlbumDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.ArtistDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_response.AlbumDisplay;
import com.example.e_project_4_api.dto.response.display_response.SongDisplay;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.*;
import com.example.e_project_4_api.repositories.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;
import java.util.stream.Collectors;

@Service

public class AlbumService {
    @Autowired
    private AlbumRepository repo;
    @Autowired
    private ArtistRepository artistRepo;
    @Autowired
    private CategoryAlbumRepository categoryAlbumRepo;
    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private FavouriteAlbumRepository favRepo;
    @Autowired
    private CategoryAlbumService categoryAlbumService;
    @Autowired
    private FavouriteAlbumService favouriteAlbumService;
    @Autowired
    private FileService fileService;

    public List<AlbumResponse> getAllAlbums() {
        return repo.findAllNotDeleted(false)
                .stream()
                .map(this::toAlbumResponse)
                .collect(Collectors.toList());
    }

    public int getNumberOfAlbum() {
        return repo.getNumberOfAllNotDeleted(false);
    }

    @Cacheable("albumsDisplay")
    public List<AlbumDisplay> getAllAlbumsForDisplay() {
        return repo.findAllNotDeleted(false)
                .stream()
                .map(this::toAlbumDisplay)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "albumsDisplayForAdmin", key = "#page")
    public List<AlbumDisplayForAdmin> getAllAlbumsDisplayForAdmin(int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.findAllNotDeletedPaging(false, pageable)
                .stream()
                .map(this::toAlbumDisplayForAdmin)
                .collect(Collectors.toList());
    }

    public List<AlbumDisplayForAdmin> getSearchAlbumsDisplayForAdmin(String searchTxt, int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.searchNotDeletedPaging(searchTxt, false, pageable)
                .stream()
                .map(this::toAlbumDisplayForAdmin)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "albumsByArtist", key = "#artistId")
    public List<AlbumDisplay> getAllAlbumsByArtistIdForDisplay(int artistId) {
        return repo.findAllByArtistId(artistId, false)
                .stream()
                .filter(Albums::getIsReleased)
                .map(this::toAlbumDisplay)
                .collect(Collectors.toList());
    }

    public List<AlbumDisplayForAdmin> getAllAlbumsByArtistIdForAdmin(int artistId, int page) {
        Pageable pageable = PageRequest.of(page, 5);
        return repo.findAllByArtistIdPaging(artistId, false, pageable)
                .stream()
                .map(this::toAlbumDisplayForAdmin)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "albumsByCate", key = "#cateId")
    public List<AlbumDisplay> getAllAlbumsBySubjectIdForDisplay(int cateId) {
        return categoryAlbumRepo.findAllByCategoryId(cateId, false)
                .stream()
                .filter(categoryAlbum -> categoryAlbum.getAlbumId().getIsReleased())
                .map(this::toAlbumDisplay)
                .collect(Collectors.toList());
    }

    public List<AlbumDisplayForAdmin> getAllAlbumsBySubjectIdForAdmin(int cateId, int page) {
        Pageable pageable = PageRequest.of(page, 5);
        return categoryAlbumRepo.findAllByCategoryIdPaging(cateId, false, pageable)
                .stream()
                .map(this::toAlbumDisplayForAdmin)
                .collect(Collectors.toList());
    }


    public AlbumResponse findById(int id) {
        Optional<Albums> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any album with id: " + id);
        }
        return toAlbumResponse(op.get());
    }

    public AlbumDisplay findDisplayById(int id) {
        Optional<Albums> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any album with id: " + id);
        }
        return toAlbumDisplay(op.get());
    }

    public AlbumDisplayForAdmin findDisplayForAdminById(int id) {
        Optional<Albums> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any album with id: " + id);
        }
        return toAlbumDisplayForAdmin(op.get());
    }

    @Cacheable(value = "favAlbumsByUser", key = "#id")
    public List<AlbumDisplay> getAllFavAlbumsByUserId(Integer id) {
        return favRepo.findFAByUserId(id, false)
                .stream()
                .filter(favouriteAlbums -> favouriteAlbums.getAlbumId().getIsReleased())
                .map(this::toAlbumDisplay)
                .collect(Collectors.toList());
    }

    public List<AlbumDisplayForAdmin> getAllFavAlbumsByUserIdForAdmin(Integer id, int page) {
        Pageable pageable = PageRequest.of(page, 5);
        return favRepo.findFAByUserIdPaging(id, false, pageable)
                .stream()
                .map(this::toAlbumDisplayForAdmin)
                .collect(Collectors.toList());
    }

    public List<AlbumDisplay> search(String text) {
        return repo.findAll(AlbumSearchSpecifications.search(text))
                .stream()
                .filter(Albums::getIsReleased)
                .map(this::toAlbumDisplay)
                .collect(Collectors.toList());
    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesWithAlbumDisplay", "artistsDisplayForAdmin", "albumsDisplayForAdmin", "albumsByCate", "favAlbumsByUser", "albumsByArtist", "albumsDisplay"}, allEntries = true)
    public boolean deleteById(int id) {
        Optional<Albums> album = repo.findById(id);
        if (album.isEmpty()) {
            throw new NotFoundException("Can't find any album with id: " + id);
        }
        Albums existing = album.get();
        existing.setIsDeleted(true);
        repo.save(existing);
        return true;
    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesWithAlbumDisplay", "artistsDisplayForAdmin", "albumsDisplayForAdmin", "albumsByCate", "favAlbumsByUser", "albumsByArtist", "albumsDisplay"}, allEntries = true)
    public NewOrUpdateAlbum addNewAlbum(NewOrUpdateAlbum request) {
        try {
            List<Map<String, String>> errors = new ArrayList<>();

            Optional<Albums> op = repo.findByTitle(request.getTitle());
            if (op.isPresent()) {
                errors.add(Map.of("titleError", "Already exist title"));
            }

            Optional<Artists> artist = artistRepo.findByIdAndIsDeleted(request.getArtistId(), false);
            if (artist.isEmpty()) {
                errors.add(Map.of("artistError", "Can't find artist"));
            }
            if (!errors.isEmpty()) {
                throw new ValidationException(errors);
            }
            Albums newAlbum = new Albums(request.getTitle(), request.getImage(), false, request.getReleaseDate(),
                    false, new Date(), new Date(), artist.get());

            repo.save(newAlbum);

            request.getCateIds()
                    .stream()
                    .map(it -> new NewOrUpdateCategoryAlbum(null, newAlbum.getId(), it))
                    .forEach(newOrUpdateCategoryAlbum -> categoryAlbumService.addNewCategoryAlbum(newOrUpdateCategoryAlbum));

            return request;
        } catch (RuntimeException e) {
            // Xóa file nếu insert database thất bại
            fileService.deleteImageFile(request.getImage());
            throw e;
        }


    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesWithAlbumDisplay", "artistsDisplayForAdmin", "albumsDisplayForAdmin", "albumsByCate", "favAlbumsByUser", "albumsByArtist", "albumsDisplay"}, allEntries = true)
    public void updateAlbumImage(UpdateFileModel request) {
        Optional<Albums> op = repo.findByIdAndIsDeleted(request.getId(), false);
        //check sự tồn tại
        if (op.isEmpty()) {
            fileService.deleteImageFile(request.getFileName());
            throw new NotFoundException("Can't find any album with id: " + request.getId());
        }
        Albums album = op.get();
        fileService.deleteImageFile(album.getImage());
        album.setImage(request.getFileName());

        album.setModifiedAt(new Date());
        repo.save(album);
    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesWithAlbumDisplay", "artistsDisplayForAdmin", "albumsDisplayForAdmin", "albumsByCate", "favAlbumsByUser", "albumsByArtist", "albumsDisplay"}, allEntries = true)
    public NewOrUpdateAlbum updateAlbum(NewOrUpdateAlbum request) {
        List<Map<String, String>> errors = new ArrayList<>();

        Optional<Albums> op = repo.findByIdAndIsDeleted(request.getId(), false);
        //check sự tồn tại
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any album with id: " + request.getId());
        }

        Optional<Albums> opTitle = repo.findByTitle(request.getTitle());
        if (opTitle.isPresent() && opTitle.get().getTitle() != op.get().getTitle()) {
            errors.add(Map.of("titleError", "Already exist title"));
        }

        Optional<Artists> artist = artistRepo.findByIdAndIsDeleted(request.getArtistId(), false);
        if (artist.isEmpty()) {
            errors.add(Map.of("artistError", "Can't find artist"));
        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
        Albums album = op.get();
        album.setTitle(request.getTitle());
        if (!StringUtils.isEmpty(request.getImage())) {
            //check xem có ảnh ko, có thì thay mới, ko thì thôi
            fileService.deleteImageFile(album.getImage());
            album.setImage(request.getImage());
        }
        album.setReleaseDate(request.getReleaseDate());
        album.setArtistId(artist.get());
        album.setModifiedAt(new Date());
        categoryAlbumService.updateCategoriesForAlbum(request.getId(), request.getCateIds());
        repo.save(album);

        return request;

    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesWithAlbumDisplay", "artistsDisplayForAdmin", "albumsDisplayForAdmin", "albumsByCate", "favAlbumsByUser", "albumsByArtist", "albumsDisplay"}, allEntries = true)
    public void like(LikeBaseModel likeModel) {
        Optional<Albums> op = repo.findByIdAndIsDeleted(likeModel.getItemId(), false);
        //check sự tồn tại
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any album with id: " + likeModel.getItemId());
        }
        favouriteAlbumService.addNewFA(new NewOrUpdateFavouriteAlbum(null, likeModel.getItemId(), likeModel.getUserId()));
    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesWithAlbumDisplay", "artistsDisplayForAdmin", "albumsDisplayForAdmin", "albumsByCate", "favAlbumsByUser", "albumsByArtist", "albumsDisplay"}, allEntries = true)
    public void unlikeAlbum(LikeBaseModel request) {
        Optional<FavouriteAlbums> op = favRepo.findByUserIdAndAlbumId(request.getUserId(), request.getItemId());
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any FavouriteAlbum");
        }
        favRepo.delete(op.get());
    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesWithAlbumDisplay", "artistsDisplayForAdmin", "albumsDisplayForAdmin", "albumsByCate", "favAlbumsByUser", "albumsByArtist", "albumsDisplay"}, allEntries = true)
    public void toggleAlbumReleaseStatus(int albumId) {
        Optional<Albums> op = repo.findByIdAndIsDeleted(albumId, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any album with id: " + albumId);
        }
        Albums album = op.get();
        album.setIsReleased(!album.getIsReleased());
        album.setModifiedAt(new Date());
        repo.save(album);

    }

    public AlbumResponse toAlbumResponse(Albums album) {
        AlbumResponse res = new AlbumResponse();
        BeanUtils.copyProperties(album, res);
        res.setIsDeleted(album.getIsDeleted());
        res.setIsReleased(album.getIsReleased());
        res.setArtistId(album.getArtistId().getId());
        res.setCategoryIds(categoryAlbumRepo.findAllByAlbumId(album.getId(), false)
                .stream()
                .map(CategoryAlbum::getId)
                .toList());
        return res;
    }

    public AlbumDisplay toAlbumDisplay(Albums album) {
        AlbumDisplay res = new AlbumDisplay();
        BeanUtils.copyProperties(album, res);
        res.setIsDeleted(album.getIsDeleted());
        res.setIsReleased(album.getIsReleased());
        res.setArtistName(album.getArtistId().getArtistName());
        res.setArtistImage(album.getArtistId().getImage());
        return res;
    }

    public AlbumDisplayForAdmin toAlbumDisplayForAdmin(Albums album) {
        AlbumDisplayForAdmin res = new AlbumDisplayForAdmin();
        BeanUtils.copyProperties(album, res);
        res.setIsDeleted(album.getIsDeleted());
        res.setIsReleased(album.getIsReleased());
        res.setArtistName(album.getArtistId().getArtistName());
        res.setArtistImage(album.getArtistId().getImage());
        res.setTotalSong(album.getSongsCollection().size());
        res.setTotalFavourite(favRepo.findFAByAlbumId(album.getId(), false).size());
        return res;
    }

    public AlbumDisplay toAlbumDisplay(CategoryAlbum categoryAlbum) {
        int albumId = categoryAlbum.getAlbumId().getId();
        Albums album = repo.findByIdAndIsDeleted(albumId, false).get();

        AlbumDisplay res = new AlbumDisplay();
        res.setTitle(album.getTitle());
        res.setImage(album.getImage());
        res.setReleaseDate(album.getReleaseDate());
        res.setIsDeleted(album.getIsDeleted());
        res.setIsReleased(album.getIsReleased());
        res.setArtistName(album.getArtistId().getArtistName());
        res.setArtistImage(album.getArtistId().getImage());
        res.setId(albumId);
        res.setCreatedAt(album.getCreatedAt());
        res.setModifiedAt(album.getModifiedAt());
        return res;
    }

    public AlbumDisplayForAdmin toAlbumDisplayForAdmin(CategoryAlbum categoryAlbum) {
        int albumId = categoryAlbum.getAlbumId().getId();
        Albums album = repo.findByIdAndIsDeleted(albumId, false).get();

        AlbumDisplayForAdmin res = new AlbumDisplayForAdmin();
        res.setTitle(album.getTitle());
        res.setImage(album.getImage());
        res.setReleaseDate(album.getReleaseDate());
        res.setIsDeleted(album.getIsDeleted());
        res.setIsReleased(album.getIsReleased());
        res.setArtistName(album.getArtistId().getArtistName());
        res.setArtistImage(album.getArtistId().getImage());
        res.setId(albumId);
        res.setCreatedAt(album.getCreatedAt());
        res.setModifiedAt(album.getModifiedAt());
        return res;
    }

    public AlbumDisplay toAlbumDisplay(FavouriteAlbums favAlbum) {
        int albumId = favAlbum.getAlbumId().getId();
        Albums album = repo.findByIdAndIsDeleted(albumId, false).get();

        AlbumDisplay res = new AlbumDisplay();
        res.setTitle(album.getTitle());
        res.setImage(album.getImage());
        res.setReleaseDate(album.getReleaseDate());
        res.setIsDeleted(album.getIsDeleted());
        res.setIsReleased(album.getIsReleased());
        res.setArtistName(album.getArtistId().getArtistName());
        res.setArtistImage(album.getArtistId().getImage());
        res.setId(albumId);
        res.setCreatedAt(album.getCreatedAt());
        res.setModifiedAt(album.getModifiedAt());
        return res;
    }

    public AlbumDisplayForAdmin toAlbumDisplayForAdmin(FavouriteAlbums favAlbum) {
        int albumId = favAlbum.getAlbumId().getId();
        Albums album = repo.findByIdAndIsDeleted(albumId, false).get();

        AlbumDisplayForAdmin res = new AlbumDisplayForAdmin();
        res.setTitle(album.getTitle());
        res.setImage(album.getImage());
        res.setReleaseDate(album.getReleaseDate());
        res.setIsDeleted(album.getIsDeleted());
        res.setIsReleased(album.getIsReleased());
        res.setArtistName(album.getArtistId().getArtistName());
        res.setArtistImage(album.getArtistId().getImage());
        res.setId(albumId);
        res.setCreatedAt(album.getCreatedAt());
        res.setModifiedAt(album.getModifiedAt());
        return res;
    }
}
