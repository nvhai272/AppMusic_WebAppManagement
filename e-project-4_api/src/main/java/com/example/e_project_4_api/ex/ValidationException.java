package com.example.e_project_4_api.ex;

import java.util.List;
import java.util.Map;

public class ValidationException extends RuntimeException {
    private List<Map<String,String>> errors;

    public ValidationException(List<Map<String,String>> errors) {
        super("Validation errors occurred");
        this.errors = errors;
    }

    public List<Map<String,String>> getErrors() {
        return errors;
    }
}
