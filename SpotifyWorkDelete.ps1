$token = "BQDqLtanBx2r-a_K-zNmiMhvRqTy7UBu3U5lPtJMBT3quINfOV2ucI9r_qixaNMSczrXZAMX6eeLZbwlq6L2QAU9WSWWzC_ZVmKCCmUuclrEfSCSKj-r7N2UcHk46Fbmmaf6JCVXCRmncJ469E6VC_QnhjuI-aSfIYKnKnPRLyYfkP_iMSlo-bpBs4RwdR08ZllBisxPY79ym2B-VlqgtmRPdwyxLanTBvmLv3rxtFDI5psPOGYB1T9jceq88Cuw-sxzCGJ6UlqqFsodjJxeLe763bdOe2Ltrl0JUrya"

$headers = @{
    Authorization = "Bearer " + $token
    
}


$requestBody = @'
    {
  "tracks": [
    {
      "uri": "spotify:track:2DB2zVP1LVu6jjyrvqD44z",
      "positions": [
        0
      ]
    },
    {
      "uri": "spotify:track:5ejwTEOCsaDEjvhZTcU6lg",
      "positions": [
        1
      ]
    }
  ]
} 
'@

$requestBody | ConvertTo-Json

$searchEndPoint = "https://api.spotify.com/v1/search?q="

$searchPlaylist = Read-Host "What playlist do you want to add a song too?"
    $searchedPlaylistEndpoint = $searchEndPoint + $searchPlaylist + "&type=playlist"

    $responsePlaylistSearch = Invoke-RestMethod -uri $searchedPlaylistEndpoint -Method Get -ContentType "application/json" -Headers $headers

    #gets users id
    $playlistItems = $responsePlaylistSearch.playlists.items
    $ownerID = ""


    ForEach ($item in $playlistItems.owner.id) {
        if ($item -eq $clientUsername){
           $ownerID = $item
           break
        }
    }  
    
    $userplaylistList = "https://api.spotify.com/v1/users/" + $ownerID + "/playlists"
    $getplaylistList = Invoke-RestMethod -uri $userplaylistList -Method Get -ContentType "application/json" -headers $headers
    $playlistId = ""

    ForEach($value in $getplaylistList.items){
        if ($value.name -eq $searchPlaylist){
            $playlistId = $value.id
            break
        }
    }


$deleteTrackEndpoint = "https://api.spotify.com/v1/playlists/" + $PlaylistId + "/tracks"

$deleteTrack = Invoke-RestMethod -uri $deleteTrackEndpoint -Method Delete -ContentType "application/json" -body $requestBody -Headers $headers
