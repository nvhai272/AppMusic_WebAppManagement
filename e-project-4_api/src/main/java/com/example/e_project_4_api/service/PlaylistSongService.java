package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.NewOrUpdatePlaylistSong;
import com.example.e_project_4_api.dto.response.common_response.PlaylistSongResponse;
import com.example.e_project_4_api.ex.AlreadyExistedException;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.models.PlaylistSong;
import com.example.e_project_4_api.models.Playlists;
import com.example.e_project_4_api.models.Songs;
import com.example.e_project_4_api.repositories.PlaylistRepository;
import com.example.e_project_4_api.repositories.PlaylistSongRepository;
import com.example.e_project_4_api.repositories.SongRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PlaylistSongService {
    @Autowired
    PlaylistSongRepository repo;

    @Autowired
    SongRepository songRepo;
    @Autowired
    PlaylistRepository playlistRepo;

    public List<PlaylistSongResponse> getAllPlaylistSong() {
        return repo.findAll()
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public PlaylistSongResponse findById(int id) {
        Optional<PlaylistSong> op = repo.findById(id);
        if (op.isPresent()) {
            PlaylistSong PlaylistSong = op.get();
            return toResponse(PlaylistSong);
        } else {
            throw new NotFoundException("Can't find any PlaylistSong with id: " + id);
        }
    }

    public void deleteById(int id) {
        if (!repo.existsById(id)) {
            throw new NotFoundException("Can't find any PlaylistSong with id: " + id);
        }
        repo.deleteById(id);
    }

    @CacheEvict(value = {
            "songsByPlaylist","playlistsByUser"}, allEntries = true)
    public NewOrUpdatePlaylistSong addNewPS(NewOrUpdatePlaylistSong request) {
        Optional<PlaylistSong> existingPlaylistSong = repo.findByPlaylistIdAndSongId(request.getPlaylistId(), request.getSongId());
        if (existingPlaylistSong.isPresent()) {
            throw new AlreadyExistedException("A PlaylistSong already exists");
        }
        // Tìm thực thể Playlist và Song từ repo
        Playlists playlist = playlistRepo.findByIdAndIsDeleted(request.getPlaylistId(), false)
                .orElseThrow(() -> new NotFoundException("Playlist not found with id: " + request.getPlaylistId()));
        Songs song = songRepo.findByIdAndIsDeleted(request.getSongId(), false)
                .orElseThrow(() -> new NotFoundException("Song not found with id: " + request.getSongId()));
        PlaylistSong newPS = new PlaylistSong(playlist, song);
        repo.save(newPS);
        return request;
    }

    public NewOrUpdatePlaylistSong deleteByPlaylistIdAndSongId(NewOrUpdatePlaylistSong request) {
        Optional<PlaylistSong> existingPlaylistSong = repo.findByPlaylistIdAndSongId(request.getPlaylistId(), request.getSongId());
        if (existingPlaylistSong.isEmpty()) {
            throw new AlreadyExistedException("A PlaylistSong not existed");
        }
        Playlists playlist = playlistRepo.findByIdAndIsDeleted(request.getPlaylistId(), false)
                .orElseThrow(() -> new NotFoundException("Playlist not found with id: " + request.getPlaylistId()));
        Songs song = songRepo.findByIdAndIsDeleted(request.getSongId(), false)
                .orElseThrow(() -> new NotFoundException("Song not found with id: " + request.getSongId()));
        repo.delete(existingPlaylistSong.get());
        return request;
    }

    public NewOrUpdatePlaylistSong updatePS(NewOrUpdatePlaylistSong request) {
        Optional<PlaylistSong> op = repo.findById(request.getId());
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any PlaylistSong with id: " + request.getId());
        }
        Playlists playlist = playlistRepo.findByIdAndIsDeleted(request.getPlaylistId(), false)
                .orElseThrow(() -> new NotFoundException("Playlist not found with id: " + request.getPlaylistId()));
        Songs song = songRepo.findByIdAndIsDeleted(request.getSongId(), false)
                .orElseThrow(() -> new NotFoundException("Song not found with id: " + request.getSongId()));
        PlaylistSong ps = op.get();
        ps.setPlaylistId(playlist);
        ps.setSongId(song);

        repo.save(ps);
        return request;
    }

    private PlaylistSongResponse toResponse(PlaylistSong ps) {
        PlaylistSongResponse res = new PlaylistSongResponse();
        res.setPlaylistId(ps.getPlaylistId().getId());
        res.setSongId(ps.getSongId().getId());
        BeanUtils.copyProperties(ps, res);
        return res;
    }
}