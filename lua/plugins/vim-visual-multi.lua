return {
	"mg979/vim-visual-multi",
    cond = false,
	branch = "master",
	config = function()
		vim.cmd([[
        let g:VM_default_mappings = 1
        nmap   <C-LeftMouse>         <Plug>(VM-Mouse-Cursor)
        nmap   <C-RightMouse>        <Plug>(VM-Mouse-Word)
        nmap   <M-C-RightMouse>      <Plug>(VM-Mouse-Column)

        ]])
	end,
}
