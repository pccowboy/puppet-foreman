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
      command => "RAILS_ENV=production /usr/bin/rake db:migrate",
      cwd => $foreman::params::app_root,
      require => Package["foreman"],
    }
  
}
