package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.*;
import com.example.e_project_4_api.dto.response.common_response.SongResponse;
import com.example.e_project_4_api.dto.response.display_for_admin.PlaylistDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_for_admin.SongDisplayForAdmin;
import com.example.e_project_4_api.dto.response.display_response.SongDisplay;
import com.example.e_project_4_api.dto.response.mix_response.SongWithViewInMonth;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.*;
import com.example.e_project_4_api.repositories.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service

public class SongService {
    @Autowired
    private SongRepository repo;
    @Autowired
    private AlbumRepository albumRepo;
    @Autowired
    private ArtistRepository artistRepo;
    @Autowired
    private FavouriteSongRepository favRepo;
    @Autowired
    private GenreSongRepository genSongRepo;
    @Autowired
    private PlaylistSongRepository playlistSongRepo;
    @Autowired
    private ViewInMonthRepository likeAndViewRepository;
    @Autowired
    private GenresRepository genRepo;
    @Autowired
    private ViewInMonthService viewInMonthService;
    @Autowired
    private FavouriteSongService favouriteSongService;
    @Autowired
    private FileService fileService;
    @Autowired
    private GenreSongService genreSongService;

    public List<SongResponse> getAllSongs() {
        return repo.findAllNotDeleted(false)
                .stream()
                .map(this::toSongResponse)
                .collect(Collectors.toList());
    }

    public int getNumberOfSong() {
        return repo.getNumberOfAllNotDeleted(false);
    }

    @Cacheable("songsDisplay")
    public List<SongDisplay> getAllSongsForDisplay() {
        return repo.findAllNotDeleted(false)
                .stream()
                .map(this::toSongDisplay)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "songsDisplayForAdmin", key = "#page")
    public List<SongDisplayForAdmin> getAllSongsForAdmin(int page) {
        Pageable pageable = PageRequest.of(page, 10);

        return repo.findAllNotDeletedPaging(false, pageable)
                .stream()
                .map(this::toSongDisplayAdmin)
                .collect(Collectors.toList());
    }

    public List<SongDisplayForAdmin> getSearchSongsDisplayForAdmin(String searchTxt, int page) {
        Pageable pageable = PageRequest.of(page, 10);
        return repo.searchNotDeletedPaging(searchTxt, false, pageable)
                .stream()
                .map(this::toSongDisplayAdmin)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "songsByArtist", key = "#artistId")
    public List<SongDisplay> getAllSongsByArtistIdForDisplay(int artistId) {
        return repo.findAllByArtistId(artistId, false, true)
                .stream()
                .map(this::toSongDisplay)
                .collect(Collectors.toList());
    }

    public List<SongDisplayForAdmin> getAllSongsByArtistIdForAdmin(int artistId, int page) {
        Pageable pageable = PageRequest.of(page, 5);
        return repo.findAllByArtistIdForAdmin(artistId, false, pageable)
                .stream()
                .map(this::toSongDisplayAdmin)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "songsByAlbum", key = "#albumId")
    public List<SongDisplay> getAllSongsByAlbumIdForDisplay(int albumId) {
        return repo.findAllByAlbumId(albumId, false, true)
                .stream()
                .map(this::toSongDisplay)
                .collect(Collectors.toList());
    }

    public List<SongDisplayForAdmin> getAllSongsByAlbumIdForAdmin(int albumId, int page) {
        Pageable pageable = PageRequest.of(page, 5);
        return repo.findAllByAlbumIdPaging(albumId, false, pageable)
                .stream()
                .map(this::toSongDisplayAdmin)
                .collect(Collectors.toList());
    }

    public SongResponse findById(int id) {
        Optional<Songs> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + id);
        }
        return toSongResponse(op.get());
    }

    public SongDisplay findDisplayById(int id) {
        Optional<Songs> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + id);
        }
        return toSongDisplay(op.get());
    }

    public SongDisplayForAdmin findDisplayForAdminById(int id) {
        Optional<Songs> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + id);
        }
        return toSongDisplayAdmin(op.get());
    }

    public SongWithViewInMonth getMostListenedSongInMonth() {
        LocalDate cuDate = LocalDate.now();
        Pageable pageable = PageRequest.of(0, 1);
        ViewInMonth mostListenedSong = likeAndViewRepository.findSongsWithMaxListenAmount(cuDate.getMonthValue(), pageable)
                .stream().findFirst().orElseThrow(() -> new NotFoundException("Can't find most listened song"));
        return toSongWithLikeAndViewAmount(mostListenedSong);
    }


    public List<SongWithViewInMonth> getMost5ListenedSongInMonth() {
        LocalDate cuDate = LocalDate.now();

        Pageable pageable = PageRequest.of(0, 5);
        List<ViewInMonth> mostListenedSongs = likeAndViewRepository.findSongsWithMaxListenAmount(cuDate.getMonthValue(), pageable);
        return mostListenedSongs.stream()
                .map(this::toSongWithLikeAndViewAmount)
                .collect(Collectors.toList());
    }

    private SongWithViewInMonth toSongWithLikeAndViewAmount(ViewInMonth mostListenedSong) {
        SongWithViewInMonth res = new SongWithViewInMonth();
        res.setSongId(mostListenedSong.getSongId().getId());
        res.setSongName(mostListenedSong.getSongId().getTitle());
        res.setArtistName(mostListenedSong.getSongId().getArtistId().getArtistName());
        res.setAlbumName(mostListenedSong.getSongId().getAlbumId().getTitle());
        res.setListenInMonth(mostListenedSong.getListenAmount());
        return res;
    }

    @Cacheable(value = "favSongs", key = "#id")
    public List<SongDisplay> getAllFavSongsByUserId(Integer id) {
        return favRepo.findFSByUserId(id, false)
                .stream()
                .filter(it -> it.getSongId().getIsPending())
                .map(this::toSongDisplay)
                .collect(Collectors.toList());
    }

    public List<SongDisplayForAdmin> getAllFavSongsByUserIdForAdmin(Integer id, int page) {
        Pageable pageable = PageRequest.of(page, 5);

        return favRepo.findFSByUserIdPaging(id, false, pageable)
                .stream()
                .map(this::toSongDisplayAdmin)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "songsByGenre", key = "#id")
    public List<SongDisplay> getAllSongsByGenreId(Integer id) {
        return genSongRepo.findByGenreId(id, false)
                .stream()
                .filter(song -> song.getSongId().getIsPending())
                .map(this::toSongDisplay)
                .collect(Collectors.toList());
    }

    public List<SongDisplayForAdmin> getAllSongsByGenreIdForAdmin(Integer id, int page) {
        Pageable pageable = PageRequest.of(page, 5);

        return genSongRepo.findByGenreIdPaging(id, false, pageable)
                .stream()
                .map(this::toSongDisplayAdmin)
                .collect(Collectors.toList());
    }

    @Cacheable(value = "songsByPlaylist", key = "#id")
    public List<SongDisplay> getAllSongsByPlaylistId(Integer id) {
        return playlistSongRepo.findByPlaylistId(id, false)
                .stream()
                .filter(it -> it.getSongId().getIsPending())
                .map(this::toSongDisplay)
                .collect(Collectors.toList());
    }

    public List<SongDisplayForAdmin> getAllSongsByPlaylistIdForAdmin(Integer id, int page) {
        Pageable pageable = PageRequest.of(page, 5);

        return playlistSongRepo.findByPlaylistIdPaging(id, false, pageable)
                .stream()
                .map(this::toSongDisplayAdmin)
                .collect(Collectors.toList());
    }

    @CacheEvict(value = {"playlistsDisplayForAdmin", "artistsDisplayForAdmin",
            "albumsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public boolean deleteById(int id) {
        Optional<Songs> op = repo.findById(id);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + id);
        }
        Songs existing = op.get();
        existing.setIsDeleted(true);
        repo.save(existing);
        return true;
    }

    @CacheEvict(value = {"playlistsDisplayForAdmin", "artistsDisplayForAdmin",
            "albumsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public NewOrUpdateSong addNewSong(NewOrUpdateSong request) {
        try {
            List<Map<String, String>> errors = new ArrayList<>();

            Optional<Songs> op = repo.findByTitle(request.getTitle());
            if (op.isPresent()) {
                errors.add(Map.of("titleError", "Already exist title"));
            }
            Optional<Artists> artist = artistRepo.findByIdAndIsDeleted(request.getArtistId(), false);
            if (artist.isEmpty()) {
                errors.add(Map.of("artistError", "Can't find artist"));
            }


            if (!errors.isEmpty()) {
                throw new ValidationException(errors);
            }
            Songs newSong = new Songs(request.getTitle(), request.getAudioPath(),
                    0, request.getFeatureArtist(), request.getLyricFilePath(), false, false,
                    new Date(), new Date(), artist.get());
            repo.save(newSong);

            request.getGenreIds()
                    .stream()
                    .map(it -> new NewOrUpdateGenreSong(null, it, newSong.getId()))
                    .forEach(newOrUpdateGenreSong -> genreSongService.addNewGenreSong(newOrUpdateGenreSong));

            return request;
        } catch (RuntimeException e) {
            // Xóa file nếu insert database thất bại
            fileService.deleteLRCFile(request.getLyricFilePath());
            fileService.deleteAudioFile(request.getAudioPath());
            throw e;
        }
    }

    @CacheEvict(value = {"artistsDisplayForAdmin",
            "albumsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public void updateSongRLC(UpdateFileModel request) {
        Optional<Songs> op = repo.findByIdAndIsDeleted(request.getId(), false);
        //check sự tồn tại
        if (op.isEmpty()) {
            fileService.deleteLRCFile(request.getFileName());
            throw new NotFoundException("Can't find any song with id: " + request.getId());
        }
        Songs song = op.get();
        fileService.deleteLRCFile(song.getLyricFilePath());
        song.setLyricFilePath(request.getFileName());

        song.setModifiedAt(new Date());
        repo.save(song);

    }

    @CacheEvict(value = {"artistsDisplayForAdmin",
            "albumsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public void updateSongAudio(UpdateFileModel request) {
        Optional<Songs> op = repo.findByIdAndIsDeleted(request.getId(), false);
        //check sự tồn tại
        if (op.isEmpty()) {
            fileService.deleteAudioFile(request.getFileName());
            throw new NotFoundException("Can't find any song with id: " + request.getId());
        }
        Songs song = op.get();
        fileService.deleteAudioFile(song.getAudioPath());
        song.setAudioPath(request.getFileName());

        song.setModifiedAt(new Date());
        repo.save(song);

    }

    @CacheEvict(value = {"artistsDisplayForAdmin",
            "albumsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public NewOrUpdateSong updateSong(NewOrUpdateSong request) {
        List<Map<String, String>> errors = new ArrayList<>();

        Optional<Songs> op = repo.findById(request.getId());
        //check sự tồn tại
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + request.getId());
        }
        Songs song = op.get();

        Optional<Songs> opTitle = repo.findByTitle(request.getTitle());
        if (opTitle.isPresent() && opTitle.get().getTitle() != op.get().getTitle()) {
            errors.add(Map.of("titleError", "Already exist title"));
        }

        Optional<Artists> artist = artistRepo.findByIdAndIsDeleted(request.getArtistId(), false);
        if (artist.isEmpty()) {
            errors.add(Map.of("artistError", "Can't find artist"));
        }

        if (request.getAlbumId() != null) {
            Optional<Albums> album = albumRepo.findByIdAndIsDeleted(request.getAlbumId(), false);
            if (album.isPresent()) {
                song.setAlbumId(album.get());
            } else {
                errors.add(Map.of("albumError", "Can't find album"));
            }
        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
        if (!StringUtils.isEmpty(request.getAudioPath())) {
            //check xem có ảnh ko, có thì thay mới, ko thì thôi
            fileService.deleteAudioFile(song.getAudioPath());
            song.setAudioPath(request.getAudioPath());
        }
        if (!StringUtils.isEmpty(request.getLyricFilePath())) {
            //check xem có ảnh ko, có thì thay mới, ko thì thôi
            fileService.deleteLRCFile(song.getLyricFilePath());
            song.setLyricFilePath(request.getLyricFilePath());
        }
        song.setTitle(request.getTitle());
        song.setListenAmount(request.getListenAmount());
        song.setFeatureArtist(request.getFeatureArtist());
        song.setModifiedAt(new Date());
        song.setArtistId(artist.get());
        repo.save(song);

        genreSongService.updateGenresForSong(request.getId(), request.getGenreIds());

        return request;
    }

    @CacheEvict(value = {"artistsDisplayForAdmin",
            "albumsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public void listen(int songId) {
        Optional<Songs> op = repo.findByIdAndIsDeleted(songId, false);
        //check sự tồn tại
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + songId);
        }
        Songs song = op.get();
        song.setListenAmount(song.getListenAmount() + 1);
        repo.save(song);
        viewInMonthService.increaseListenAmountOrCreateNew(new NewOrUpdateViewInMonth(songId));
    }

    @CacheEvict(value = {"artistsDisplayForAdmin",
            "albumsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public void like(LikeBaseModel likeModel) {
        Optional<Songs> op = repo.findByIdAndIsDeleted(likeModel.getItemId(), false);
        //check sự tồn tại
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + likeModel.getItemId());
        }
        favouriteSongService.addNewFS(new NewOrUpdateFavouriteSong(null, likeModel.getItemId(), likeModel.getUserId()));
    }

    @CacheEvict(value = {"artistsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public void unlikeSong(LikeBaseModel request) {
        Optional<FavouriteSongs> op = favRepo.findByUserIdAndSongId(request.getUserId(), request.getItemId());
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any FavouriteSong");
        }
        favRepo.delete(op.get());
    }

    @CacheEvict(value = {"artistsDisplayForAdmin",
            "albumsDisplayForAdmin", "songsDisplayForAdmin", "songsDisplay", "songsByArtist", "songsByAlbum", "favSongs",
            "songsByGenre", "songsByPlaylist"}, allEntries = true)
    public void toggleSongPendingStatus(int id) {
        Optional<Songs> op = repo.findByIdAndIsDeleted(id, false);
        if (op.isEmpty()) {
            throw new NotFoundException("Can't find any song with id: " + id);
        }
        Songs song = op.get();
        song.setIsPending(!song.getIsPending());
        song.setModifiedAt(new Date());
        repo.save(song);
    }

    public SongResponse toSongResponse(Songs song) {
        SongResponse res = new SongResponse();
        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumId(song.getAlbumId().getId());
        }
        res.setArtistId(song.getArtistId().getId());
        List<Integer> genreIds = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getId())
                .toList();
        res.setGenreIds(genreIds);
        return res;
    }

    public SongDisplay toSongDisplay(Songs song) {
        SongDisplay res = new SongDisplay();
        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumTitle(song.getAlbumId().getTitle());
            res.setAlbumImage(song.getAlbumId().getImage());
        }
        res.setArtistName(song.getArtistId().getArtistName());
        List<String> genreNames = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getTitle())
                .toList();
        res.setGenreNames(genreNames);
        return res;
    }

    public SongDisplayForAdmin toSongDisplayAdmin(Songs song) {
        SongDisplayForAdmin res = new SongDisplayForAdmin();
        int favCount = favRepo.findFSBySongId(song.getId(), false).size();
        res.setTotalFavourite(favCount);

        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumTitle(song.getAlbumId().getTitle());
            res.setAlbumImage(song.getAlbumId().getImage());
        }
        res.setArtistName(song.getArtistId().getArtistName());
        List<String> genreNames = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getTitle())
                .toList();
        res.setGenreNames(genreNames);
        return res;
    }

    public SongDisplay toSongDisplay(FavouriteSongs fsSong) {
        Songs song = repo.findByIdAndIsDeleted(fsSong.getSongId().getId(), false).get();
        SongDisplay res = new SongDisplay();
        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumTitle(song.getAlbumId().getTitle());
            res.setAlbumImage(song.getAlbumId().getImage());
        }
        res.setArtistName(song.getArtistId().getArtistName());
        List<String> genreNames = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getTitle())
                .toList();
        res.setGenreNames(genreNames);
        return res;
    }

    public SongDisplayForAdmin toSongDisplayAdmin(FavouriteSongs fsSong) {
        Songs song = repo.findByIdAndIsDeleted(fsSong.getSongId().getId(), false).get();
        SongDisplayForAdmin res = new SongDisplayForAdmin();

        int favCount = favRepo.findFSBySongId(song.getId(), false).size();
        res.setTotalFavourite(favCount);

        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumTitle(song.getAlbumId().getTitle());
            res.setAlbumImage(song.getAlbumId().getImage());
        }
        res.setArtistName(song.getArtistId().getArtistName());
        List<String> genreNames = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getTitle())
                .toList();
        res.setGenreNames(genreNames);
        return res;
    }


    public SongDisplay toSongDisplay(GenreSong genreSong) {
        Songs song = repo.findByIdAndIsDeleted(genreSong.getSongId().getId(), false).get();

        SongDisplay res = new SongDisplay();
        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumTitle(song.getAlbumId().getTitle());
            res.setAlbumImage(song.getAlbumId().getImage());
        }
        res.setArtistName(song.getArtistId().getArtistName());
        List<String> genreNames = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getTitle())
                .toList();
        res.setGenreNames(genreNames);
        return res;
    }

    public SongDisplayForAdmin toSongDisplayAdmin(GenreSong genreSong) {
        Songs song = repo.findByIdAndIsDeleted(genreSong.getSongId().getId(), false).get();

        SongDisplayForAdmin res = new SongDisplayForAdmin();
        int favCount = favRepo.findFSBySongId(song.getId(), false).size();
        res.setTotalFavourite(favCount);
        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumTitle(song.getAlbumId().getTitle());
            res.setAlbumImage(song.getAlbumId().getImage());
        }
        res.setArtistName(song.getArtistId().getArtistName());
        List<String> genreNames = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getTitle())
                .toList();
        res.setGenreNames(genreNames);
        return res;
    }

    public SongDisplay toSongDisplay(PlaylistSong playlistSong) {
        Songs song = repo.findByIdAndIsDeleted(playlistSong.getSongId().getId(), false).get();

        SongDisplay res = new SongDisplay();
        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumTitle(song.getAlbumId().getTitle());
            res.setAlbumImage(song.getAlbumId().getImage());
        }
        res.setArtistName(song.getArtistId().getArtistName());
        List<String> genreNames = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getTitle())
                .toList();
        res.setGenreNames(genreNames);
        return res;
    }

    public SongDisplayForAdmin toSongDisplayAdmin(PlaylistSong playlistSong) {
        Songs song = repo.findByIdAndIsDeleted(playlistSong.getSongId().getId(), false).get();

        SongDisplayForAdmin res = new SongDisplayForAdmin();
        int favCount = favRepo.findFSBySongId(song.getId(), false).size();
        res.setTotalFavourite(favCount);
        BeanUtils.copyProperties(song, res);
        res.setIsDeleted(song.getIsDeleted());
        res.setIsPending(song.getIsPending());
        if (song.getAlbumId() != null) {
            res.setAlbumTitle(song.getAlbumId().getTitle());
            res.setAlbumImage(song.getAlbumId().getImage());
        }
        res.setArtistName(song.getArtistId().getArtistName());
        List<String> genreNames = genSongRepo.findBySongId(song.getId(), false)
                .stream()
                .map(it -> it.getGenreId().getTitle())
                .toList();
        res.setGenreNames(genreNames);
        return res;
    }
}
