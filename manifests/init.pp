# This is a placeholder class.
class solium(
    $user      = $::boxen_user,
    $password  = undef,
    $branches  = undef,
    $group     = 'staff',
    $files_url = 'http://sharkcage.solium.com/vagrant-files',
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
  vagrant::plugin { 'berkshelf': } # Resolves to vagrant-berkshelf
  vagrant::plugin { 'omnibus': }

  class { 'solium::jenv':
    user  => $user,
    home  => $home,
  }

  class { 'solium::java6':
    source => "${files_url}/JavaForOSX2014-001.dmg"
  }

  class { 'solium::sqldeveloper':
    version  => '4.0.3.16.84',
    user     => $user,
    group    => $group,
    host     => $files_url
  }

  class { 'solium::bashcompletion': }
  class { 'solium::tnsnames':
    version  => '0.0.1',
    host     => $files_url,
  }

  class { 'ant':
    version       => '1.9.4',
    homebrew_root => $boxen::config::homebrewdir,
  }

  class { 'solium::bash_profile':
    user    => $user,
    group   => $group,
    home    => $home,
  }

  ## Define strict dependency ordering here
  Class['jenv']
  -> Class['solium::java6']
  -> Class['solium::java7']

  Package['jenv']
  -> Package['ant']
  -> Exec['install jenv ant plugin']
}
