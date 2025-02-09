import { Component, Inject } from '@angular/core';
import {
  MAT_DIALOG_DATA,
  MatDialogModule,
  MatDialogRef,
} from '@angular/material/dialog';
import { CommonService } from '../../services/common.service';
import { CommonModule } from '@angular/common';
import { forkJoin } from 'rxjs';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { ToastrService } from 'ngx-toastr';

interface dataToSend {
  audio?: any;
  lrc?: any;
}

@Component({
  selector: 'app-edit-file',
  imports: [
    MatDialogModule,
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatSelectModule,
    MatFormFieldModule,
  ],
  templateUrl: './edit-file.component.html',
  styleUrls: ['./edit-file.component.css'],
})
export class EditFileComponent {
  submitted = false;
  fileAudioError: string | null = null;
  fileLrcError: string | null = null;

  selectedLrcFile: File | null = null;
  selectedAudioFile: File | null = null;

  constructor(
    @Inject(MAT_DIALOG_DATA) public idDetail: any,
    private commonService: CommonService,
    private dialogRef: MatDialogRef<EditFileComponent>,
    private toastr: ToastrService
  ) {}

  edit() {
    this.submitted = true;
    let apiCalls = [];
    if (this.selectedAudioFile && this.fileAudioError == null) {
      apiCalls.push(this.commonService.uploadFileAudio(this.selectedAudioFile));
    }

    if (this.selectedLrcFile && this.fileLrcError == null) {
      apiCalls.push(this.commonService.uploadFileLrc(this.selectedLrcFile));
    }

    if (apiCalls.length > 0) {
      forkJoin(apiCalls).subscribe({
        next: (responses) => {
          let dataToSend: dataToSend = {};
          console.log(apiCalls.length);
          if (this.selectedAudioFile && this.fileAudioError == null) {
            dataToSend['audio'] = responses[0];
          } else {
            dataToSend['audio'] = null;
          }

          if (this.selectedLrcFile && this.fileLrcError == null) {
            dataToSend['lrc'] = responses[1];
          } else {
            dataToSend['lrc'] = null;
          }

          this.callNextApi(dataToSend);
        },
        error: (error) => {
          console.error('Error in file uploads:', error);
        },
      });
    }
  }

  callNextApi(dataToSend: dataToSend) {
    if (dataToSend.audio != null) {
      const dataAudio = {
        id: this.idDetail.id,
        fileName: dataToSend.audio,
      };
      this.commonService.editDataFile('audio', dataAudio).subscribe({
        next: (response) => {
          console.log('Audio data updated successfully:', response);
          this.toastr.success('', 'updated audio file!');
        },
        error: (error) => {
          console.error('Error updating audio data:', error);
          this.toastr.error('', 'Error updating audio file!');
        },
      });
    }

    if (dataToSend.lrc != null) {
      const dataRlc = {
        id: this.idDetail.id,
        fileName: dataToSend.lrc,
      };
      this.commonService.editDataFile('rlc', dataRlc).subscribe({
        next: (response) => {
          console.log('RLC data updated successfully:', response);
          this.toastr.success('', 'updated rlc file!');
        },
        error: (error) => {
          console.error('Error updating RLC data:', error);
        },
      });
    }
    this.dialogRef.close('saved');
  }

  triggerFileInput(fileType: string) {
    const fileInput = document.getElementById(fileType) as HTMLInputElement;
    fileInput?.click();
  }

  onFileSelectedAudio(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input?.files) {
      const file = input.files[0];
      const validation = this.commonService.validateFile(file);

      if (!validation.valid) {
        this.fileAudioError = validation.error;
        this.selectedAudioFile = null;
      } else {
        this.selectedAudioFile = file;
        this.fileAudioError = null;
      }
    }
  }

  onFileSelectedLrc(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input?.files) {
      const file = input.files[0];
      const validation = this.commonService.validateFileLrc(file);

      if (!validation.valid) {
        this.fileLrcError = validation.error;
        this.selectedLrcFile = null;
      } else {
        this.selectedLrcFile = file;
        this.fileLrcError = null;
      }
    }
  }
}
