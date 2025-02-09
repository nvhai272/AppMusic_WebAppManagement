package com.example.e_project_4_api.ex;

public class AlreadyExistedException extends RuntimeException {
    public AlreadyExistedException(String msg) {
        super(msg);
    }
}
