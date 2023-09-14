Puppet::Type.type(:download).provide(:download_linux) do

  def check_created_file(file)
    if File.exist?(file)
      if File.zero?(file)
        self.debug("Found #{file} but empty")
        return false
      else
        self.debug("Found #{file}")
        return true
      end
    else
      self.debug("Not found #{file}")
      return false
    end
  end

  def run_wget_command(url)
    #curl https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm --create-dirs -o /tmp/prova/cosa/rpm
    command = ["curl"]
    command.push(url)
    command.push("--create-dirs", "-o ", resource[:creates])

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
