# Install sqldeveloper
class rdot::sqldeveloper( $version = '4.0.3.16.84',
                            $user    = undef,
                            $group   = undef,
                            $host    = undef) {
  validate_string($host,
                  $user,
                  $group,
                  $version)

  package { 'sqldeveloper':
    ensure   => present,
    flavor   => 'zip',
    provider => 'compressed_app',
    source   => "${host}/sqldeveloper-${version}-macosx.app.zip"
  }

  file { '/Applications/SQLDeveloper.app/.java-version':
    owner   => $user,
    group   => $group,
    content => template('rdot/sqldeveloper/.java-version.erb'),
    require => [ Package['jenv'],Package['sqldeveloper'] ],
  }
}
