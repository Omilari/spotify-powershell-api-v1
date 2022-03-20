$token = "BQBj-Sibeknctpu4S1NXChyhLsBAJmxEl6tasv8AvlFw72JnqmTY5PZ1uMHWbHFp4qAZLbWp2qYgxArWrpm3H8wejufXIBzz0PDTQcY8C8LJT2DqgIFF_j3Zm_4hqrnTQGBImDwplKq6Lkv1LWxDyQGZjMwwsSg--0A5pGT1bIHSBkCNErbOXNDN0XB2G9JuY-s-nbe-6w9lZRa13pPN6c4_1gUv4WpWX4btSGivM5Vwi9CQooonq2b20quJ2BrrNk19vfD4u0FN4ohpmNfbGMqwIOhXGDAeMdj0KHyF"

$headers = @{
    Authorization = "Bearer " + $token
    
}

function Get-Username {
    
    $UserProfileEndpoint = "https://api.spotify.com/v1/me"
    $personalUsername = Invoke-RestMethod -uri $UserProfileEndpoint -Method Get -ContentType "application/json" -Headers $headers 
    $global:clientUsername = $personalUsername.id
    Write-Host "Your Username is: " $clientUsername

}

function Change-Volume {
    $volumeBase ="https://api.spotify.com/v1/me/player/volume?volume_percent="
    $volume_percent = Write-Host "what number would you like your volume to be?"

    $volumeEndpoint = $volumeBase + $volume_percent
    
    $change = Invoke-RestMethod -uri $volumeEndpoint -Method Put -ContentType "application/json" -Headers $headers

 
}

function Get-SavedTracks {
    $userTracks = Invoke-RestMethod -uri "https://api.spotify.com/v1/me/tracks?limit=50&offset=34" -Method Get -ContentType "application/json" -Headers $headers
    $userTracks.items.track.name

}

function Save-Track {
    $trackEndpoint = "https://api.spotify.com/v1/me/tracks?ids="
    
    $searchSong = Read-Host "What song are you looking for?"
    $artistName = Read-Host "what is the name of the artist?"

    $searchedSongEndpoint = $searchEndPoint + $searchSong + "&type=track"

    $responseSearch = Invoke-RestMethod -uri $searchedSongEndpoint -Method Get -ContentType "application/json" -Headers $headers

    $songItems = $responseSearch.tracks.items

    $songUri = ""

    ForEach ($item in $songItems) {
            $artistCheck = $item.artists.name.ToLower()
            if ($artistCheck -eq $artistName){
               $songUri = $item.uri
               break
            }
        }  

    $track = $trackEndpoint + $songUri

    $saveTrack = Invoke-RestMethod -uri $track -Method Put -ContentType "application/json" -Headers $headers

}