--INFO: https://github.com/mg979/vim-visual-multi
return {
	"mg979/vim-visual-multi",
    cond = true,
	branch = "master",
	config = function()
		vim.cmd([[
        let g:VM_default_mappings = 1
        let g:VM_leader = '\'
        nmap         <C-LeftMouse>                <Plug>(VM-Mouse-Cursor) 
        nmap         <C-RightMouse>               <Plug>(VM-Mouse-Word) 
        nmap         <M-C-RightMouse>             <Plug>(VM-Mouse-Column) 


        ]])
	end,
}
