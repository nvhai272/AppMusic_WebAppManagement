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
public class UpdatePasswordModel {
    @NotNull(message = "userId is required")
    private Integer id;
    @NotBlank(message = "newPassword is required")
    private String newPassword;
    @NotBlank(message = "oldPassword is required")
    private String oldPassword;
}
