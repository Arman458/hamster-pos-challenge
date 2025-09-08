package com.hamsterpos.backend.user.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Data
@Entity
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String role;

    // --- UserDetails Methods ---
    // These methods provide essential user information to Spring Security.

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // This returns a list of permissions (roles) the user has.
        // For our app, we just have one role stored in the 'role' field.
        return List.of(new SimpleGrantedAuthority(role));
    }

    @Override
    public String getUsername() {
        // Spring Security's "username" is our user's "email".
        return email;
    }

    // The methods below are for account status. For this challenge, we can
    // just hardcode them to return 'true' as we don't need complex account locking logic.

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}