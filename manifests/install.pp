class foreman::install {
  include foreman::install::repos

  case $::operatingsystem {
    Debian,Ubuntu:  {
      package {'foreman-sqlite3':
        ensure  => latest,
        require => Class['foreman::install::repos'],
        notify  => [Class['foreman::service'],
                    Package['foreman']],
      }
    }
    default: {}
  }

  package {'foreman':
    ensure  => latest,
    require => Class['foreman::install::repos'],
    notify  => Class['foreman::service'],
  }
  
  exec{"db-migrate":
      command => "/usr/bin/rake RAILS_ENV=production db:migrate",
      cwd => $foreman::params::app_root,
      require => Package["foreman"],
      require => Service["puppet", ensure => running],
    }
  
}
