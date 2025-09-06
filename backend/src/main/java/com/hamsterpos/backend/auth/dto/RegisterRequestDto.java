package com.hamsterpos.backend.auth.dto;

import lombok.Data;

@Data
public class RegisterRequestDto {
    private String email;
    private String password;
}
