package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.NewOrUpdateUser;
import com.example.e_project_4_api.dto.request.UpdateFileModel;
import com.example.e_project_4_api.dto.request.UpdatePasswordModel;
import com.example.e_project_4_api.dto.request.UpdateUserWithAttribute;
import com.example.e_project_4_api.dto.response.common_response.UserResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.UserDisplayForAdmin;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.Users;
import com.example.e_project_4_api.repositories.ArtistRepository;
import com.example.e_project_4_api.repositories.UserRepository;
import com.example.e_project_4_api.utilities.EmailValidator;
import com.example.e_project_4_api.utilities.PasswordValidator;
import com.example.e_project_4_api.utilities.PhoneNumberValidator;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class UserService {
    @Autowired
    private UserRepository repo;

    @Autowired
    private ArtistRepository artistRepo;
    @Autowired
    private FileService fileService;
    @Autowired
    AuthenticationManager authManager;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);

    @Caching(evict = {
            @CacheEvict(value = "users", allEntries = true), // Xóa toàn bộ danh sách
            @CacheEvict(value = "usersForAdmin", allEntries = true), // Xóa toàn bộ danh sách

    })
    public UserResponse updateUser(NewOrUpdateUser request) {
        List<Map<String, String>> errors = new ArrayList<>();
        Optional<Users> op = repo.findByIdAndIsDeleted(request.getId(), false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any user with id: " + request.getId());
        }

        // nếu ko null thì mới check unique title(do là album nên cần check trùng title)
        Optional<Users> opTitle = repo.findByUsername(request.getUsername());
        if (opTitle.isPresent() && opTitle.get().getUsername() != op.get().getUsername()) {
            errors.add(Map.of("usernameError", "Already exist username"));
        }

        if (!request.getPassword().isEmpty()) {
            if (!PasswordValidator.isValidPassword(request.getPassword())) {
                errors.add(Map.of("passwordError",
                        "Password is not strong enough, at least 8 characters with special character and number"));
            }
        }

        if (!PhoneNumberValidator.isValidPhoneNumber(request.getPhone())) {
            errors.add(Map.of("phoneError", "Phone number is not valid"));
        }

        Optional<Users> opPhone = repo.findByPhone(request.getPhone());
        if (opPhone.isPresent() && opPhone.get().getPhone() != op.get().getPhone()) {
            errors.add(Map.of("phoneError", "Already exist phone number"));
        }

        if (!EmailValidator.isValidEmail(request.getEmail())) {
            errors.add(Map.of("emailError", "Email is not valid"));
        }
        Optional<Users> opEmail = repo.findByEmail(request.getEmail());
        if (opEmail.isPresent() && opEmail.get().getEmail() != op.get().getEmail()) {
            errors.add(Map.of("emailError", "Already exist email"));
        }


        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
        Users user = op.get();
        if (!StringUtils.isEmpty(request.getAvatar())) {
            //check xem có ảnh ko, có thì thay mới, ko thì thôi
            fileService.deleteImageFile(user.getAvatar());
            user.setAvatar(request.getAvatar());
        }
        user.setUsername(request.getUsername());
        if (!request.getPassword().isEmpty()) {
            user.setPassword(encoder.encode(request.getPassword()));
        } else {
            user.setPassword(op.get().getPassword());
        }

        user.setFullName(request.getFullName());
        user.setPhone(request.getPhone());
        user.setEmail(request.getEmail());
        user.setDob(request.getDob());
        user.setModifiedAt(new Date());
        repo.save(user);
        return toUserResponse(user);
    }

    @Caching(evict = {
            @CacheEvict(value = "users", allEntries = true), // Xóa toàn bộ danh sách
            @CacheEvict(value = "usersForAdmin", allEntries = true), // Xóa toàn bộ danh sách
    })
    public void updateEachPartOfUser(UpdateUserWithAttribute request) {
        Optional<Users> op = repo.findByIdAndIsDeleted(request.getId(), false);
        List<Map<String, String>> errors = new ArrayList<>();

        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any user with id: " + request.getId());
        }
        Users user = op.get();
        String attr = request.getAttribute();
        switch (attr) {
            case "username":
                // nếu ko null thì mới check unique title(do là album nên cần check trùng title)
                Optional<Users> opTitle = repo.findByUsername(request.getValue());
                if (opTitle.isPresent() && opTitle.get().getUsername() != op.get().getUsername()) {
                    errors.add(Map.of("usernameError", "Already exist username"));
                }
                user.setUsername(request.getValue());
                break;
            case "fullName":
                user.setFullName(request.getValue());
                break;
            case "avatar":
                fileService.deleteImageFile(user.getAvatar());
                user.setAvatar(request.getValue());
                break;
            case "phone":
                if (!PhoneNumberValidator.isValidPhoneNumber(request.getValue())) {
                    errors.add(Map.of("phoneError", "Phone number is not valid"));
                }
                Optional<Users> opPhone = repo.findByPhone(request.getValue());
                if (opPhone.isPresent() && opPhone.get().getPhone() != op.get().getPhone()) {
                    errors.add(Map.of("phoneError", "Already exist phone number"));
                }
                user.setPhone(request.getValue());
                break;
            case "email":
                if (!EmailValidator.isValidEmail(request.getValue())) {
                    errors.add(Map.of("emailError", "Email is not valid"));
                }
                Optional<Users> opEmail = repo.findByEmail(request.getValue());
                if (opEmail.isPresent() && opEmail.get().getEmail() != op.get().getEmail()) {
                    errors.add(Map.of("emailError", "Already exist email"));
                }
                user.setEmail(request.getValue());
                break;
            case "dob":
                String dateString = request.getValue(); // Chuỗi định dạng "yyyy-MM-dd"

                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    // Chuyển chuỗi thành LocalDate
                    LocalDate localDate = LocalDate.parse(dateString, formatter);
                    // Chuyển LocalDate thành Date
                    Date date = Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());

                    user.setDob(date);
                } catch (DateTimeParseException e) {
                    // Log lỗi và đưa ra thông báo chi tiết
                    errors.add(Map.of("dateParseError", "Date must be in the format yyyy-MM-dd"));
                }
                break;
            default:
                throw new NotFoundException("Can't find this attribute");

        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
        user.setModifiedAt(new Date());
        repo.save(user);
    }

    @Caching(evict = {
            @CacheEvict(value = "users", allEntries = true), // Xóa toàn bộ danh sách
            @CacheEvict(value = "usersForAdmin", allEntries = true), // Xóa toàn bộ danh sách
    })
    public void updateUserAvatar(UpdateFileModel request) {
        Optional<Users> op = repo.findByIdAndIsDeleted(request.getId(), false);
        //check sự tồn tại
        if (op.isEmpty()) {
            fileService.deleteImageFile(request.getFileName());
            throw new NotFoundException("Can't find any user with id: " + request.getId());
        }
        Users user = op.get();
        fileService.deleteAudioFile(user.getAvatar());
        user.setAvatar(request.getFileName());

        user.setModifiedAt(new Date());
        repo.save(user);

    }

    public void updatePassword(UpdatePasswordModel request) {
        List<Map<String, String>> errors = new ArrayList<>();
        Optional<Users> op = repo.findByIdAndIsDeleted(request.getId(), false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any user with id: " + request.getId());
        }
        Users user = op.get();
        Authentication authentication = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(user.getUsername(), request.getOldPassword())
        );

        if (!authentication.isAuthenticated()) {
            errors.add(Map.of("passwordError",
                    "Your old password is wrong"));
        }
        if (!PasswordValidator.isValidPassword(request.getNewPassword())) {
            errors.add(Map.of("passwordError",
                    "Password is not strong enough, at least 8 character with special character and number"));
        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
        user.setPassword(encoder.encode(request.getNewPassword()));
        user.setModifiedAt(new Date());
        repo.save(user);
    }

    @Cacheable(value = "users")
    public List<UserResponse> getAllUsers() {
        return repo.findAllByIsDeleted(false)
                .stream()
                .map(this::toUserResponse)
                .collect(Collectors.toList());
    }

    public int getNumberOfUser() {
        return repo.getNumberOfAllNotDeleted(false);
    }

    @Cacheable(value = "usersForAdmin", key = "#page")
    public List<UserDisplayForAdmin> getAllUsersDisplayForAdmin(int page) {
        Pageable pageable = PageRequest.of(page, 10);

        return repo.findAllNotDeletedPaging(false, pageable)
                .stream()
                .map(this::toUserDisplayForAdmin)
                .collect(Collectors.toList());
    }

    public List<UserDisplayForAdmin> getSearchUsersDisplayForAdmin(String searchTxt, int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.searchNotDeletedPaging(searchTxt, false, pageable)
                .stream()
                .map(this::toUserDisplayForAdmin)
                .collect(Collectors.toList());
    }


    public UserResponse findById(int id) {
        Optional<Users> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any user with id: " + id);
        }
        return toUserResponse(op.get());
    }

    public UserDisplayForAdmin findUserDisplayForAdminById(int id) {
        Optional<Users> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any user with id: " + id);
        }
        return toUserDisplayForAdmin(op.get());
    }

    @Caching(evict = {
            @CacheEvict(value = "users", allEntries = true), // Xóa toàn bộ danh sách
            @CacheEvict(value = "usersForAdmin", allEntries = true), // Xóa toàn bộ danh sách
    })
    public boolean deleteById(int id) {
        Optional<Users> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any user with id: " + id);
        }
        Users existing = op.get();
        existing.setIsDeleted(true);
        repo.save(existing);
        return true;
    }

    public UserResponse toUserResponse(Users user) {
        UserResponse res = new UserResponse();
        BeanUtils.copyProperties(user, res);
        res.setIsDeleted(user.getIsDeleted());
        return res;
    }

    public UserDisplayForAdmin toUserDisplayForAdmin(Users user) {
        UserDisplayForAdmin res = new UserDisplayForAdmin();
        BeanUtils.copyProperties(user, res);
        res.setIsDeleted(user.getIsDeleted());
        return res;
    }

}
