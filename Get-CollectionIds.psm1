function Get-CollectionIds {
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]
    $Id = "",
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]
    $Output = ""
  )

  $WorkshopCollectionURL = "https://steamcommunity.com/sharedfiles/filedetails/?id=" + $Id

  $modList = $Output

  $ProgressPreference = 'SilentlyContinue'
  $getPage = Invoke-WebRequest -Uri $WorkshopCollectionURL
  $ProgressPreference = 'Continue'
  $modIdCollection = @()
  $Links = $getPage.Links
  foreach ($link in $Links) {
    if ($link.outerHTML -like "*workshopItemTitle*") {
      $modID = $link.href.Replace('https://steamcommunity.com/sharedfiles/filedetails/?id=','')
      if($modIDCollection -notcontains $modID) {
        $desc = $link.outerHTML -replace '\<a\shref=\"https:\/\/steamcommunity.com\/sharedfiles\/filedetails\/\?id\=.*"\>\<div class="workshopItemTitle"\>', ""
        $desc = $desc.Replace('</div></a>','');
        if ($modList -ne "echo") {
          Write-Host "Found Mod: $desc"
        }
        $modIDCollection += $modID
      }
    }
  }
  if ($modList -ne "echo") {
    if (Test-Path $modList) {
      del $modList
    }
    Set-Content -Path $modList $modIDCollection
    Write-Host "Your mod list is at: $modList"
  } else {
    Write-Host $modIDCollection
  }
}

Export-ModuleMember -Function Get-CollectionIds
