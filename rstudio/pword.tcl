set users {
	sabrina
	molly
	matthew
	yas
	brittanie
	kathleen
	prithila
	ashley
	amanda
	ben
	ryan
	kyle
	matt
}
set i 1001
foreach user $users {
	set salt [exec head -c 3 /dev/urandom | base64]
	set pword [exec head -c 12 /dev/urandom | base64]
	set crypt [exec openssl passwd -6 -salt $salt $pword]
	puts stderr "$user:$pword"
	puts "RUN useradd -l -m -s /bin/bash -N -u $i $user -p '$crypt'"
	incr i
}
