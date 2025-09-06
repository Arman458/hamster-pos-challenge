package com.hamsterpos.backend.auth.dto;
import lombok.Data;

@Data
public class LoginRequestDto {
    private String email;
    private String password;
}
