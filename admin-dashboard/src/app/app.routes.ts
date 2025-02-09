import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { AdminOverviewComponent } from './admin-overview/admin-overview.component';
import { OverviewUserComponent } from './user/overview-user/overview-user.component';
import { CreateUserComponent } from './user/create-user/create-user.component';
import { EditUserComponent } from './user/edit-user/edit-user.component';
import { DeleteUserComponent } from './user/delete-user/delete-user.component';
import { DetailsUserComponent } from './user/details-user/details-user.component';
import { ErrorPageComponent } from './error-page/error-page.component';
import { OverviewNewsComponent } from './news/overview-news/overview-news.component';
import { DetailsSubjectComponent } from './subject/details-subject/details-subject.component';
import { DeleteSubjectComponent } from './subject/delete-subject/delete-subject.component';
import { EditSubjectComponent } from './subject/edit-subject/edit-subject.component';
import { CreateSubjectComponent } from './subject/create-subject/create-subject.component';
import { OverviewSubjectComponent } from './subject/overview-subject/overview-subject.component';
import { DetailsGenreComponent } from './genre/details-genre/details-genre.component';
import { OverviewKeywordComponent } from './keyword/overview-keyword/overview-keyword.component';
import { DeleteGenreComponent } from './genre/delete-genre/delete-genre.component';
import { EditGenreComponent } from './genre/edit-genre/edit-genre.component';
import { CreateGenreComponent } from './genre/create-genre/create-genre.component';
import { OverviewGenreComponent } from './genre/overview-genre/overview-genre.component';
import { DetailsPlaylistComponent } from './playlist/details-playlist/details-playlist.component';
import { DeletePlaylistComponent } from './playlist/delete-playlist/delete-playlist.component';
import { EditPlaylistComponent } from './playlist/edit-playlist/edit-playlist.component';
import { CreatePlaylistComponent } from './playlist/create-playlist/create-playlist.component';
import { OverviewPlaylistComponent } from './playlist/overview-playlist/overview-playlist.component';
import { DetailsAlbumComponent } from './album/details-album/details-album.component';
import { DeleteAlbumComponent } from './album/delete-album/delete-album.component';
import { EditAlbumComponent } from './album/edit-album/edit-album.component';
import { CreateAlbumComponent } from './album/create-album/create-album.component';
import { OverviewAlbumComponent } from './album/overview-album/overview-album.component';
import { DetailsSongComponent } from './song/details-song/details-song.component';
import { DeleteSongComponent } from './song/delete-song/delete-song.component';
import { EditSongComponent } from './song/edit-song/edit-song.component';
import { CreateSongComponent } from './song/create-song/create-song.component';
import { OverviewSongComponent } from './song/overview-song/overview-song.component';
import { OverviewArtistComponent } from './artist/overview-artist/overview-artist.component';
import { DetailsArtistComponent } from './artist/details-artist/details-artist.component';
import { DeleteArtistComponent } from './artist/delete-artist/delete-artist.component';
import { EditArtistComponent } from './artist/edit-artist/edit-artist.component';
import { CreateArtistComponent } from './artist/create-artist/create-artist.component';
import { DetailsNewsComponent } from './news/details-news/details-news.component';
import { DeleteNewsComponent } from './news/delete-news/delete-news.component';
import { EditNewsComponent } from './news/edit-news/edit-news.component';
import { CreateNewsComponent } from './news/create-news/create-news.component';
import { DetailsKeywordComponent } from './keyword/details-keyword/details-keyword.component';
import { DeleteKeywordComponent } from './keyword/delete-keyword/delete-keyword.component';
import { EditKeywordComponent } from './keyword/edit-keyword/edit-keyword.component';
import { CreateKeywordComponent } from './keyword/create-keyword/create-keyword.component';
import { AuthGuard } from '../auth.guard';
import { ArtOverviewComponent } from './art-overview/art-overview.component';

export const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  // dashboard routes
  {
    path: 'dashboard',
    component: AdminOverviewComponent,
    canActivate: [AuthGuard],
  },
  // art overview routes
  {
    path: 'art-overview',
    component: ArtOverviewComponent,
    canActivate: [AuthGuard],
  },

  // user routes
  {
    path: 'users',
    component: OverviewUserComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-user',
    component: CreateUserComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'users/:id/edit',
    component: EditUserComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'users/:id/delete',
    component: DeleteUserComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'users/:id/details',
    component: DetailsUserComponent,
    canActivate: [AuthGuard],
  },

  // artist routes
  {
    path: 'artists',
    component: OverviewArtistComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-artist',
    component: CreateArtistComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'artists/:id/edit',
    component: EditArtistComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'artists/:id/delete',
    component: DeleteArtistComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'artists/:id/details',
    component: DetailsArtistComponent,
    canActivate: [AuthGuard],
  },

  //songs routes
  {
    path: 'songs',
    component: OverviewSongComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-song',
    component: CreateSongComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'songs/:id/edit',
    component: EditSongComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'songs/:id/delete',
    component: DeleteSongComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'songs/:id/details',
    component: DetailsSongComponent,
    canActivate: [AuthGuard],
  },

  //albums routes
  {
    path: 'albums',
    component: OverviewAlbumComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-album',
    component: CreateAlbumComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'albums/:id/edit',
    component: EditAlbumComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'albums/:id/delete',
    component: DeleteAlbumComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'albums/:id/details',
    component: DetailsAlbumComponent,
    canActivate: [AuthGuard],
  },

  //playlists routes
  {
    path: 'playlists',
    component: OverviewPlaylistComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-playlist',
    component: CreatePlaylistComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'playlists/:id/edit',
    component: EditPlaylistComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'playlists/:id/delete',
    component: DeletePlaylistComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'playlists/:id/details',
    component: DetailsPlaylistComponent,
    canActivate: [AuthGuard],
  },

  //genres routes
  {
    path: 'genres',
    component: OverviewGenreComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-genres',
    component: CreateGenreComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'genres/:id/edit',
    component: EditGenreComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'genres/:id/delete',
    component: DeleteGenreComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'genres/:id/details',
    component: DetailsGenreComponent,
    canActivate: [AuthGuard],
  },

  //keywords routes
  {
    path: 'keywords',
    component: OverviewKeywordComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-keywords',
    component: CreateKeywordComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'keywords/:id/edit',
    component: EditKeywordComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'keywords/:id/delete',
    component: DeleteKeywordComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'keywords/:id/details',
    component: DetailsKeywordComponent,
    canActivate: [AuthGuard],
  },

  // subjects routes
  {
    path: 'subjects',
    component: OverviewSubjectComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-subject',
    component: CreateSubjectComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'subjects/:id/edit',
    component: EditSubjectComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'subjects/:id/delete',
    component: DeleteSubjectComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'subjects/:id/details',
    component: DetailsSubjectComponent,
    canActivate: [AuthGuard],
  },

  // news routes
  {
    path: 'news',
    component: OverviewNewsComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'add-news',
    component: CreateNewsComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'news/:id/edit',
    component: EditNewsComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'news/:id/delete',
    component: DeleteNewsComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'news/:id/details',
    component: DetailsNewsComponent,
    canActivate: [AuthGuard],
  },
  { path: '**', component: ErrorPageComponent, canActivate: [AuthGuard] },
  { path: 'error', component: ErrorPageComponent },
];
