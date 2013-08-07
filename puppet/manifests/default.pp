# Puppet manifest

include rvm

rvm_system_ruby {
  '1.9.3':
    ensure => 'present',
    default_use => true;
}

rvm_gemset {
  '1.9.3@myopicvicar':
    ensure => present,
    require => Rvm_system_ruby['1.9.3'];
}

