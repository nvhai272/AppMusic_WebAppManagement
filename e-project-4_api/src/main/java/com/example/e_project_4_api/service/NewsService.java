package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.NewOrUpdateGenres;
import com.example.e_project_4_api.dto.request.NewOrUpdateNews;
import com.example.e_project_4_api.dto.request.UpdateFileModel;
import com.example.e_project_4_api.dto.response.common_response.GenresResponse;
import com.example.e_project_4_api.dto.response.common_response.NewsResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.KeywordDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.NewsDisplayForAdmin;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.Genres;
import com.example.e_project_4_api.models.Keywords;
import com.example.e_project_4_api.models.News;
import com.example.e_project_4_api.repositories.GenresRepository;
import com.example.e_project_4_api.repositories.NewsRepository;
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
public class NewsService {
    @Autowired
    private NewsRepository repo;
    @Autowired
    private FileService fileService;

    @Cacheable("newsDisplay")
    public List<NewsResponse> getAllNews() {
        return repo.findAll()
                .stream()
                .filter(News::getIsActive)
                .map(this::toNewsResponse)
                .collect(Collectors.toList());
    }

    public int getNumberOfNews() {
        return repo.getNumberOfAll();
    }

    @Cacheable(value = "newsDisplayForAdmin", key = "#page")
    public List<NewsDisplayForAdmin> getAllNewsForAdmin(int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.findAllPaging(pageable)
                .stream()
                .map(this::toNewsDisplayForAdmin)
                .collect(Collectors.toList());
    }
    public List<NewsDisplayForAdmin> getSearchNewsDisplayForAdmin(String searchTxt, int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.searchNotDeletedPaging(searchTxt, pageable)
                .stream()
                .map(this::toNewsDisplayForAdmin)
                .collect(Collectors.toList());
    }

    public NewsResponse findById(int id) {
        Optional<News> op = repo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any news with id: " + id);
        }
        return toNewsResponse(op.get());
    }

    public NewsDisplayForAdmin findDisplayForAdminById(int id) {
        Optional<News> op = repo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any news with id: " + id);
        }
        return toNewsDisplayForAdmin(op.get());
    }

    @CacheEvict(value = {"newsDisplay", "newsDisplayForAdmin"}, allEntries = true)
    public boolean deleteById(int id) {
        Optional<News> news = repo.findById(id);
        if (news.isEmpty()) {
            throw new NotFoundException("Can't find any genre with id: " + id);
        }
        News existing = news.get();
        repo.delete(existing);
        return true;
    }

    @CacheEvict(value = {"newsDisplay", "newsDisplayForAdmin"}, allEntries = true)
    public NewOrUpdateNews addNew(NewOrUpdateNews request) {
        try {

            List<Map<String, String>> errors = new ArrayList<>();

            Optional<News> op = repo.findByTitle(request.getTitle());
            if (op.isPresent()) {
                errors.add(Map.of("titleError", "Already exist title"));
            }

            if (!errors.isEmpty()) {
                throw new ValidationException(errors);
            }

            News newNews = new News(
                    request.getTitle(),
                    request.getImage(),
                    request.getContent(),
                    true,
                    new Date(),
                    new Date()
            );

            repo.save(newNews);

            return request;
        } catch (RuntimeException e) {
            // Xóa file nếu insert database thất bại
            fileService.deleteImageFile(request.getImage());
            throw e;
        }
    }

    @CacheEvict(value = {"newsDisplay", "newsDisplayForAdmin"}, allEntries = true)
    public void updateNewsImage(UpdateFileModel request) {
        Optional<News> op = repo.findById(request.getId());
        //check sự tồn tại
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any news with id: " + request.getId());
        }
        News news = op.get();
        fileService.deleteImageFile(news.getImage());
        news.setImage(request.getFileName());

        news.setModifiedAt(new Date());
        repo.save(news);

    }

    @CacheEvict(value = {"newsDisplay", "newsDisplayForAdmin"}, allEntries = true)
    public NewOrUpdateNews updateNews(NewOrUpdateNews request) {
        List<Map<String, String>> errors = new ArrayList<>();

        Optional<News> op = repo.findById(request.getId());
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any news with id: " + request.getId());

        }

        Optional<News> opTitle = repo.findByTitle(request.getTitle());
        if (opTitle.isPresent() && opTitle.get().getTitle() != op.get().getTitle()) {
            errors.add(Map.of("titleError", "Already exist title"));
        }

        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }


        News news = op.get();
        if (!StringUtils.isEmpty(request.getImage())) {
            //check xem có ảnh ko, có thì thay mới, ko thì thôi
            fileService.deleteImageFile(news.getImage());
            news.setImage(request.getImage());
        }
        news.setTitle(request.getTitle());
        news.setContent(request.getContent());
        news.setImage(request.getImage());
        news.setModifiedAt(new Date());
        news.setIsActive(request.getIsActive());
        repo.save(news);

        return request;
    }

    @CacheEvict(value = {"newsDisplay", "newsDisplayForAdmin"}, allEntries = true)
    public void toggleNewsActiveStatus(int id) {
        Optional<News> op = repo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any news with id: " + id);
        }
        News news = op.get();
        news.setIsActive(!news.getIsActive());
        news.setModifiedAt(new Date());
        repo.save(news);

    }

    public NewsResponse toNewsResponse(News news) {
        NewsResponse res = new NewsResponse();
        BeanUtils.copyProperties(news, res);
        return res;
    }

    public NewsDisplayForAdmin toNewsDisplayForAdmin(News news) {
        NewsDisplayForAdmin res = new NewsDisplayForAdmin();
        BeanUtils.copyProperties(news, res);
        return res;
    }
}
