set signcolumn=no
set foldcolumn=0

set spell

# shift + alt + L/H: Change window
bind -n M-H previous-window
bind -n M-L next-window

# Colors
colorscheme slate
set -g status-fg  green
set -g status-bg  black
# Make sure that the colors are the same in and out of tmux
set-option -sa terminal-overrides ",xterm*:Tc"

# Set GUI
set -g status-position top
