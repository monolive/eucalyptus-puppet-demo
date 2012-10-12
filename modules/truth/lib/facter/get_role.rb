require 'facter'

if File.exist?("/etc/company.facts")
    File.readlines("/etc/company.facts").each do |line|
        if line =~ /^(.+)=(.+)$/
            var = "company_"+$1.strip; 
            val = $2.strip

            Facter.add(var) do
                setcode { val }
            end
        end
    end
end

