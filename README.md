# tex-input.kak 

###### [Documentation] | [Source]

[Source]: rc/tex-input.kak 
[Documentation]: #documentation 

Provides a very simple input method similar to Emacs' TeX input method (used in the agda-mode, for example) for [Kakoune].

[Kakoune]: https://kakoune.org

## Dependencies

This extension makes use of perl 5 internally, so you have to have `perl` in your `$PATH` for it to work.

## Installation

### With [plug.kak]

```sh
plug "mesabloo/tex-input.kak" config {
  tex-input-setup
}
```

### Without [plug.kak]

[plug.kak]: https://github.com/andreyorst/plug.kak

Add `rc/tex-input.kak` to your autoloads or `source` it from your `kakrc`, and call `tex-input-setup` in your `kakrc`.

## Documentation 

### Toggling the input method 

- `tex-input-enable` and `tex-input-disable` respectively enable or disable the LaTeX input method in the *current* buffer.
- `tex-input-toggle` toggles on/off the LaTeX input method in the *current* buffer.
  This can be mapped to a user mode for example like this:
  ```sh
  map global user t ': tex-input-toggle<ret>'
  ```

### Setting additional LaTeX commands 

You can extend the dictionary of available LaTeX by passing additional parameters to the `tex-input-setup`.
Those parameters must be of the form `"<latex command>:<unicode character>"` for them to work.

For example, one may call `tex-input-setup "%:%"` to add `\%` to the list of recognized commands.

Both literal `:` and `\` need to be escaped when binding a new latex command.
For example, `/\\:∧` is a valid specification, while `/\:∧` is not.
