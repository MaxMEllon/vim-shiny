" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not mofidify the code nor insert new lines before '" ___vital___'
if v:version > 703 || v:version == 703 && has('patch1170')
  function! vital#_shiny#Gift#Window#import() abort
    return map({'flatten': '', 'tabpagewinnr_list': '', 'execute': '', 'close': '', 'numbering': '', 'set_prefix': '', '_vital_depends': '', 'exists': '', 'jump': '', 'setvar': '', 'bufnr': '', 'uniq_nr': '', 'make_uniq_nr': '', 'tabpagewinnr': '', 'getvar': '', '_vital_loaded': ''},  'function("s:" . v:key)')
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  execute join(['function! vital#_shiny#Gift#Window#import() abort', printf("return map({'flatten': '', 'tabpagewinnr_list': '', 'execute': '', 'close': '', 'numbering': '', 'set_prefix': '', '_vital_depends': '', 'exists': '', 'jump': '', 'setvar': '', 'bufnr': '', 'uniq_nr': '', 'make_uniq_nr': '', 'tabpagewinnr': '', 'getvar': '', '_vital_loaded': ''}, \"function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
  delfunction s:_SID
endif
" ___vital___
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V)
	let s:V = a:V
	let s:Tabpage = s:V.import("Gift.Tabpage")
endfunction


function! s:_vital_depends()
	return [
\		"Gift.Tabpage",
\	]
endfunction


let s:prefix = expand("<sfile>:p:h:h:t")
function! s:set_prefix(prefix)
	let s:prefix = a:prefix
endfunction

function! s:flatten(list)
	return eval(join(a:list, "+"))
endfunction


function! s:tabpagewinnr_list()
	return s:flatten(map(range(1, tabpagenr("$")), "map(range(1, tabpagewinnr(v:val, '$')), '['.v:val.', v:val]')"))
endfunction


if !exists("s:uniq_counter")
	let s:uniq_counter = 0
endif
function! s:make_uniq_nr()
	let s:uniq_counter += 1
	return s:uniq_counter
endfunction


function! s:numbering(...)
	let winnr = get(a:, 1, winnr())
	let tabnr = get(a:, 2, tabpagenr())
	let uniq_nr = s:make_uniq_nr()
	call settabwinvar(tabnr, winnr, s:prefix . "_gift_uniq_winnr", uniq_nr)
	return uniq_nr
endfunction


function! s:uniq_nr(...)
	let winnr = get(a:, 1, winnr())
	let tabnr = get(a:, 2, tabpagenr())
	let uniq_nr = get(gettabwinvar(tabnr, winnr, ""), s:prefix . "_gift_uniq_winnr", -1)
	if uniq_nr == -1
		let uniq_nr = s:numbering(winnr, tabnr)
	endif
	return uniq_nr
endfunction


function! s:exists(nr)
	let [tabnr, winnr] = s:tabpagewinnr(a:nr)
	return tabnr != 0 && winnr != 0
endfunction


function! s:tabpagewinnr(nr)
	if a:nr == 0
		return s:tabpagewinnr(s:uniq_nr())
	endif
	let tabwinnrs = s:tabpagewinnr_list()
	for [tabnr, winnr] in tabwinnrs
		if s:uniq_nr(winnr, tabnr) == a:nr
			return [tabnr, winnr]
		endif
	endfor
	return [0, 0]
endfunction


function! s:getvar(nr, varname, ...)
	let def = get(a:, 1, "")
	let [tabnr, winnr] = s:tabpagewinnr(a:nr)
	return get(gettabwinvar(tabnr, winnr, ""), a:varname, def)
endfunction


function! s:setvar(nr, varname, val)
	let [tabnr, winnr] = s:tabpagewinnr(a:nr)
	if tabnr == 0 || winnr == 0
		return
	endif
	return settabwinvar(tabnr, winnr, a:varname, a:val)
endfunction


function! s:bufnr(nr)
	let [tabnr, winnr] = s:tabpagewinnr(a:nr)
	return winnr >= 1 ? get(tabpagebuflist(tabnr), winnr-1, -1) : -1
endfunction



function! s:jump(nr)
	let [tabnr, winnr] = s:tabpagewinnr(a:nr)
	if tabnr == 0 || winnr == 0
		return -1
	endif

	execute "tabnext" tabnr
	execute winnr . "wincmd w"
endfunction


function! s:close(nr, close_cmd)
	call s:execute(a:nr, a:close_cmd)
" 	let current = gift#uniq_winnr()
" 	let result = s:jump(a:nr)
" 	if result == -1
" 		return -1
" 	endif
" 	execute a:close_cmd
" 	return s:jump(current)
endfunction


function! s:execute(nr, expr)
	let current = s:uniq_nr()
	let result = s:jump(a:nr)
	if result == -1
		return -1
	endif
	execute a:expr
	return s:jump(current)
endfunction





let &cpo = s:save_cpo
unlet s:save_cpo
