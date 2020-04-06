name "gackelchen"
description "Master role applied to gackelchen"

default_attributes(
  :hardware => {
    :shm_size => "24g"
  },
  :networking => {
    :interfaces => {
      :external_ipv4 => {
        :interface => "eth0",
        :role => :external,
        :family => :inet,
        :address => "46.226.108.71",
        :prefix => "22",
        :gateway => "46.226.111.254",
      },
      :external_ipv6 => {
        :interface => "eth0",
        :role => :external,
        :family => :inet6,
        :address => "2001:4b98:dc2:41:216:3eff:fe62:924c",
        :prefix => "64",
        :gateway => "fe80::1"
      }
    }
  },
  :squid => {
    :version => 4,
    :cache_mem => "20480 MB",
    :cache_dir => [
      "rock /store/squid/rock-4096 20000 swap-timeout=200 slot-size=4096 max-size=3996",
      "rock /store/squid/rock-8192 25000 swap-timeout=200 slot-size=8192 min-size=3997 max-size=8092",
      "rock /store/squid/rock-16384 35000 swap-timeout=200 slot-size=16384 min-size=8093 max-size=16284",
      "rock /store/squid/rock-32768 45000 swap-timeout=200 slot-size=32768 min-size=16285 max-size=262144"
    ]
  },
  :tilecache => {
    :tile_parent => "bissen.render.openstreetmap.org"
  }
)

run_list(
  "role[gandi]",
  "role[tilecache]"
)
