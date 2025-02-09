import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import {
  catchError,
  firstValueFrom,
  map,
  Observable,
  Subject,
  throwError,
} from 'rxjs';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root',
})
export class CommonService {
  private baseUrl = 'http://localhost:8080/api';
  private uploadImgUrl = 'http://localhost:8080/api/files/upload/image';
  private uploadAudioUrl = 'http://localhost:8080/api/files/upload/audio';
  private uploadRlcUrl = 'http://localhost:8080/api/files/upload/lrc';
  private downloadUrl = 'http://localhost:8080/api/files/download/image';
  private adminBaseUrl = 'http://localhost:8080/api/admin';
  constructor(
    private http: HttpClient,
    private router: Router,
    private authService: AuthService
  ) {}
  sendToken(): HttpHeaders {
    if (this.authService.isAuthenticated()) {
      const token = this.authService.getToken();

      return new HttpHeaders({
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      });
    }
    return new HttpHeaders();
  }
  updateData(updatedData: any): Observable<any> {
    const headers = this.sendToken();
    return this.http
      .put(`${this.baseUrl}/public/users`, updatedData, { headers: headers })
      .pipe(
        catchError((err) => {
          return throwError(() => ({
            status: err.status,
            errors: err.error?.listError || [],
          }));
        })
      );
  }

  // filter dropdown autocomplete
  filterData(fieldFilter: string, listData: any[], value: string): any[] {
    return listData.filter((data) =>
      data[fieldFilter]?.toLowerCase().includes(value.toLowerCase())
    );
  }

  validateFileLrc(file: File): { valid: boolean; error: string | null } {
    if (!file.name.endsWith('.lrc')) {
      return {
        valid: false,
        error: 'Only lrc files are allowed. Choose again!',
      };
    }
    return { valid: true, error: null };
  }

  validateFile(file: File): { valid: boolean; error: string | null } {
    if (!file.name.endsWith('.mp3') && !file.name.endsWith('.mp4')) {
      return {
        valid: false,
        error: 'Only mp3 or mp4 files are allowed. Choose again!',
      };
    }
    return { valid: true, error: null };
  }

  downloadImage(imageName: string): Observable<Blob> {
    const headers = this.sendToken();

    return this.http.get(`${this.downloadUrl}/${imageName}`, {
      responseType: 'blob',
      headers: headers,
    });
  }

  // upload image
  validateImage(file: File): { valid: boolean; error: string | null } {
    if (!file.type.match('image.*')) {
      return {
        valid: false,
        error: 'Only image files are allowed. Choose again!',
      };
    }
    return { valid: true, error: null };
  }
  uploadImage(file: File): Observable<string> {
    const formData = new FormData();
    formData.append('file', file);
    // const headers = this.sendToken();

    return this.http.post(this.uploadImgUrl, formData, {
      responseType: 'text',
      // headers: headers,
    });
  }

  uploadFileAudio(file: File): Observable<string> {
    const formData = new FormData();
    formData.append('file', file);
    // const headers = this.sendToken();

    return this.http.post(this.uploadAudioUrl, formData, {
      responseType: 'text',
      // headers: headers,
    });
  }

  uploadFileLrc(file: File): Observable<string> {
    const formData = new FormData();
    formData.append('file', file);
    // const headers = this.sendToken();

    return this.http.post(this.uploadRlcUrl, formData, {
      responseType: 'text',
      // headers: headers,
    });
  }

  // fetch list data
  fetchListData(tableName: string, page: number = 0): Observable<any> {
    const headers = this.sendToken();

    const params = new HttpParams().set('page', page.toString());

    return this.http
      .get<any>(`${this.baseUrl}/admin/${tableName}/display`, {
        params,
        headers: headers,
      })
      .pipe(
        catchError((err) => {
          return throwError(() => ({
            status: err.status,
            errors: err.error?.listError || [],
          }));
        })
      );
  }

  // count data
  getDataCount(tableName: string): Observable<any> {
    const headers = this.sendToken();

    return this.http.get<any>(`${this.adminBaseUrl}/${tableName}/count`, {
      headers: headers,
    });
  }
  getBaseUrl(): string {
    return this.baseUrl;
  }

  //getDetail
  async getDetail(name: string, id: string): Promise<any> {
    try {
      const headers = this.sendToken();

      return await firstValueFrom(
        this.http.get(`${this.baseUrl}/admin/${name}/display/${id}`, {
          headers: headers,
        })
      );
    } catch (error: any) {
      console.error('Error fetching data:', error);
      if (error.status === 404) {
        this.router.navigate(['/error']);
      } else {
        console.error('Unexpected error occurred:', error);
      }
      throw error;
    }
  }

  // create
  create(name: string, data: any): Observable<any> {
    const headers = this.sendToken();

    return this.http
      .post<any>(`${this.baseUrl}/public/${name}`, data, { headers: headers })
      .pipe(
        catchError((err) => {
          return throwError(() => ({
            status: err.status,
            errors: err.error?.listError || [],
          }));
        })
      );
  }

  async getListSongBySomeThing(
    name: string,
    id: string,
    page: number = 0
  ): Promise<any> {
    try {
      const headers = this.sendToken();

      return await firstValueFrom(
        this.http.get(`${this.adminBaseUrl}/songs/${name}/display/${id}`, {
          params: {
            page: page.toString(),
          },
          headers: headers,
        })
      );
    } catch (error) {
      throw error;
    }
  }

  async getListAlbumBySomeThing(
    name: string,
    id: string,
    page: number = 0
  ): Promise<any> {
    try {
      const headers = this.sendToken();

      return await firstValueFrom(
        this.http.get(`${this.adminBaseUrl}/albums/${name}/display/${id}`, {
          params: {
            page: page.toString(),
          },
          headers: headers,
        })
      );
    } catch (error) {
      throw error;
    }
  }

  deleteData(endpoint: string, id: number): Observable<any> {
    const headers = this.sendToken();

    return this.http.delete(`${this.baseUrl}/public/${endpoint}/${id}`, {
      headers: headers,
    });
  }

  private countUpdatedSource = new Subject<string>();
  countUpdated$ = this.countUpdatedSource.asObservable();

  updateCount(entity: string): void {
    this.getDataCount(entity).subscribe({
      next: (res) => {
        this.countUpdatedSource.next(entity);
      },
      error: (err) => {
        console.error(`Error fetching count for ${entity}:`, err);
      },
    });
  }

  updateUserCount(): void {
    this.updateCount('users');
  }

  updateSongCount(): void {
    this.updateCount('songs');
  }

  updatePlaylistCount(): void {
    this.updateCount('playlists');
  }

  updateAlbumCount(): void {
    this.updateCount('albums');
  }

  updateArtistCount(): void {
    this.updateCount('artists');
  }

  updateGenreCount(): void {
    this.updateCount('genres');
  }

  updateKeywordCount(): void {
    this.updateCount('keywords');
  }

  updateNewsCount(): void {
    this.updateCount('news');
  }

  updateCategoryCount(): void {
    this.updateCount('categories');
  }

  async changeStatusSong(name: string, id: string): Promise<any> {
    try {
      const headers = this.sendToken();
      return await firstValueFrom(
        this.http.put(
          `${this.baseUrl}/admin/${name}/toggle/pending/${id}`,
          {},
          {
            headers: headers,
          }
        )
      );
    } catch (error) {
      console.error('Error change status:', error);
      throw error;
    }
  }

  //   changeStatusSong(name: string, id: string): Observable<any> {
  //   const headers = this.sendToken();

  //   return this.http.put(`${this.baseUrl}/admin/${name}/toggle/pending/${id}`, {}, { headers:headers });
  // }

  async changeStatusKeyword(id: string): Promise<any> {
    try {
      return await firstValueFrom(
        this.http.put(`${this.baseUrl}/admin/keywords/toggle/active/${id}`, {},{
          headers: this.sendToken(),
        })
      );
    } catch (error) {
      console.error('Error change status:', error);
      throw error;
    }
  }
  async changeReleaseAlbum(id: string): Promise<any> {
    try {
      return await firstValueFrom(
        this.http.put(`${this.baseUrl}/admin/albums/toggle/release/${id}`,{}, {
          headers: this.sendToken(),
        })
      );
    } catch (error) {
      console.error('Error change status:', error);
      throw error;
    }
  }

  async getSongDashboard(name: string): Promise<any> {
    try {
      const headers = this.sendToken();

      console.log(headers);
      return await firstValueFrom(        
        this.http.get(`${this.baseUrl}/public/songs/${name}`, {
          headers: this.sendToken(),
        })
      );
    } catch (error: any) {
      console.error('Error fetching data:', error);
      throw error;
    }
  }

  async getTotalViewInMonth(month: number): Promise<any> {
    try {
      return await firstValueFrom(
        this.http.get(`${this.baseUrl}/public/listenInMonth/${month}`, {
          headers: this.sendToken(),
        })
      );
    } catch (error: any) {
      console.error('Error views data:', error);
      throw error;
    }
  }

  fetchDataEdit(tableName: string, id: any): Observable<any> {
    return this.http
      .get<any>(`${this.baseUrl}/public/${tableName}/${id}`, {
        headers: this.sendToken(),
      })
      .pipe(
        catchError((err) => {
          return throwError(() => ({
            status: err.status,
            errors: err.error?.listError || [],
          }));
        })
      );
  }

  editData(tableName: string, obj: any): Observable<any> {
    return this.http
      .put<any>(`${this.baseUrl}/public/${tableName}`, obj, {
        headers: this.sendToken(),
      })
      .pipe(
        catchError((err) => {
          return throwError(() => ({
            status: err.status,
            errors: err.error?.listError || [],
          }));
        })
      );
  }

  editDataFile(tableName: string, obj: any): Observable<any> {
    return this.http
      .put<any>(`${this.baseUrl}/admin/songs/change/${tableName}`, obj, {
        headers: this.sendToken(),
      })
      .pipe(
        catchError((err) => {
          return throwError(() => ({
            status: err.status,
            errors: err.error?.listError || [],
          }));
        })
      );
  }

  editAvaFile(tableName: string, obj: any): Observable<any> {
    return this.http
      .put<any>(`${this.baseUrl}/admin/${tableName}`, obj, {
        headers: this.sendToken(),
      })
      .pipe(
        catchError((err) => {
          return throwError(() => ({
            status: err.status,
            errors: err.error?.listError || [],
          }));
        })
      );
  }
}
