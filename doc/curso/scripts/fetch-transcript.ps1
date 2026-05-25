param(
  [Parameter(Mandatory = $true)]
  [string]$Cookie,

  [string]$LessonUrl = "https://www.techleads.club/c/workshop-ia-5-2026-gravacao/sections/1027866/lessons/3906405",

  [string]$OutputDir = "$PSScriptRoot\..\workshop-ia-5-2026-gravacao\lesson-3906405"
)

$ErrorActionPreference = "Stop"

if ($LessonUrl -notmatch "/sections/(?<sectionId>\d+)/lessons/(?<lessonId>\d+)") {
  throw "URL da lição inválida."
}

$sectionId = $Matches.sectionId
$lessonId = $Matches.lessonId
$spaceSlug = ($LessonUrl -replace "^https?://[^/]+/c/([^/]+)/.*$", '$1')

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"

foreach ($part in $Cookie.Split(";")) {
  $pair = $part.Trim()
  if (-not $pair) { continue }
  $eq = $pair.IndexOf("=")
  if ($eq -lt 1) { continue }
  $name = $pair.Substring(0, $eq).Trim()
  $value = $pair.Substring($eq + 1).Trim()
  $session.Cookies.Add((New-Object System.Net.Cookie($name, $value, "/", "www.techleads.club")))
}

function Invoke-TlcApi {
  param([string]$Path)
  $uri = "https://www.techleads.club/internal_api/$Path"
  return Invoke-RestMethod -Uri $uri -WebSession $session -Headers @{
    Accept = "application/json"
    "X-Requested-With" = "XMLHttpRequest"
  }
}

$space = Invoke-TlcApi -Path "spaces/$spaceSlug"
$courseId = $space.course.id
if (-not $courseId) { $courseId = $space.course_id }

$lesson = Invoke-TlcApi -Path "courses/$courseId/sections/$sectionId/lessons/$lessonId"
$lessonJson = $lesson | ConvertTo-Json -Depth 20

$transcriptId = $null
if ($lessonJson -match '"media_transcript_id"\s*:\s*(\d+)') {
  $transcriptId = [int]$Matches[1]
}

if (-not $transcriptId) {
  throw "media_transcript_id não encontrado na resposta da lição."
}

$vttPath = Join-Path $OutputDir "transcricao-lesson-$lessonId.vtt"
$txtPath = Join-Path $OutputDir "transcricao-lesson-$lessonId.txt"

try {
  Invoke-WebRequest -Uri "https://www.techleads.club/media_transcripts/$transcriptId.vtt" `
    -WebSession $session -OutFile $vttPath

  $vtt = Get-Content $vttPath -Raw
  $text = ($vtt -split "`n" | Where-Object {
      $_ -and
      $_ -notmatch "^WEBVTT" -and
      $_ -notmatch "^\d+$" -and
      $_ -notmatch "^\d{2}:\d{2}:\d{2}\.\d{3}\s-->"
    }) -join "`n"

  $text | Out-File -Encoding utf8 $txtPath
}
catch {
  $json = Invoke-TlcApi -Path "media_transcripts/$transcriptId"
  ($json | ConvertTo-Json -Depth 20) | Out-File -Encoding utf8 $txtPath
}

Write-Host "Arquivos salvos em: $OutputDir"
