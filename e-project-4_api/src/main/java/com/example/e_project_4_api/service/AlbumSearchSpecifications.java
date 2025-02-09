package com.example.e_project_4_api.service;

import com.example.e_project_4_api.models.*;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;

import org.springframework.data.jpa.domain.Specification;

public class AlbumSearchSpecifications {
    public static Specification<Albums> search(String text) {
        return (root, query, cb) -> {
            // Join bảng cha
            Join<Albums, Artists> parentJoin = root.join("artistId", JoinType.LEFT);

            // Join bảng con
            Join<Albums, Songs> subEntityJoin = root.join("songsCollection", JoinType.LEFT);

            Join<Albums, CategoryAlbum> albumCategoryJoin = root.join("categoryAlbumCollection", JoinType.LEFT);

            // Join bảng Category
            Join<CategoryAlbum, Categories> categoryJoin = albumCategoryJoin.join("categoryId", JoinType.LEFT);

            // Điều kiện tìm kiếm
            return cb.or(
                    cb.and(
                            cb.equal(root.get("isDeleted"), false),
                            cb.equal(root.get("isReleased"), true),
                            cb.like(cb.lower(root.get("title")), "%" + text.toLowerCase() + "%")
                    ),

                    cb.and(
                            cb.equal(parentJoin.get("isDeleted"), false),
                            cb.equal(root.get("isDeleted"), false),
                            cb.equal(root.get("isReleased"), true),
                            cb.like(cb.lower(parentJoin.get("artistName")), "%" + text.toLowerCase() + "%")
                    ),

                    cb.and(
                            cb.equal(root.get("isDeleted"), false),
                            cb.equal(root.get("isReleased"), true),
                            cb.equal(subEntityJoin.get("isDeleted"), false),
                            cb.like(cb.lower(subEntityJoin.get("title")), "%" + text.toLowerCase() + "%")
                    ),
                    cb.and(
                            cb.equal(root.get("isDeleted"), false),
                            cb.equal(root.get("isReleased"), true),
                            cb.equal(categoryJoin.get("isDeleted"), false),
                            cb.like(cb.lower(categoryJoin.get("title")), "%" + text.toLowerCase() + "%")
                    )
            );
        };
    }
}
