Set-Location -Path C:\Users\$env:UserName\AppData\LocalLow\Nolla_Games_Noita\save00
$file = "C:\Users\$env:UserName\AppData\LocalLow\Nolla_Games_Noita\save00\world_state.xml"
if (Test-Path -Path $file -PathType Leaf) {
    $new_state = Get-Content -Path $file | %{$_ -replace 'mods_have_been_active_during_this_run="1"','mods_have_been_active_during_this_run="0"'}
    Set-Content -Path $file -Value $new_state
    #$new_state = Get-Content -Path C:\Users\$env:UserName\AppData\LocalLow\Nolla_Games_Noita\save00\mod_config.xml | %{$_ -replace 'Mod enabled="1"','Mod enabled="0"'}
    #Set-Content -Path C:\Users\$env:UserName\AppData\LocalLow\Nolla_Games_Noita\save00\mod_config.xml -Value $new_state
}
git add .
Set-Location -Path C:\Users\$env:UserName\AppData\LocalLow\Nolla_Games_Noita\save00\stats\sessions
$last_session = (Get-ChildItem . | Sort-Object -Descending -Property LastWriteTime | select -First 1).name
$seed = Select-String -Path $last_session -Pattern 'world_seed="\d+"' | % {$_.Matches} | % {$_.Value} | select-object -First 1
$play_time = Select-String -Path $last_session -Pattern 'playtime_Str=".*?"' | % {$_.Matches} | % {$_.Value} | select-object -First 1
$date = get-date -Format 'yyyyMMddHHmm'
$message = "$date $seed $play_time".Replace("str", "").Replace("=", ": ").Replace('"', "").Replace("_", " ")
git commit -am $message -v