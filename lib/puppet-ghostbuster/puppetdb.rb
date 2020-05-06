require 'puppetdb'
require 'puppet'

class PuppetGhostbuster
  class PuppetDB
    def self.client
      Puppet.initialize_settings
      @@client ||= ::PuppetDB::Client.new({
        :server => "#{ENV['PUPPETDB_URL'] || 'http://puppetdb:8080'}",
        :pem    => {
          'key'     => ENV['PUPPETDB_KEY_FILE'] || Puppet[:hostprivkey],
          'cert'    => ENV['PUPPETDB_CERT_FILE'] || Puppet[:hostcert],
          'ca_file' => ENV['PUPPETDB_CACERT_FILE'] || Puppet[:cacert],
        }
      }, 4)
    end

    def client
      self.class.client
    end

    def self.classes
      @@classes ||= client.request('', 'resources[title] { type = "Class" and nodes { deactivated is null } }').data.map { |r| r['title'] }.uniq
    end

    def classes
      self.class.classes
    end

    def self.resources
      @@resources ||= client.request('', 'resources[type] { nodes { deactivated is null } }').data.map { |r| r['type'] }.uniq
    end

    def resources
      self.class.resources
    end
  end
end
