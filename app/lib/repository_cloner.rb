class RepositoryCloner
  attr_reader :archive , :options , :repository

  def initialize( *args )
    @options    = Map Map.opts!( args )
    @archive    = options.archive    rescue args.shift or raise ArgumentError.new( "Missing option 'archive'!" )
    @repository = options.repository rescue args.shift or raise ArgumentError.new( "Missing option 'repository'!" )
  end

  def clone!
    pid = fork do
      exec <<COMMAND
ssh-agent `which bash` -c " \
if [ -e "~/.profile" ]; then source ~/.profile; fi && \
  cd #{ Rails.root }/tmp/app/archives/#{ archive.id_as_string } && \
  ssh-add -D && \
  ssh-add deploy.key && \
  git clone --recursive #{ repository.github_ssh_url }"
COMMAND
    end
    Process.wait pid
  end
end
