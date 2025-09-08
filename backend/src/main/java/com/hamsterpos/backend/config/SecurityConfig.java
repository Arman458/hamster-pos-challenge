package com.hamsterpos.backend.config;

import com.hamsterpos.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final UserRepository userRepository;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationFilter jwtAuthFilter) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        // Public auth endpoints
                        .requestMatchers("/auth/**").permitAll()

                        // Admin-only product management
                        .requestMatchers(HttpMethod.POST, "/api/products").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/products/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/products/**").hasRole("ADMIN")

                        // Admin-only endpoints
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")

                        // Everything else requires login
                        .anyRequest().authenticated()
                )
                .exceptionHandling(ex -> ex
                        .accessDeniedHandler(customAccessDeniedHandler()) // 👈 now works
                )
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authenticationProvider(authenticationProvider(userDetailsService(), passwordEncoder()))
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public AccessDeniedHandler customAccessDeniedHandler() {
        return (request, response, ex) -> {
            response.setStatus(HttpStatus.FORBIDDEN.value());
            response.setContentType("application/json");
            response.getWriter().write(
                    "{"
                            + "\"timestamp\":\"" + java.time.LocalDateTime.now() + "\","
                            + "\"status\":403,"
                            + "\"error\":\"Forbidden\","
                            + "\"message\":\"You do not have permission to access this resource\""
                            + "}"
            );
        };
    }


    @Bean
    public UserDetailsService userDetailsService() {
        return username -> userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + username));
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationProvider authenticationProvider(UserDetailsService userDetailsService,
                                                         PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder);
        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
}
