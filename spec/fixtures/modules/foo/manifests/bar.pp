class foo::bar(
  $baz,
) {
  file { 'used_with_file':
    content => file('foo/used_with_file'),
  }
  file { 'used_with_file_and_module_name':
    content => file("${module_name}/used_with_file_and_module_name"),
  }
  file { 'used_with_template':
    content => template('foo/used_with_template'),
  }
  file { 'used_with_template_and_module_name':
    content => template("${module_name}/used_with_template_and_module_name"),
  }
  if $::bar {
    $foo = "Hello ${::foo}"
  }
  $foo = bar('baz')
  bar { 'bar': }
  file { 'quux':
    content => inline_template('<%= @quux %>'),
  }
}
