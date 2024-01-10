#
# Cookbook:: imagery
# Recipe:: tiler
#
# Copyright:: 2023, OpenStreetMap Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "imagery"
include_recipe "podman"

# FIXME: until upstream supports arm64 images: https://github.com/developmentseed/titiler/pull/740
container_image = if arm?
                    "ghcr.io/firefishy/titiler:latest"
                  else
                    "ghcr.io/developmentseed/titiler:latest"
                  end

podman_service "titiler" do
  description "Container service for titiler"
  image container_image
  ports 8080 => 8080
  environment :PORT => 8080, :WORKERS_PER_CORE => "1.5", :GDAL_INGESTED_BYTES_AT_OPEN => 32768, :GDAL_DISABLE_READDIR_ON_OPEN => "EMPTY_DIR", :GDAL_HTTP_MERGE_CONSECUTIVE_RANGES => "YES", :GDAL_HTTP_MULTIPLEX => "YES", :GDAL_HTTP_VERSION => 2, :TITILER_API_ROOT_PATH => "/api/v1/titiler", :FORWARDED_ALLOW_IPS => "*"
end

ssl_certificate "tiler.openstreetmap.org" do
  domains "tiler.openstreetmap.org"
  notifies :reload, "service[nginx]"
end

nginx_site "tiler.openstreetmap.org" do
  template "nginx_titiler.conf.erb"
  variables :aliases => ["tiler.osm.org"]
end
