package com.example.e_project_4_api.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateUserWithAttribute {
    @NotNull(message = "id is required")
    private int id;
    @NotBlank(message = "attribute is required")
    private String attribute;
    @NotBlank(message = "value is required")
    private String value;
}
