Puppet::Type.type(:gitclone).provide(:gitclone_linux) do

  def check_created_file(file)
    if File.exist?(file+'/.git')
      self.debug("Found #{file}")
      return true
    else
      self.debug("Not found #{file}")
      return false
    end
  end

  def run_gitclone_command(url)

    command = ["git"]
    command.push("clone")
    command.push(url)
    command.push(resource[:creates])

    if resource[:cwd]
      Dir.chdir resource[:cwd] do
        run_command(command)
      end
    else
      run_command(command)
    end
  end

  private

  def run_command(command)
    command = command.join ' '
    output = Puppet::Util::Execution.execute(command, {
      :uid                => 'root',
      :gid                => 'root',
      :failonfail         => false,
      :combine            => true,
      :override_locale    => true,
    })
    [output, $CHILD_STATUS.dup]
  end

end
