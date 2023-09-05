class PuppetLint::Checks
  def load_data(path, content)
    lexer = PuppetLint::Lexer.new
    PuppetLint::Data.path = path
    begin
      PuppetLint::Data.manifest_lines = content.split("\n", -1)
      PuppetLint::Data.tokens = lexer.tokenise(content)
      PuppetLint::Data.parse_control_comments
    rescue
      PuppetLint::Data.tokens = []
    end
  end
end

PuppetLint.new_check(:ghostbuster_hiera_variables) do

  def regexprs
    hiera_yaml_file = ENV['HIERA_YAML_PATH'] || '/etc/puppetlabs/code/hiera.yaml'
    hiera = YAML.load_file(hiera_yaml_file)
    regs = {}
    hiera[:hierarchy].each do |hierarchy|
      regex = hierarchy.gsub(/%\{(::)?(trusted|server_facts|facts)\.[^\}]+\}/, "(.+)").gsub(/%\{[^\}]+\}/, ".+")
      facts = hierarchy.match(regex).captures.map { |f| f[/%{(::)?(trusted|server_facts|facts)\.(.+)}/, 3] }
      regs[regex] = facts
    end
    regs
  end

  def check
    datadir = YAML.load_file(ENV['HIERA_YAML_PATH'])[:yaml][:datadir]
    return if path.match(%r{#{datadir}/.*\.yaml}).nil?

    puppetdb = PuppetGhostbuster::PuppetDB.new
    _path = path.gsub("#{datadir}/", "")

    regexprs.each do |k, v|
      m = _path.match(Regexp.new "#{k}\.yaml")
      next if m.nil?
      return if m.captures.size == 0

      YAML.load_file(path).each do |k1, v1|
        title = k1.split('::')[0..-2].map(&:capitalize).join('::')

        if m.captures.size > 1
          i = 0
          query = [:'and']
          m.captures.map do |value|
            if v[i] == 'certname'
              query << [:'=', v[i], value]
            else
              query << [:'=', ['fact', v[i]], value]
            end
            i += 1
          end
          query = [:'and', [:'and', query, [:'=', 'type', 'Class']], [:'=', 'title', title]]
        else
          if v[0] == 'certname'
            query = [:'=', 'certname', m.captures[0]]
          else
            query = [:'=', ['fact', v[0]], m.captures[0]]
          end
          query = [:'and', [:'and', query, [:'=', 'type', 'Class']], [:'=', 'title', title]]
        end

        next if puppetdb.client.request('resources', query).data.size > 0
        notify :warning, {
          :message => "Hiera Variable #{k1} in #{_path} seems unused",
          :line    => 1,
          :column  => 1,
        }
      end
    end
  end
end
