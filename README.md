# ForemanTheme

This is a plugin that enables building a theme for Foreman.
It knows to inject its assets before the core ones, so
if an asset with the same name exists both in core and
in the plugin the plugin's one will be used.
This concept allows us to replace images, javascript files and
css files completely.

## Installation

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins

## Usage

By creating a new file with the same name in the theme plugin you will override the original file completely,
If you wish to override just part of the asset you will need to include the original files.

#####For scss/css:

-At the top of the new file add `@import path/*filename` (the path is the full path to foreman, if installed from package the path will be /usr/share/foreman/app/assets/stylesheets).

*Imprtant note* : add `//=include_foreman stylesheets/*filename` If the core file includes a sprockets //=require* (no full path needed here, just stylesheets/filename).

#####For javascripts:

-At the top of the new file add `//=include_foreman javascripts/*filename`.

#####For images:

-Add a file to the assets/images with the same name as the image you want to override.

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

