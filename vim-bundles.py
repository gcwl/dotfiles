#!/usr/bin/python

import threading
import os
from subprocess import call
#from pprint import pprint as pp

urls = '''\
https://github.com/ervandew/supertab.git
https://github.com/flazz/vim-colorschemes.git
https://github.com/junegunn/fzf.vim.git
https://github.com/junegunn/vim-easy-align.git
https://github.com/kien/ctrlp.vim.git
https://github.com/kshenoy/vim-signature.git
https://github.com/plasticboy/vim-markdown.git
https://github.com/rhysd/vim-clang-format.git
https://github.com/scrooloose/nerdtree.git
https://github.com/scrooloose/syntastic.git
https://github.com/tpope/vim-commentary.git
https://github.com/tpope/vim-fugitive.git
https://github.com/vim-airline/vim-airline-themes.git
https://github.com/vim-airline/vim-airline.git
https://github.com/vim-scripts/diffchanges.vim'''
# https://github.com/sjl/gundo.vim.git
# https://github.com/fholgado/minibufexpl.vim.git
# https://github.com/mileszs/ack.vim.git
# https://github.com/xolox/vim-easytags.git
# https://github.com/xolox/vim-misc
# https://github.com/vim-scripts/Align.git
# https://github.com/Chiel92/vim-autoformat.git
# https://github.com/vim-scripts/taglist.vim.git
# https://github.com/vim-scripts/TaskList.vim.git

urls = [g.strip() for g in urls.split('\n')]
#pp(urls)

# global variable -- bundle directory
bundle = os.path.join(os.getcwd(), 'bundle')
if not os.path.isdir(bundle):
    os.mkdir(bundle)

# thread worker
def g(url):
    plugin = url.split('/')[-1][:-4]
    path = os.path.join(bundle, plugin)
    if os.path.isdir(path):
        # update git
        os.chdir(path)
        print 'Updating %s.' % plugin
        call(['git', 'pull'])
    else:
        # clone repo
        print 'Cloning %s' % plugin
        call(['git', 'clone', url, path])

# fire the threads
for url in urls:
    t = threading.Thread(name=url, target=g, args=(url,))
    t.setDaemon(True)
    t.start()
