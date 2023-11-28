$librariesToCheck = @{
    "org.springframework.boot:spring-boot" = "3.1.4"
    "org.springframework:spring-core" = "6.0.12"
}


function CheckLibraryUpdate($library, $currentVersion) {
    $groupId, $artifactId = $library.Split(":")
    
    $url = $url = "https://search.maven.org/solrsearch/select?q=g:$($groupId)%20a:$($artifactId)&start=0&rows=20"
    $response = Invoke-RestMethod -Uri $url -Method Get     

    $latestVersion = $response.response.docs[0].latestVersion

    $imagePath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "mvnlogo.jpg")    
    
    if ($latestVersion -ne $currentVersion) {        
        $ToastHeader = New-BTHeader -Id '001' -Title "Atualização disponível: $groupId.$artifactId"
        $notificationMessage = "Nova versão: $latestVersion"        
        New-BurntToastNotification -AppLogo $imagePath -Text $notificationMessage -Header $ToastHeader
    }
}


foreach ($library in $librariesToCheck.Keys) {
    $currentVersion = $librariesToCheck[$library]
    CheckLibraryUpdate $library $currentVersion
}
