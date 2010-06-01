" always a preferable option
syntax on

" remove trailing whitespaces etc
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" When you’re in visual mode (that is, you have text selected), hitting D will duplicate whatever’s selected directly below.
vmap D y'>p

" RAILS-SPECIFIC (with rails.vim)
" Edit routes
command! Rroutes :Redit config/routes.rb
command! RTroutes :RTedit config/routes.rb

" Edit factories
command! Rfactories :Redit test/factories.rb
command! RTfactories :RTedit test/factories.rb

" test helper
command! Rtesthelper :Redit test/test_helper.rb

" apparently needed to activate plugin cucumber
filetype plugin indent on
