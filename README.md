# EMAD2022_23-Gruppo4

## To make the project work you need to fix a Jitsi Meet SDK bug:
### _File:_ JitsiMeetPlugin.kt
_at:_ C:\<flutter dir>\.pub-cache\hosted\pub.dartlang.org\jitsi_meet-4.0.0\android\src\main\kotlin\com\gunschu\jitsi_meet (Windows)
``` Kotlin
(Row: 34)
    constructor(activity: Activity) -------> constructor(activity: Activity?) 
```