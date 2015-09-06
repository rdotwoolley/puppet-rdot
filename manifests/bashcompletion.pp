# Installs bash-completion
class rdot::bashcompletion {

  package { 'bash-completion':
    ensure      => latest
  }

}
