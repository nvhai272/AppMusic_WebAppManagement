package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.service.FileService;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@RestController
@RequestMapping("/api/files")
public class FileController {

    @Autowired
    FileService fileService;

    @Value("${file.upload.epj4-folder}")
    private String FOLDER;

//    @Value("${file.upload.final-folder}")
//    private String FINAL_FOLDER;

    @PostMapping("/upload/image")
    public ResponseEntity<String> uploadImageFile(@RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(fileService.uploadImageFile(file));
    }

    @PostMapping("/upload/audio")
    public ResponseEntity<String> uploadAudioFile(@RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(fileService.uploadAudioFile(file));
    }

    @PostMapping("/upload/lrc")
    public ResponseEntity<String> uploadLRCFile(@RequestParam("file") MultipartFile file) {
        return ResponseEntity.ok(fileService.uploadLRCFile(file));
    }


    @GetMapping("/download/lrc/{filename}")
    public ResponseEntity<?> downloadLRCFile(@PathVariable("filename") String filename) throws IOException {
        String filePath = FOLDER + "lrc/" + filename;

        File file = new File(filePath);

        // Kiểm tra xem file có tồn tại không
        if (!file.exists()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("File not found.");
        }

        // Đọc nội dung file
        byte[] fileContent = Files.readAllBytes(file.toPath());

        // Trả về file với đúng Content-Type và tên file trong header
        return ResponseEntity.ok()
                .contentType(MediaType.TEXT_PLAIN)  // Content-Type cho file ảnh JPEG
                .body(fileContent);
    }

    @GetMapping("/download/audio/{filename}")
    public ResponseEntity<?> downloadAudioFile(@PathVariable("filename") String filename) throws IOException {
        String filePath = FOLDER + "audio/" + filename;

        File file = new File(filePath);

        // Kiểm tra xem file có tồn tại không
        if (!file.exists()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("File not found.");
        }

        // Đọc nội dung file
        byte[] fileContent = Files.readAllBytes(file.toPath());

        // Trả về file với đúng Content-Type và tên file trong header
        return ResponseEntity.ok()
                .contentType(MediaType.valueOf("audio/mpeg"))  // Content-Type cho file ảnh JPEG
                .body(fileContent);
    }

    @GetMapping("/download/image/{filename}")
    public ResponseEntity<?> downloadImageFile(@PathVariable("filename") String filename) throws IOException {
        String filePath = FOLDER + "images/" + filename;
        String extension = filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
        MediaType mediaType = switch (extension) {
            case "jpeg", "jpg" -> MediaType.IMAGE_JPEG;
            case "png" -> MediaType.IMAGE_PNG;
            case "gif" -> MediaType.IMAGE_GIF;
            case "webp" -> MediaType.parseMediaType("image/webp");
            default ->
                // Trường hợp không xác định loại file, trả về lỗi hoặc mặc định là JPEG
                    MediaType.IMAGE_JPEG;
        };
        File file = new File(filePath);

        // Kiểm tra xem file có tồn tại không
        if (!file.exists()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("File not found.");
        }

        // Đọc nội dung file
        byte[] fileContent = Files.readAllBytes(file.toPath());

        // Trả về file với đúng Content-Type và tên file trong header
        return ResponseEntity.ok()
                .contentType(mediaType)  // Content-Type cho file ảnh JPEG
                .body(fileContent);

    }
}

