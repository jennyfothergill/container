package require fileutil::traverse
package require sqlite3

set root [lindex $argv 0]
set dbfile [lindex $argv 1]

set root [file normalize $root]
sqlite3 db $dbfile

db eval {
	CREATE TABLE IF NOT EXISTS megadetector(
		directory TEXT,
		payload JSON
	);
	PRAGMA journal_mode=off;
	PRAGMA synchronous=off;
	BEGIN TRANSACTION;
}

puts "traversing $root..."
fileutil::traverse walk $root
while {[walk next entry]} {
	if {![file isdirectory $entry]} {
		continue
	}
	puts "visiting $entry..."
	set mdj [file join $entry megadetector.json]
	if {[file exists $mdj]} {
		puts "found megadetector file: $mdj"
		set fin [open [file join $entry megadetector.json]]
		set payload [read $fin]
		close $fin
		db eval {
			INSERT OR REPLACE INTO megadetector VALUES(:entry, :payload);
		}
	}
}

db eval {
	COMMIT TRANSACTION;
}

db close

exit 0;

sqlite3 db [lindex $argv 1]

db eval {
	CREATE TABLE IF NOT EXISTS megadetections(filename TEXT NOT NULL, confidence REAL, bbox JSON DEFAULT NULL, tags JSON DEFAULT NULL);
}

db eval "
  WITH images AS (
    SELECT value->'file' AS filename, value->'detections' AS detections
    FROM json_each('$payload','$.images')
  ),
  detections AS (
    SELECT '$path' || filename,
    	value->'category' AS category,
      value->'conf' AS conf,
      value->'bbox' AS bbox
    FROM images, json_each(images.detections)
  )
  SELECT * FROM detections;
" row {
  parray row
}



db close
