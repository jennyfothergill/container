package require sqlite3

sqlite3 db {}

set v [db eval {SELECT sqlite_version()}]
puts "sqlite_version: $v"

# load builtin extensions
db enable_load_extension 1
foreach ext {
  btreeinfo carray completion
  compress csv decimal explain
  shathree spellfix sqlar uuid } {
  puts -nonewline "loading $ext... "
  set v [db eval "SELECT load_extension('$ext');"]
  puts ok
}

db eval {SELECT load_extension('mod_spatialite')}
set v [db eval {SELECT spatialite_version(), spatialite_target_cpu()}]
puts "spatialite_version: $v"
set v [db eval {SELECT geos_version()}]
puts "geos_version: $v"
set v [db eval {SELECT proj_version()}]
puts "proj_version: $v"

db close
