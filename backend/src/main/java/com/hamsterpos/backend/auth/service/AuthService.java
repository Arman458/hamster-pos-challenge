package com.hamsterpos.backend.auth.service;

import com.hamsterpos.backend.auth.dto.RegisterRequestDto;
import com.hamsterpos.backend.auth.dto.LoginRequestDto;
import com.hamsterpos.backend.auth.dto.UserResponseDto;
import com.hamsterpos.backend.auth.dto.AuthResponseDto;
import com.hamsterpos.backend.user.entity.User;
import com.hamsterpos.backend.user.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public UserResponseDto register(RegisterRequestDto request) {
        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole("USER"); // default role

        User saved = userRepository.save(user);

        UserResponseDto response = new UserResponseDto();
        response.setId(saved.getId());
        response.setEmail(saved.getEmail());
        return response;
    }

    public AuthResponseDto login(LoginRequestDto request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid email or password"));

        if (passwordEncoder.matches(request.getPassword(), user.getPassword())) {

            return new AuthResponseDto("dummy-token");
        }

        throw new RuntimeException("Invalid email or password");
    }
}