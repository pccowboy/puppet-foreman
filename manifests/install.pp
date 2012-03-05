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
      command => "cd ${app_root} && RAILS_ENV=production rake db:migrate",
      require => Package["foreman"],
    }
  
}
