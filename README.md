<div align="center">
  <h1>Bitwise permission</h1>
  <h3>A bitwise permission library in Crystal</h3>
  <a href="https://circleci.com/gh/BecauseOfProg/bitwise">
    <img src="https://circleci.com/gh/BecauseOfProg/bitwise.svg?style=svg" alt="Build status" />
  </a>
</div>

- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [Credits](#credits)
- [License](#license)

## Installation

Add the dependency to your application's `shard.yml`:

```yaml
dependencies:
  bitwise:
    github: BecauseOfProg/bitwise
```

## Usage
Documentation <a href="https://becauseofprog.github.io/bitwise/">here</a>
More examples in the documentation

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

perms.add_perm Permissions::DELETE
perms.has_perm Permissions::DELETE # true

perms.del_perm Permissions::DELETE
perms.has_perm Permissions::DELETE # false

perms.to_i #=> 3 | (bitwise value, easier to store)

perms2 = Permission.new(3)
perms2.to_a #=> [0, 1] | (READ, WRITE)

# More examples in the documentation
```

## Contributing

1. Fork the repository (<https://github.com/BecauseOfProg/bitwise/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new [Pull Request](https://github.com/BecauseOfProg/bitwise/pulls?q=is%3Apr+is%3Aopen+sort%3Aupdated-desc)

## Credits

- Maintainer : [Whaxion](https://github.com/Whaxion)

## License

The MIT License (MIT)

Copyright (c) 2019 Whaxion

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
