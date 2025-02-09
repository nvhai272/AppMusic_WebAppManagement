package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.NewOrUpdateCategory;
import com.example.e_project_4_api.dto.response.common_response.CategoryResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.AlbumDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.CategoryDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_response.AlbumDisplay;
import com.example.e_project_4_api.dto.response.mix_response.CategoryWithAlbumsResponse;
import com.example.e_project_4_api.ex.AlreadyExistedException;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.Albums;
import com.example.e_project_4_api.models.Artists;
import com.example.e_project_4_api.models.Categories;
import com.example.e_project_4_api.models.CategoryAlbum;
import com.example.e_project_4_api.repositories.AlbumRepository;
import com.example.e_project_4_api.repositories.CategoryAlbumRepository;
import com.example.e_project_4_api.repositories.CategoryRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class CategoryService {
    @Autowired
    CategoryRepository cateRepository;
    @Autowired
    CategoryAlbumRepository cateAlbumRepository;

    @Cacheable("categoriesDisplay")
    public List<CategoryResponse> getAllCategories() {
        return cateRepository.findAllNotDeleted(false)
                .stream()
                .map(this::toCategoryResponse)
                .collect(Collectors.toList());
    }

    public int getNumberOfCate() {
        return cateRepository.getNumberOfAllNotDeleted(false);
    }

    @Cacheable(value = "categoriesDisplayForAdmin", key = "#page")
    public List<CategoryDisplayForAdmin> getAllCategoriesDisplayForAdmin(int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return cateRepository.findAllNotDeletedPaging(false, pageable)
                .stream()
                .map(this::toCategoryCategoryDisplayForAdmin)
                .collect(Collectors.toList());
    }

    public List<CategoryDisplayForAdmin> getSearchCategoriesDisplayForAdmin(String searchTxt, int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return cateRepository.searchNotDeletedPaging(searchTxt, false, pageable)
                .stream()
                .map(this::toCategoryCategoryDisplayForAdmin)
                .collect(Collectors.toList());
    }

    @Cacheable("categoriesWithAlbumDisplay")
    public List<CategoryWithAlbumsResponse> getAllCategoriesWithAlbums() {
        return cateRepository.findAllNotDeleted(false)
                .stream()
                .map(this::toCategoryWithAlbumsResponse)
                .collect(Collectors.toList());
    }


    public CategoryResponse findById(int id) {
        Optional<Categories> op = cateRepository.findByIdAndIsDeleted(id, false);
        if (op.isPresent()) {
            Categories subjects = op.get();
            return toCategoryResponse(subjects);
        } else {
            throw new NotFoundException("Can't find any category with id: " + id);
        }
    }

    public CategoryDisplayForAdmin findByIdForAdmin(int id) {
        Optional<Categories> op = cateRepository.findByIdAndIsDeleted(id, false);
        if (op.isPresent()) {
            Categories subjects = op.get();
            return toCategoryCategoryDisplayForAdmin(subjects);
        } else {
            throw new NotFoundException("Can't find any category with id: " + id);
        }
    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesDisplay", "categoriesWithAlbumDisplay"}, allEntries = true)
    public void deleteById(int id) {
        if (!cateRepository.existsById(id)) {
            throw new NotFoundException("Can't find any category with id: " + id);
        }
        cateRepository.deleteById(id);
    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesDisplay", "categoriesWithAlbumDisplay"}, allEntries = true)
    public NewOrUpdateCategory addNewSubject(NewOrUpdateCategory request) {
        List<Map<String, String>> errors = new ArrayList<>();

        Optional<Categories> op = cateRepository.findByTitle(request.getTitle());
        if (op.isPresent()) {
            errors.add(Map.of("titleError", "Already exist title"));
        }

        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
        Date currentDate = new Date();
        Categories newSub = new Categories(request.getTitle(), request.getDescription(), false, currentDate, currentDate);
        cateRepository.save(newSub);
        return request;
    }

    @CacheEvict(value = {"categoriesDisplayForAdmin", "categoriesDisplay", "categoriesWithAlbumDisplay"}, allEntries = true)
    public NewOrUpdateCategory updateSubject(NewOrUpdateCategory request) {
        List<Map<String, String>> errors = new ArrayList<>();

        Optional<Categories> op = cateRepository.findByIdAndIsDeleted(request.getId(), false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any category with id: " + request.getId());
        }

        Optional<Categories> opTitle = cateRepository.findByTitle(request.getTitle());
        if (opTitle.isPresent() && opTitle.get().getTitle() != op.get().getTitle()) {
            errors.add(Map.of("titleError", "Already exist title"));
        }

        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }

        Date currentDate = new Date();
        Categories sub = op.get();
        sub.setTitle(request.getTitle());
        sub.setDescription(request.getDescription());
        sub.setModifiedAt(currentDate);
        cateRepository.save(sub);
        return request;
    }

    private CategoryResponse toCategoryResponse(Categories sub) {
        CategoryResponse res = new CategoryResponse();
        res.setIsDeleted(sub.getIsDeleted());
        BeanUtils.copyProperties(sub, res);
        return res;
    }

    private CategoryDisplayForAdmin toCategoryCategoryDisplayForAdmin(Categories sub) {
        CategoryDisplayForAdmin res = new CategoryDisplayForAdmin();
        res.setIsDeleted(sub.getIsDeleted());
        res.setTotalAlbum(cateAlbumRepository.findAllByCategoryId(sub.getId(), false).size());
        BeanUtils.copyProperties(sub, res);
        return res;
    }

    private CategoryWithAlbumsResponse toCategoryWithAlbumsResponse(Categories category) {
        List<CategoryAlbum> categoryAlbum = cateAlbumRepository.findAlreadyReleasedByCategoryId(category.getId(), false, true);

        List<AlbumDisplay> albumsOfCategory = categoryAlbum.stream()
                .map(CategoryAlbum::getAlbumId)
                .filter(Albums::getIsReleased)
                .map(this::toAlbumDisplay)
                .collect(Collectors.toList());

        CategoryWithAlbumsResponse res = new CategoryWithAlbumsResponse();
        BeanUtils.copyProperties(category, res);
        res.setAlbums(albumsOfCategory);
        return res;
    }

    private AlbumDisplay toAlbumDisplay(Albums album) {
        AlbumDisplay res = new AlbumDisplay();
        BeanUtils.copyProperties(album, res);
        res.setIsDeleted(album.getIsDeleted());
        res.setIsReleased(album.getIsReleased());
        res.setArtistName(album.getArtistId().getArtistName());
        res.setArtistImage(album.getArtistId().getImage());
        return res;
    }
}