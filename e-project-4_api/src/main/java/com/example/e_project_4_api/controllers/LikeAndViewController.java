package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.service.ViewInMonthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;


@RestController
@RequestMapping("/api")
public class LikeAndViewController {

    @Autowired
    private ViewInMonthService service;


    @GetMapping("/public/listenInMonth/{monthId}")
    public ResponseEntity<Object> totalListenAmountInMonth(@PathVariable("monthId") int id) {
        return new ResponseEntity<>(Map.of(
                "total_listen", service.totalListenAmountInMonth(id)), HttpStatus.OK);
    }
}
