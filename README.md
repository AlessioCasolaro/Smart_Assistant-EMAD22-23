# EMAD2022_23-Gruppo4

## To make the project work you need to fix a bug:
### _File:_ sound_stream.kt

_at:_ FLUTTER_DIR/.pub-cache/hosted/pub.dartlang.org/sound-stream-0.3.0/android/src/main/kotlin/vn/casperpas/sound_stream
``` Kotlin
(Row: 182) replace the entire line with this:
     override public fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
```