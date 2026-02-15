param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [Parameter(Mandatory = $true)]
    [string]$ExpectedHash
)

# Pastikan file ada
if (-not (Test-Path $FilePath)) {
    Write-Host "ERROR: File tidak ditemukan: $FilePath" -ForegroundColor Red
    exit 1
}

# Hitung hash SHA256 file
$actualHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash.ToLower()
$expectedHash = $ExpectedHash.ToLower()

Write-Host "File       : $FilePath"
Write-Host "Dihitung   : $actualHash"
Write-Host "Diharapkan : $expectedHash"
Write-Host ""

# Bandingkan hash
if ($actualHash -eq $expectedHash) {
    Write-Host "Hash cocok! File valid dan belum diubah." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Hash TIDAK cocok! File mungkin telah dimodifikasi atau rusak." -ForegroundColor Yellow
    exit 2
}

