class UrlConsts {
  static String HOST = "localhost:8080";
  static String REGISTER = "/api/register";
  static String LOGIN = "/api/login";
  static String USERBYID = "/api/public/users";
  static String GENRE = "/api/public/genres";

  static String CATEGORYALBUMS = "/api/public/categories/withAlbum";

  static String SONGBYGENREID = "/api/public/songs/byGenre/display";
  static String SONGBYAlbumID = "/api/public/songs/byAlbum/display";
  static String LIKESONG = "/api/public/songs/like";
  static String UNLIKESONG = "/api/public/songs/unlike";
  static String LISTENSONG = "/api/public/songs/listen";
  static String SONGBYPLAYLIST = "/api/public/songs/byPlaylist/display";
  
  static String FAVOURITESONG = "/api/public/songs/byUser/display";
  static String SONGS = "/api/public/songs";

  static String KEYWORDS = "/api/public/keywords";
  static String ALBUMS = "/api/public/albums";

  static String FAVOURITE_SONGS = "/api/public/favourite-songs";
  static String FAVOURITE_ALBUMS = "/api/public/favourite-albums";

  static String USERPLAYLIST = "/api/public/playlists/byUser/display";
  static String PLAYLISTBYUSER = "/api/public/playlists";

  static String ADDTOPLAYLIST = "/api/public/playlist-song";
  static String PLAYLISTSONGS = "/api/public/playlist-song";

  static String USERS = "/api/public/users";
  static String NEWS = "/api/public/news";
  static String IMAGE = "/api/download/image";
  static final List<String> _WHILTE_LIST_PATHS = [REGISTER, LOGIN];

  static bool isInWhilteList(String path) {
    return _WHILTE_LIST_PATHS.where((it) => it == path).isNotEmpty;
  }
}
