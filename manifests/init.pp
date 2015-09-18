# This is a placeholder class.
class rdot(
    $user      = $::boxen_user,
    $password  = undef,
    $branches  = undef,
    $group     = 'staff',
    $files_url = 'https://sharkcage.solium.com/vagrant-files',
    $svn_host  = 'https://svn.solium.com/svn/shareworks/branches/',
  ) {
  include boxen::config
  require homebrew
  include java7
  include git
  include iterm2::dev
  include iterm2::colors::solarized_dark
  include hipchat
  include vagrant

  ## Variables
  $home = "/Users/${user}"

## Homebrew packages
  $homebrew_packages = [ 'coreutils','renameutils' ]
  package { $homebrew_packages:
    ensure => 'installed'
  }

  ## Vagrant plugins
  vagrant::plugin { 'omnibus': }

  class { 'rdot::jenv':
    user  => $user,
    home  => $home,
  }

  class { 'rdot::java6':
    source => "${files_url}/JavaForOSX2014-001.dmg"
  }

  class { 'rdot::java7':
    source => "${files_url}/JavaForOSX2014-001.dmg"
  }

  class { 'rdot::sqldeveloper':
    version  => '4.0.3.16.84',
    user     => $user,
    group    => $group,
    host     => $files_url
  }

  class { 'rdot::bashcompletion': }
  class { 'rdot::tnsnames':
    version  => '0.0.1',
    host     => $files_url,
  }

  class { 'ant':
    version       => '1.9.4',
    homebrew_root => $boxen::config::homebrewdir,
  }

  class { 'rdot::bash_profile':
    user    => $user,
    group   => $group,
    home    => $home,
  }

  ## Define strict dependency ordering here
  Class['jenv']
  -> Class['rdot::java6']
  -> Class['rdot::java7']

  Package['jenv']
  -> Package['ant']
  -> Exec['install jenv ant plugin']
}
