package com.hamsterpos.backend.auth.controller;

import com.hamsterpos.backend.auth.dto.RegisterRequestDto;
import com.hamsterpos.backend.auth.dto.LoginRequestDto;
import com.hamsterpos.backend.auth.dto.UserResponseDto;
import com.hamsterpos.backend.auth.dto.AuthResponseDto;
import com.hamsterpos.backend.auth.service.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<UserResponseDto> register(@RequestBody RegisterRequestDto request) {
        UserResponseDto response = authService.register(request);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponseDto> login(@RequestBody LoginRequestDto request) {
        AuthResponseDto response = authService.login(request);
        return ResponseEntity.ok(response);
    }
}