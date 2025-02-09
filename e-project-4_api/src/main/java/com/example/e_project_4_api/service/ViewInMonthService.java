package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.NewOrUpdateViewInMonth;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.models.ViewInMonth;
import com.example.e_project_4_api.models.MonthOfYear;
import com.example.e_project_4_api.models.Songs;
import com.example.e_project_4_api.repositories.ViewInMonthRepository;
import com.example.e_project_4_api.repositories.MonthRepository;
import com.example.e_project_4_api.repositories.SongRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;

@Service
public class ViewInMonthService {

    @Autowired
    private ViewInMonthRepository repo;
    @Autowired
    private MonthRepository mRepo;
    @Autowired
    private SongRepository sRepo;

    public int totalListenAmountInMonth(int monthId) {
        return repo.findTotalListenAmount(monthId).orElse(0);
    }


    public void increaseListenAmountOrCreateNew(NewOrUpdateViewInMonth request) {
        LocalDate cuDate = LocalDate.now();

        Optional<ViewInMonth> existing = repo.findBySongIdAndMonthId(cuDate.getMonthValue(), request.getSongId());
        if (existing.isPresent()) {
            ViewInMonth existed = existing.get();
            existed.setListenAmount(existed.getListenAmount() + 1);
            repo.save(existed);
            return;
        }
        ViewInMonth newObj = new ViewInMonth();
        Songs song = sRepo.findByIdAndIsDeleted(request.getSongId(), false)
                .orElseThrow(() -> new NotFoundException("Song not found with id: " + request.getSongId()));
        MonthOfYear month = mRepo.findById(cuDate.getMonthValue())
                .orElseThrow(() -> new NotFoundException("Month not found"));
        newObj.setMonthId(month);
        newObj.setSongId(song);
        newObj.setListenAmount(1);
        repo.save(newObj);
    }

}
