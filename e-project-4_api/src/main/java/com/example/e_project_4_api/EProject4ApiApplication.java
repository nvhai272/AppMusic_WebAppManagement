package com.example.e_project_4_api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class EProject4ApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(EProject4ApiApplication.class, args);
	}

}
