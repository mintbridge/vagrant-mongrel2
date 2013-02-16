class zeromq {
	include uuid
	include wget
	include build

	$version = "3.2.2"

	# make sure will have working local directory
	file { "/usr/local/src":
		ensure   => directory
	}

	# get the source tarball from the zeroms download site
	wget::fetch { "zeromq-source-tgz":
		source      => "http://download.zeromq.org/zeromq-$version.tar.gz",
		destination => "/usr/local/src/zeromq-$version.tar.gz",
		before      => Exec["untar-zeromq-source"],
		require     => Package['wget'],
	}

	# make sure the tar ball exist then extract it
	exec { "untar-zeromq-source":
		command  => "tar -xzvf /usr/local/src/zeromq-$version.tar.gz",
		cwd      => "/usr/local/src",
		path     => "/usr/bin:/usr/sbin:/bin",
		creates  => "/usr/local/src/zeromq-$version",
		before   => Exec["configure-zeromq"]
	}

	# configure
	exec { "configure":
		alias    => "configure-zeromq",
		command  => "/usr/local/src/zeromq-$version/configure",
		cwd      => "/usr/local/src/zeromq-$version",
		before   => Exec["make-zeromq"],
		require  => Package['build-essential'],
	}

	# make
	exec { "make":
		alias    => "make-zeromq",
		cwd      => "/usr/local/src/zeromq-$version",
		path     => "/usr/bin:/usr/sbin:/bin",
		before   => Exec["make-install-zeromq"]
	}

	# install
	exec { "make install":
		alias    => "make-install-zeromq",
		cwd      => "/usr/local/src/zeromq-$version",
		path     => "/usr/bin:/usr/sbin:/bin",
		before   => Exec["ldconfig"]
	}

	# ldconfig
	# http://www.zeromq.org/intro:get-the-software#toc3 - step 6
	exec { "ldconfig":
		command  => "sudo ldconfig",
		cwd      => "/usr/local/src/zeromq-$version",
		path     => "/usr/bin:/usr/sbin:/bin",
	}
}
