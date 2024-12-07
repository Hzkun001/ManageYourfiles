@echo off
setlocal enabledelayedexpansion

:menu
echo ===========================================
echo Pilihan:
echo [1] Kelola File Saja
echo [2] Kelola File dan Folder
echo [3] Cari File
echo [4] Undo Pindahan
echo [5] Keluar
echo ===========================================
set /p choice=Silakan pilih (1, 2, 3, 4, atau 5): 

REM Fitur Kelola File Saja
if "%choice%"=="1" goto :kelola_file

REM Fitur Kelola File dan Folder
if "%choice%"=="2" goto :kelola_file_dan_folder

REM Fitur Pencarian File
if "%choice%"=="3" goto :cari_file

REM Fitur Undo Pindahan
if "%choice%"=="4" goto :undo

REM Keluar dari program
if "%choice%"=="5" (
    echo Terima kasih telah menggunakan program ini!
    exit
)

echo Pilihan tidak valid. Silakan coba lagi.
goto menu

:kelola_file
echo Mengelola file saja...

REM Filter Tipe Data
echo Pilih tipe file untuk diorganisir:
echo [1] Semua tipe file
echo [2] File teks (.txt)
echo [3] File gambar (.jpg, .png)
set /p filetype=Pilihan Anda: 

if "%filetype%"=="2" set "ext=txt"
if "%filetype%"=="3" set "ext=jpg png"
if "%filetype%"=="1" set "ext=*"

REM Loop untuk mengelola file di folder ini
for %%F in (*.%ext%) do (
    REM Pastikan yang diproses adalah file, bukan folder
    if not "%%~aF"=="d" (
        REM Ambil huruf pertama dari nama file
        set "filename=%%~nxF"
        set "firstchar=!filename:~0,1!"

        REM Ubah ke huruf besar jika perlu
        for %%L in (!firstchar!) do (
            set "upper=%%~L"
        )

        REM Buat folder alphabet jika belum ada
        if not exist "!upper!" (
            mkdir "!upper!"
        )

        REM Catat lokasi sebelum dipindahkan
        echo [INFO] %date% %time% - Memindahkan file %%F ke !upper! >> log.txt
        
        REM Pindahkan file ke folder alphabet
        move "%%F" "!upper!\%%~nxF"
    )
)
echo File telah diorganisir berdasarkan huruf pertama!
pause
goto menu

:kelola_file_dan_folder
echo Mengelola file dan folder...

REM Filter Tipe Data
echo Pilih tipe file untuk diorganisir:
echo [1] Semua tipe file
echo [2] File teks (.txt)
echo [3] File gambar (.jpg, .png)
set /p filetype=Pilihan Anda: 

if "%filetype%"=="2" set "ext=txt"
if "%filetype%"=="3" set "ext=jpg png"
if "%filetype%"=="1" set "ext=*"

REM Loop untuk mengelola folder berdasarkan huruf pertama nama folder
for /d %%D in (*) do (
    REM Proses hanya folder, bukan file
    if exist "%%D" (
        REM Ambil huruf pertama dari nama folder
        set "foldername=%%~nxD"
        set "firstchar=!foldername:~0,1!"

        REM Ubah ke huruf besar jika perlu
        for %%L in (!firstchar!) do (
            set "upper=%%~L"
        )

        REM Buat folder alphabet jika belum ada
        if not exist "!upper!" (
            mkdir "!upper!"
        )

        REM Catat lokasi sebelum dipindahkan
        echo [INFO] %date% %time% - Memindahkan folder %%D ke !upper! >> log.txt
        
        REM Pindahkan folder ke folder alphabet
        move "%%D" "!upper!\%%~nxD"
    )
)

REM Setelah folder, kelola juga file
for %%F in (*.%ext%) do (
    REM Pastikan yang diproses adalah file
    if not "%%~aF"=="d" (
        REM Ambil huruf pertama dari nama file
        set "filename=%%~nxF"
        set "firstchar=!filename:~0,1!"

        REM Ubah ke huruf besar jika perlu
        for %%L in (!firstchar!) do (
            set "upper=%%~L"
        )

        REM Buat folder alphabet jika belum ada
        if not exist "!upper!" (
            mkdir "!upper!"
        )

        REM Catat lokasi sebelum dipindahkan
        echo [INFO] %date% %time% - Memindahkan file %%F ke !upper! >> log.txt
        
        REM Pindahkan file ke folder alphabet
        move "%%F" "!upper!\%%~nxF"
    )
)
echo File dan folder telah diorganisir berdasarkan huruf pertama!
pause
goto menu

:cari_file
echo =========================
set /p search=Masukkan nama file yang ingin dicari (awal): 

echo =========================
echo Hasil pencarian:
dir /b /s *%search%* > temp.txt
if %errorlevel% neq 0 (
    echo Tidak ada file yang ditemukan.
) else (
    if exist temp.txt (
        echo File ditemukan!
        type temp.txt
    ) else (
        echo Tidak ada file yang ditemukan.
    )
)
del temp.txt
pause
goto menu

:undo
echo =========================
echo Mengembalikan file/folder...
for /f "tokens=1,2*" %%A in (log.txt) do (
    if "%%A"=="[INFO]" (
        echo Mengembalikan %%C...
        move "%%C" "%%~dC%%~pC" 2>nul
    )
)
echo Proses pengembalian selesai!
pause
goto menu
