package com.hamsterpos.backend.auth.dto;

import lombok.Data;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@NoArgsConstructor    // Generates a constructor with no arguments
@AllArgsConstructor
@Data
public class UserResponseDto {
    private Long id;
    private String email;
}
