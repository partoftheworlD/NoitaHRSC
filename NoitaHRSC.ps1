function Disable-Mods {
    $file = "C:\Users\$env:UserName\AppData\LocalLow\Nolla_Games_Noita\save00\world_state.xml"
    if (Test-Path -Path $file -PathType Leaf) {
        $new_state = Get-Content -Path $file | ForEach-Object { $_ -replace 'mods_have_been_active_during_this_run="1"', 'mods_have_been_active_during_this_run="0"' }
        Set-Content -Path $file -Value $new_state
    }
}

function Generate-Message {
    Set-Location -Path C:\Users\$env:UserName\AppData\LocalLow\Nolla_Games_Noita\save00\stats\sessions
    $last_session = (Get-ChildItem . | Sort-Object -Descending -Property LastWriteTime | Select-Object -First 1).name
    $seed = Select-String -Path $last_session -Pattern 'world_seed="\d+"' | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } | select-object -First 1
    $play_time = Select-String -Path $last_session -Pattern 'playtime_Str=".*?"' | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } | select-object -First 1
    $message = "$seed $play_time".Replace("str", "").Replace("=", ": ").Replace('"', "").Replace("_", " ").Replace(" : ", ": ")
    return $message
}

function cd-save00 {
    Set-Location -Path C:\Users\$env:UserName\AppData\LocalLow\Nolla_Games_Noita\save00
}

Disable-Mods
cd-save00
git add .
git commit -v -am $(Generate-Message)
git push -f
