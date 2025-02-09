package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.NewOrUpdateKeyword;
import com.example.e_project_4_api.dto.request.NewOrUpdateNews;
import com.example.e_project_4_api.dto.response.common_response.KeywordResponse;
import com.example.e_project_4_api.dto.response.common_response.NewsResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.GenreDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.KeywordDisplayForAdmin;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.Albums;
import com.example.e_project_4_api.models.Keywords;
import com.example.e_project_4_api.models.News;
import com.example.e_project_4_api.repositories.KeywordRepository;
import com.example.e_project_4_api.repositories.NewsRepository;
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
public class KeywordService {
    @Autowired
    private KeywordRepository repo;

    @Cacheable("keywordsDisplay")
    public List<KeywordResponse> getAllKeywords() {
        return repo.findAll()
                .stream()
                .filter(Keywords::getIsActive)
                .map(this::toKeywordResponse)
                .collect(Collectors.toList());
    }

    public int getNumberOfKeywords() {
        return repo.getNumberOfAll();
    }

    @Cacheable(value = "keywordsDisplayForAdmin", key = "#page")
    public List<KeywordDisplayForAdmin> getAllKeywordsForAdmin(int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.findAllPaging(pageable)
                .stream()
                .map(this::toKeywordDisplayForAdmin)
                .collect(Collectors.toList());
    }

    public List<KeywordDisplayForAdmin> getSearchKeywordsDisplayForAdmin(String searchTxt, int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.searchNotDeletedPaging(searchTxt, pageable)
                .stream()
                .map(this::toKeywordDisplayForAdmin)
                .collect(Collectors.toList());
    }

    public KeywordResponse findById(int id) {
        Optional<Keywords> op = repo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any news with id: " + id);
        }
        return toKeywordResponse(op.get());
    }

    public KeywordDisplayForAdmin findByIdForAdmin(int id) {
        Optional<Keywords> op = repo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any news with id: " + id);
        }
        return toKeywordDisplayForAdmin(op.get());
    }

    @CacheEvict(value = {"keywordsDisplay", "keywordsDisplayForAdmin"}, allEntries = true)
    public boolean deleteById(int id) {
        Optional<Keywords> op = repo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any genre with id: " + id);
        }
        Keywords existing = op.get();
        repo.delete(existing);
        return true;
    }

    @CacheEvict(value = {"keywordsDisplay", "keywordsDisplayForAdmin"}, allEntries = true)
    public NewOrUpdateKeyword addNew(NewOrUpdateKeyword request) {
        List<Map<String, String>> errors = new ArrayList<>();

        Optional<Keywords> op = repo.findByContent(request.getContent());
        if (op.isPresent()) {
            errors.add(Map.of("contentError", "Already exist keyword"));
        }

        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }


        Keywords newKeyword = new Keywords(
                request.getContent(),
                request.getIsActive(),
                new Date(),
                new Date()
        );

        repo.save(newKeyword);

        return request;
    }

    @CacheEvict(value = {"keywordsDisplay", "keywordsDisplayForAdmin"}, allEntries = true)
    public NewOrUpdateKeyword updateKeyword(NewOrUpdateKeyword request) {
        List<Map<String, String>> errors = new ArrayList<>();


        Optional<Keywords> op = repo.findById(request.getId());
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any keywords with id: " + request.getId());
        }

        Optional<Keywords> opTitle = repo.findByContent(request.getContent());
        if (opTitle.isPresent() && opTitle.get().getContent() != op.get().getContent()) {
            errors.add(Map.of("contentError", "Already exist keyword"));
        }

        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }


        Keywords newKeyword = op.get();
        newKeyword.setContent(request.getContent());
        newKeyword.setModifiedAt(new Date());
        newKeyword.setIsActive(request.getIsActive());
        repo.save(newKeyword);

        return request;
    }

    @CacheEvict(value = {"keywordsDisplay", "keywordsDisplayForAdmin"}, allEntries = true)
    public void toggleKeywordActiveStatus(int id) {
        Optional<Keywords> op = repo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any keyword with id: " + id);
        }
        Keywords keyword = op.get();
        keyword.setIsActive(!keyword.getIsActive());
        keyword.setModifiedAt(new Date());
        repo.save(keyword);

    }

    public KeywordResponse toKeywordResponse(Keywords keyword) {
        KeywordResponse res = new KeywordResponse();
        BeanUtils.copyProperties(keyword, res);
        return res;
    }

    public KeywordDisplayForAdmin toKeywordDisplayForAdmin(Keywords keyword) {
        KeywordDisplayForAdmin res = new KeywordDisplayForAdmin();
        BeanUtils.copyProperties(keyword, res);
        return res;
    }
}
