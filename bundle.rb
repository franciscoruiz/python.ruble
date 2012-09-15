require 'ruble'

bundle do |bundle|
  bundle.display_name = t(:bundle_name)
  bundle.author = 'Francisco J. Ruiz Gaona'
  bundle.copyright = <<END
(c) Copyright 2012 Francisco J. Ruiz Gaona. Distributed under MIT license.
END

  bundle.description = 'Utilities for Python development with Aptana Studio'
  bundle.repository = 'git@github.com:franciscoruiz/python.ruble.git'

  # Use Commands > Bundle Development > Insert Bundle Section > Menu
  # to easily add new sections
  bundle.menu t(:bundle_name) do |menu|
    menu.command t(:silence_pylint_problems_in_current_line)
  end
end