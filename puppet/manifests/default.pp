# Puppet manifest

# put this somewhere global, like site.pp
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

$vagrantdir = "/home/vagrant"
$myopicdir = "${vagrantdir}/MyopicVicar"

include rvm

rvm_system_ruby {
  "1.9.3":
    ensure => "present",
    default_use => false;
}

rvm_gemset {
  "1.9.3@myopicvicar":
    ensure => present,
    require => Rvm_system_ruby["1.9.3"];
}

# Give the vagrant user permission to use rvm
user { "vagrant": }
rvm::system_user { vagrant: }

# Ensure git and mongodb are installed
package { "git": 
  ensure => present
}
package { "mongodb-server":
  ensure => present
}
package { "libmagickwand-dev":
  ensure => present
}

# Checkout MyopicVicar git repo
exec { "git-clone":
  command => "git clone https://github.com/FreeUKGen/MyopicVicar.git",
  cwd => $vagrantdir,
  creates => $myopicdir,
  require => Package["git"],
  user => vagrant
}

# Create rvm config for MyopicVicar project
exec { "rvm-config":
  command => "echo 'rvm use 1.9.3@myopicvicar' > .rvmrc",
  cwd => $myopicdir,
  require => Exec['git-clone'],
  creates => "${myopicdir}/.rvmrc",
  user => vagrant
}

# Force https instead of git
file { "gitconfig":
  path => "${vagrantdir}/.gitconfig",
  owner => vagrant,
  group => vagrant,
  ensure => file,
  source => "/vagrant/puppet/files/.gitconfig"
}
