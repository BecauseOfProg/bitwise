# Bitwise permission
[![Build Status](https://api.travis-ci.org/Whaxion/bitwise.svg?branch=master)](https://travis-ci.org/Whaxion/bitwise)

A bitwise permission library

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  bitwise:
    github: Whaxion/bitwise
```

## Usage

Better explained by example

```crystal
require "bitwise"

class Permissions < Bitwise::Permissions
  READ = 0
  WRITE = 1
  EDIT = 2
  DELETE = 3
end

perms = Permissions.new(Permissions::READ, Permissions::WRITE)

perms.has_perm Permissions::READ # true
perms.has_perm Permissions::DELETE # false

perms.to_i # 3 (bitwise value, easier to store)

perms2 = Permission.new(3)
perms2.to_a # [0, 1]
```

## Contributing

1. Fork it (<https://github.com/Whaxion/bitwise/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Whaxion](https://github.com/Whaxion) - creator, maintainer
