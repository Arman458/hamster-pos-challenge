package com.hamsterpos.backend.auth.service;

import com.hamsterpos.backend.auth.dto.AuthResponseDto;
import com.hamsterpos.backend.auth.dto.LoginRequestDto;
import com.hamsterpos.backend.auth.dto.RegisterRequestDto;
import com.hamsterpos.backend.auth.dto.UserResponseDto;
import com.hamsterpos.backend.exception.DuplicateResourceException;
import com.hamsterpos.backend.user.entity.User;
import com.hamsterpos.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public UserResponseDto register(RegisterRequestDto request) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new DuplicateResourceException("Email is already in use: " + request.getEmail());
        }

        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole("ROLE_USER");

        User savedUser = userRepository.save(user);

        return new UserResponseDto(savedUser.getId(), savedUser.getEmail());
    }

    public AuthResponseDto login(LoginRequestDto request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        var user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new IllegalStateException("User not found after successful authentication. This should not happen."));

        String jwtToken = jwtService.generateToken(user);

        AuthResponseDto response = new AuthResponseDto();
        response.setToken(jwtToken);
        return response;
    }
}