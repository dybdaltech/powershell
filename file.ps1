$a = $true
if ($a -eq $true) {
    Add-Type -AssemblyName System.Speech
     $SpeechSynth = New-Object System.Speech.Synthesis.SpeechSynthesizer
     $CatFact = (ConvertFrom-Json (Invoke-WebRequest -Uri 'https://catfact.ninja/fact')).fact
     $SpeechSynth.Speak("did you know?")
    $SpeechSynth.Speak($CatFact)
 }   