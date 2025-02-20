# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()

class show_files_in_finder(Command):
    """
    :show_files_in_finder

    Present selected files in finder
    """

    def execute(self):
        import subprocess
        files = ",".join(['"{0}" as POSIX file'.format(file.path) for file in self.fm.thistab.get_selection()])
        reveal_script = "tell application \"Finder\" to reveal {{{0}}}".format(files)
        activate_script = "tell application \"Finder\" to set frontmost to true"
        script = "osascript -e '{0}' -e '{1}'".format(reveal_script, activate_script)
        self.fm.notify(script)
        subprocess.check_output(["osascript", "-e", reveal_script, "-e", activate_script])



import subprocess
import os

from ranger.api.commands import Command
from ranger.ext.get_executables import get_executables

def show_error_in_console(msg, fm):
    fm.notify(msg, bad=True)

def navigate_path(fm, selected):
    if not selected:
        return

    selected = os.path.abspath(selected)
    if os.path.isdir(selected):
        fm.cd(selected)
    elif os.path.isfile(selected):
        fm.select_file(selected)
    else:
        show_error_in_console(f"Neither directory nor file: {selected}", fm)
        return

def select_with_fzf(fzf_cmd, input, fm):
    fm.ui.suspend()
    try:
        # stderr is used to open to attach to /dev/tty
        proc = subprocess.Popen(fzf_cmd, stdout=subprocess.PIPE, stdin=subprocess.PIPE, text=True)
        stdout, _ = proc.communicate(input=input)

        # ESC gives 130
        if proc.returncode not in [0, 130]:
            raise Exception(f"Bad process exit code: {proc.returncode}, stdout={stdout}")
    finally:
        fm.ui.initialize()
    return stdout.strip()

class dir_history_navigate(Command):
    def execute(self):
        lst = []
        for d in reversed(self.fm.tabs[self.fm.current_tab].history.history):
            lst.append(d.path)

        fm = self.fm
        selected = select_with_fzf(["fzf"], "\n".join(lst), fm)

        navigate_path(fm, selected)

class fzf_locate(Command):
    """
    :fzf_locate
    Find a file using fzf.
    With a prefix argument select only directories.
    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        if self.quantifier:
            command="locate home | fzf -e -i"
        else:
            command="locate home | fzf -e -i"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

class fzf_content_open(Command):
    """
    :fzf_content_open
    Pre-requisites: fzf, rg, bat, awk, vim or neovim
    Using `rg` to search file content recursively in current directory.
    Filtering with `fzf` and preview with `bat`.
    Pressing `Enter` on target will open at line in (neo)vim.
    """

    def execute(self):
        import subprocess
        import os
        from ranger.ext.get_executables import get_executables

        if 'rg' in get_executables():
            rg = 'rg'
        else:
            self.fm.notify("Couldn't find rg in the PATH.", bad=True)
            return

        if 'fzf' in get_executables():
            fzf = 'fzf'
        else:
            self.fm.notify("Couldn't find fzf in the PATH.", bad=True)
            return

        if 'bat' in get_executables():
            bat = 'bat'
        else:
            self.fm.notify("Couldn't find bat in the PATH.", bad=True)
            return

        editor = None
        if 'nvim' in get_executables():
            editor = 'nvim'
        elif 'vim' in get_executables():
            editor = 'vim'

        if rg is not None and fzf is not None and bat is not None and editor is not None:
            # we should not recursively search through all file content from home directory
            if (self.fm.thisdir.path == self.fm.home_path):
                self.fm.notify("Searching from home directory is not allowed", bad=True)
                return
            fzf = self.fm.execute_command(
                'rg --line-number "${1:-.}" | fzf --delimiter \':\' \
                    --preview \'bat --color=always --highlight-line {2} {1}\' \
                    | awk -F \':\' \'{print "+"$2" "$1}\'',
                universal_newlines=True,stdout=subprocess.PIPE)

            stdout, _ = fzf.communicate()
            if fzf.returncode == 0:
                if len(stdout) < 2:
                    return

                selected_line = stdout.split()[0]
                full_path = stdout.split()[1].strip()

                file_fullpath = os.path.abspath(full_path)
                file_basename = os.path.basename(full_path)

                if os.path.isdir(file_fullpath):
                    self.fm.cd(file_fullpath)
                else:
                    self.fm.select_file(file_fullpath)

                self.fm.execute_command(editor + " " + selected_line + " " + file_basename)
