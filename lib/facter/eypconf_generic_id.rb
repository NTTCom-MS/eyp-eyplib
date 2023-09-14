if File.exist?('/opt/eypconf/id') then
  Dir.entries("/opt/eypconf/id").select {|f| !File.directory? f}.each do |i|

    genetic_id = Facter::Util::Resolution.exec("bash -c 'cat /opt/eypconf/id/#{i}'").to_s

    if i[0]=='.' then
      if i == ".magic" then
        fact_name="magic_hash"
      else
        fact_name=i[1..-1]
      end
    else
      fact_name=i
    end

    unless genetic_id.nil? or genetic_id.empty?
      Facter.add("eypconf_#{fact_name}") do
          setcode do
            genetic_id
          end
      end

      Facter.add("eypconf_#{fact_name}_uppercase") do
          setcode do
            genetic_id.upcase
          end
      end

      Facter.add("eypconf_#{fact_name}_lowercase") do
          setcode do
            genetic_id.downcase
          end
      end

      Facter.add("eypconf_#{fact_name}_source") do
          setcode do
            "/opt/eypconf/id/#{i}"
          end
      end
    end
  end
end
