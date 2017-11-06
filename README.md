# vim-shiny

A plugin goal is effective highlight, like as [atom-vim-mode-plus](https://github.com/t9md/atom-vim-mode-plus).

![Demo movie](./.github/demo.gif)

> with vim-operator-flashy

## Inspired

- [vim-operator-flashy](https://github.com/haya14busa/vim-operator-flashy)
- [atom-vim-mode-plus](https://github.com/t9md/atom-vim-mode-plus)

Special Thanks!

## Usage

```vim
nmap p  <Plug>(shiny-p)
nmap P  <Plug>(shiny-P)
nmap gp <Plug>(shiny-gp)
nmap gP <Plug>(shiny-gP)
```

## TODO

- paste `*1`
  - [x] p  `<Plug>(shiny-p)`
  - [x] P  `<Plug>(shiny-P)`
  - [x] gp `<Plug>(shiny-gp)`
  - [x] gP `<Plug>(shiny-gP)`

- undo `*2`
  - [ ] u
  - [ ] U

> `*2` : Not highlight when decrease line from prev state.

- [ ] support legacy vim (for no lambda, no timer)

- [ ] dot repeat

- test
  - CI
    - [ ] win
    - [ ] mac
    - [ ] linux

- configureable
  - [ ] highlight group
  - [ ] highlight time

- [ ] document

LICENSE
---

MIT
