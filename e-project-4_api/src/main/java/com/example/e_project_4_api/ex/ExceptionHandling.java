package com.example.e_project_4_api.ex;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@ControllerAdvice
public class ExceptionHandling {
    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<Map<String, String>> handleNotFoundException(NotFoundException ex) {
        var res = Map.of("message", ex.getMessage());

        return ResponseEntity.status(404)
                .body(res);
    }

    @ExceptionHandler(AlreadyExistedException.class)
    public ResponseEntity<Map<String, String>> handleAlreadyExistedException(AlreadyExistedException ex) {
        var res = Map.of("message", ex.getMessage());

        return ResponseEntity.badRequest()
                .body(res);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleMethodArgumentNotValidException(MethodArgumentNotValidException ex) {
        Map<String, String> errrorsssss = new HashMap<>();
        List<ObjectError> allErrors = ex.getAllErrors();
        for (ObjectError error : allErrors) {
            FieldError err = (FieldError) error;
            errrorsssss.put(err.getField(), err.getDefaultMessage());
        }
        var res = errrorsssss;

        return ResponseEntity.badRequest()
                .body(res);
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<String> handleMaxSizeException(MaxUploadSizeExceededException exc) {
        return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                .body("File size exceeds the maximum limit!");
    }
}