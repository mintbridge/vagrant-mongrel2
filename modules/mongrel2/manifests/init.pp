class mongrel2 {
	include apt
	include wget
	include sqlite3
	include zeromq

	$version = "1.8.0"

	# get the source tarball from the zeroms download site
	wget::fetch { "mongrel2-source":
		source      => "https://github.com/zedshaw/mongrel2/tarball/v$version",
		destination => "/usr/local/src/mongrel2-$version.tar.gz",
		before      => Exec["untar-mongrel2-source"],
		require     => [Class['zeromq'], Package['wget']],
	}

	# make sure the tar ball exist then extract it
	exec { "untar-mongrel2-source":
		command  => "tar xvzf /usr/local/src/mongrel2-$version.tar.gz && mv /usr/local/src/zeds* /usr/local/src/mongrel2-$version/",
		cwd      => "/usr/local/src",
		path     => "/usr/bin:/usr/sbin:/bin",
		creates  => "/usr/local/src/mongrel2-$version",
		before   => Exec["install-mongrel2"]
	}

	# install
	exec { "make all install":
		alias    => "install-mongrel2",
		cwd      => "/usr/local/src/mongrel2-$version",
		path     => "/usr/bin:/usr/sbin:/bin",
	}
}
