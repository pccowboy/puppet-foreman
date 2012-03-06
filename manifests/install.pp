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
  
  service { "puppet":
  	enable 	=> true,
  	ensure 	=> running,
  	name 	=> "puppet",
  	require => Package["puppet"],
  }
  
  service { "puppetmaster":
  	enable 	=> true,
  	ensure 	=> running,
  	name 	=> "puppetmaster",
  	require => Package["puppet"],
  }
  
  exec{"db-migrate":
      command => "/usr/bin/rake RAILS_ENV=production db:migrate",
      cwd => $foreman::params::app_root,
      require => [Package["foreman"],
                  Service["puppet", ensure => running],
                  Service["puppetmaster", ensure => running],
                 ],
    }
  
}
