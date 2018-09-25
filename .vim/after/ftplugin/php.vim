
" F3-key adds an array-association arrow, with spaces on either side of it:
inoremap <buffer> <F3> => <C-o>:s/\([^ ]\)=>/\1 =>/e<Return><End>
" F4-key adds a dollar-sign:
inoremap <buffer> <F4> $
nnoremap <buffer> <expr> <F4> ToInsertBeforeCurrentChar('$')
" F6-key adds '$this->':
inoremap <buffer> <F6> $this->
" altA adds either "array()" or "['']", depending on context:
inoremap <buffer> <expr> <A-a> ArrayHelp()
inoremap <buffer> <expr> # DrupalFormKey("'")

" Insert the comment leader when pressing <Enter> from Insert mode:
setlocal formatoptions+=r
" This is most helpful for PHP's long '/*' doc comments.

" The below string is taken from ~/.vim/indent/php.vim. While it's correct
" there, certain combinations of options/extensions can screw with
" include-order, which causes the string to get overridden. Solution for now
" is just to set this here and not do `filetype indent on`
setlocal comments=s1:/*,mb:*,ex:*/,://,:#

function! UnmapI()
	iunmap <Tab>
endfunction

" Given a sequence of (insert-mode) keystrokes designed to move the cursor to
" the next useful spot for input, append the strokes needed to un-bind the tab
" key from this very navigation.
"
" Note that special characters for `returnSeqeunece` should not have leading
" backslashes e.g. if you want for the End-key to be pressed it should be
" "<End>" not "\<End>"
"
function! GetTabUnsetHack(returnSequence)
	return "\<C-o>:inoremap <Tab> " . a:returnSequence . '<C-o>:call UnmapI()<Return>' . "\<Return>"
	" ^ TODO: in case <Tab> is ever mapped over to something in Insert mode,
	" this should actually restore the mapping, rather than just unsetting it.
endfunction

function! DrupalFormKey(quoteChar)
	let key = input("Key name? ")
	let rval = "'#" . escape(key,"'") . "' => " . a:quoteChar
	if a:quoteChar != ''
		let rval = rval . a:quoteChar . ",\<Left>\<Left>"
	else
		let rval = rval . ",\<Left>"
	endif
	let rval = rval . GetTabUnsetHack("<End>")
	return rval
endfunction

function! ArrayHelp()
	let c = GetCharFromCursor(-1)
	if col('.') == 1 || match(c,'\v[\t (,]') == 0
		return "array()\<Left>"
	else
		return "['']\<Left>\<Left>" . GetTabUnsetHack('<Right><Right>')
	endif
endfunction
