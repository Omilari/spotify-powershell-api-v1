
$token = "BQBcv34vNFYkpBhNIAD9OERk_bAeJbeJGWOqU1MUW73ajAbOvSM7D8GeEKl-AYK5dg6qU_ocCoquxXQOKN4Ehg-vA-ZrwiclV7EIyaTDbndAvHTYXtGIYw8ABmemcRpWFtaAk4_2Z78Z9T_fL1T1C4uokO7oTf4UsU0TaCIySkFRASfQ5jVLyXfdz-Wtnyezwk43pYrSq9gmN8l2dIa-uKAxYIFaGBH51RwqecU-i64UATkcFcobbYbzIaoGRFefmeoQefdPX-H6EvTVCEGKiNeMjLd3uI4VkkuWsjFR"

$headers = @{
    Authorization = "Bearer " + $token
    
}

$searchEndPoint = "https://api.spotify.com/v1/search?q="


function Get-Username {
    
    $UserProfileEndpoint = "https://api.spotify.com/v1/me"
    $personalUsername = Invoke-RestMethod -uri $UserProfileEndpoint -Method Get -ContentType "application/json" -Headers $headers 
    $global:clientUsername = $personalUsername.id
    Write-Host "Your Username is: " $clientUsername

}

function New-Playlist {
    

    $playlistName = Read-Host "Name for Playlist"
    $desc = Read-Host "describe the playlist."

    $newPlaylistEndPoint = "https://api.spotify.com/v1/users/" + $clientUsername + "/playlists"

    $requestBody = ConvertTo-Json @{
        name        = $playlistName
        description = $desc
        public      = $false
    }

    $response1 = Invoke-RestMethod -uri $newPlaylistEndPoint -Method POST -ContentType "application/json" -headers $headers -Body $requestBody

}

function Add-Song {
    
    #selects the playlist
    $searchPlaylist = Read-Host "What playlist do you want to add a song too?"
    $searchedPlaylistEndpoint = $searchEndPoint + $searchPlaylist + "&type=playlist"

    $responsePlaylistSearch = Invoke-RestMethod -uri $searchedPlaylistEndpoint -Method Get -ContentType "application/json" -Headers $headers

    #gets users id
    $playlistItems = $responsePlaylistSearch.playlists.items
    $ownerID = ""


    ForEach ($item in $playlistItems.owner.id) {
        if ($item -eq $clientUsername) {
            $ownerID = $item
            break
        }
    }  
    
    $userplaylistList = "https://api.spotify.com/v1/users/" + $ownerID + "/playlists"
    $getplaylistList = Invoke-RestMethod -uri $userplaylistList -Method Get -ContentType "application/json" -headers $headers
    $playlistId = ""

    ForEach ($value in $getplaylistList.items) {
        if ($value.name -eq $searchPlaylist) {
            $playlistId = $value.id
            break
        }
    }

    Write-Host $playlistId


    $searchSong = Read-Host "What song are you looking for?"
    $artistName = Read-Host "what is the name of the artist?"

    $searchedSongEndpoint = $searchEndPoint + $searchSong + "&type=track"

    $responseSearch = Invoke-RestMethod -uri $searchedSongEndpoint -Method Get -ContentType "application/json" -Headers $headers

    $songItems = $responseSearch.tracks.items

    $songUri = ""

    ForEach ($item in $songItems) {
        $artistCheck = $item.artists.name.ToLower()
        if ($artistCheck -eq $artistName) {
            $songUri = $item.uri
            break
        }
    }  

    $addSongEndpoint = "https://api.spotify.com/v1/playlists/" + $playlistId + "/tracks?uris=" + $songUri

    $response2 = Invoke-RestMethod -uri $addSongEndpoint -Method Post -ContentType "application/json" -headers $headers


}

function Get-PlaylistTrackNames {
    #selects the playlist
    $searchPlaylist = Read-Host "What playlist do you want to see the song of?"
    $searchedPlaylistEndpoint = $searchEndPoint + $searchPlaylist + "&type=playlist"

    $responsePlaylistSearch = Invoke-RestMethod -uri $searchedPlaylistEndpoint -Method Get -ContentType "application/json" -Headers $headers

    #gets users id
    $playlistItems = $responsePlaylistSearch.playlists.items
    $ownerID = ""


    ForEach ($item in $playlistItems.owner.id) {
        if ($item -eq $clientUsername) {
            $ownerID = $item
            break
        }
    }  
    
    $userplaylistList = "https://api.spotify.com/v1/users/" + $ownerID + "/playlists"
    $getplaylistList = Invoke-RestMethod -uri $userplaylistList -Method Get -ContentType "application/json" -headers $headers
    $playlistId = ""

    ForEach ($value in $getplaylistList.items) {
        if ($value.name -eq $searchPlaylist) {
            $playlistId = $value.id
            break
        }
    }

    $playlistTracksEndpoint = "https://api.spotify.com/v1/playlists/" + $playlistId + "/tracks"
    $playlistTracks = Invoke-RestMethod -uri $playlistTracksEndpoint -Method Get -ContentType "application/json" -Headers $headers

    $numbers = 0
    ForEach ($value in $playlistTracks.items.track.name ) {
        $numbers = $numbers + 1
        Write-Host $numbers ": " $value 
    }

}

function Edit-PlaylistDetails {

    #selects the playlist
    $searchPlaylist = Read-Host "What playlist do you want to edit?"
    $searchedPlaylistEndpoint = $searchEndPoint + $searchPlaylist + "&type=playlist"

    $responsePlaylistSearch = Invoke-RestMethod -uri $searchedPlaylistEndpoint -Method Get -ContentType "application/json" -Headers $headers

    #gets users id
    $playlistItems = $responsePlaylistSearch.playlists.items
    $ownerID = ""


    ForEach ($item in $playlistItems.owner.id) {
        if ($item -eq $clientUsername) {
            $ownerID = $item
            break
        }
    }  
    
    $userplaylistList = "https://api.spotify.com/v1/users/" + $ownerID + "/playlists"
    $getplaylistList = Invoke-RestMethod -uri $userplaylistList -Method Get -ContentType "application/json" -headers $headers
    $playlistId = ""

    ForEach ($value in $getplaylistList.items) {
        if ($value.name -eq $searchPlaylist) {
            $playlistId = $value.id
            break
        }
    }

    $description = "none"

    $playlistName = Read-Host "What would you like to change the name too?"
    $description = Read-Host "What would you like to change the description too?"

    $requestBody = ConvertTo-Json @{
        name        = $playlistName
        description = $description
        public      = $false
    }
    
    $playlistURL = "https://api.spotify.com/v1/playlists/" + $playlistId
    Invoke-RestMethod -uri $playlistURL -Method Put -ContentType "application/json" -Headers $headers -Body $requestBody 

}

