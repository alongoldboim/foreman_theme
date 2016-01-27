# ForemanTheme

This is a plugin that enables building a theme for Foreman.
It knows to inject its assets before the core ones, so
if an asset with the same name exists both in core and
in the plugin - plugin's one will be used.
This concept allows us to replace images, javascript files and
css files completely.

## Installation

* [Install Foreman from source](http://theforeman.org/manuals/1.10/index.html#3.4InstallFromSource)
* `cd foreman`
* `echo "gem 'foreman_theme', :path => 'path_to/foreman_theme'" >> ./bundler.d/Gemfile.local.rb`
* run `bundle install` (if you're on CentOS or Debian this command may need to change to `scl enable tfm 'bundle install'` or otherwise. See [the manual](http://theforeman.org/manuals/1.10/index.html#3.3.2SoftwareCollections) for more info. This appliues to any command you run related to TheForeman)
* In case the *deface* gem is not installed yet: 
  * run `gem install deface`
  * run again `bundle install` within the foreman main folder

*Important Notes*: 

1. In case your foreman isn't located under /usr/share (i.e., the package's installation default location) make a symbolic link from your foreman `ln -s *foreman_dir_location* /usr/share/foreman`
2. If you run TheForeman in production mode then, to see the changes you apply via foreman_theme effectively loaded by TheForeman, you need to manually recompile the assets by running `rake assets:precompile` and then restart your instance of TheForeman (`./script/rails s -e production`) .
 
For more info see [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin).


## Usage

By creating a new file with the same name in the theme plugin you will override the original file completely,
If you wish to override just part of the asset you will need to include the original files in the following way:

#####For scss/css

* Create a file with the changes you want to apply to the stylesheet, under `forman_theme/app/assets/stylesheets`.
* On top of the new file add `@import <path>/*filename` (if installed from packages, then <path> would be equal to /usr/share/foreman/app/assets/stylesheets).

*Important note* : add `//=include_foreman stylesheets/*filename` If the core file includes a sprockets //=require*.

#####For javascripts

* Create a file with the changes you want to apply to the stylesheet, under `forman_theme/app/assets/javascripts`.
* On top of the new file add `//=include_foreman javascripts/*filename`.

#####For images

- Add an image file under `foreman_theme/assets/images` with the same name as the image you want to override.

## Create your own

You can create your own theme by cloning the project and then use `./rename.rb foreman_theme_foo` from the project dir,
do your magic and then upload the completed theme template to github.


## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) *year* *your name*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

