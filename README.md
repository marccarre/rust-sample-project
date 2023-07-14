# rust-sample-project

A cloud-native Rust sample project leveraging containers for build & runtime.

## Dependencies

### Locally

- [`rustup`][rustup]
- [`brew`][brew]
- [`just`][just]

## Pro-tips

- If you care about binary size, use [`cargo bloat`][cargo-bloat] to identify
  large crates, and finding smaller alternatives.

[brew]: https://brew.sh/
[cargo-bloat]: https://github.com/RazrFalcon/cargo-bloat
[just]: https://github.com/casey/just
[rustup]: https://rustup.rs/
