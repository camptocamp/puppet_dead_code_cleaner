require 'puppet-ghostbuster/puppetdb'
require 'puppet-ghostbuster/util'

class PuppetLint::Checks
  def load_data(path, content)
    lexer = PuppetLint::Lexer.new
    PuppetLint::Data.path = path
    begin
      PuppetLint::Data.manifest_lines = content.split("\n", -1)
      PuppetLint::Data.tokens = lexer.tokenise(content)
      PuppetLint::Data.parse_control_comments
    rescue StandardError
      PuppetLint::Data.tokens = []
    end
  end
end

PuppetLint.new_check(:ghostbuster_files) do
  def manifests
    Dir.glob('./**/manifests/**/*.pp')
  end

  def check
    m = path.match(%r{.*/([^/]+)/files/(.+)$})
    return if m.nil?

    puppetdb = PuppetGhostbuster::PuppetDB.new

    module_name, file_name = m.captures
    query = "resources[title] { parameters.source = 'puppet:///modules/#{module_name}/#{file_name}' and nodes { deactivated is null } }"
    return if puppetdb.client.request('', query).data.size > 0

    dir_name = File.dirname(file_name)
    while dir_name != '.'
      query = "resources[title] {
        (parameters.source = 'puppet:///modules/#{module_name}/#{dir_name}'
         or parameters.source = 'puppet:///modules/#{module_name}/#{dir_name}/')
        and (parameters.recurse = true or parameters.recurse = 'remote')
        and nodes { deactivated is null } }"
      return if puppetdb.client.request('', query).data.size > 0

      dir_name = File.dirname(dir_name)
    end

    manifests.each do |manifest|
      return if PuppetGhostbuster::Util.search_file(manifest, %r{["']#{module_name}/#{file_name}["']})

      if (match = manifest.match(%r{.*/([^/]+)/manifests/.+$})) && (match.captures[0] == module_name) && PuppetGhostbuster::Util.search_file(manifest, %r{["']\$\{module_name\}/#{file_name}["']})
        return
      end
    end

    notify :warning, {
      message: "File #{module_name}/#{file_name} seems unused",
      line: 1,
      column: 1,
    }
  end
end
