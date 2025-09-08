package com.hamsterpos.backend.config;

import com.hamsterpos.backend.user.entity.User;
import com.hamsterpos.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AdminUserInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${admin.default.email}")
    private String adminEmail;

    @Value("${admin.default.password}")
    private String adminPassword;

    @Override
    public void run(String... args) throws Exception {

        if (userRepository.findByEmail(adminEmail).isEmpty()) {
            User adminUser = new User();
            adminUser.setEmail(adminEmail);
            adminUser.setPassword(passwordEncoder.encode(adminPassword));
            adminUser.setRole("ROLE_ADMIN");

            userRepository.save(adminUser);

            System.out.println("000000000000000000000000");
            System.out.println("Default admin user created from properties file.");
            System.out.println("Email: " + adminEmail);
            System.out.println("0000000000000000000");
        }
    }
}