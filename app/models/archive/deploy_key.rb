class Archive
  class DeployKey
    include Mongoid::Document

    # Embeds
    #
    embedded_in :archive

    # Fields
    #
    field :github_id   , :type => Integer
    field :github_url  , :type => String
    field :private_key , :type => String
    field :public_key  , :type => String

    def create_key_dir!
      `mkdir -p #{ key_dir }`
    end

    def create_key_files!
      system "ssh-keygen -t rsa -C '#{ name }@antiqua.io' -N '' -f #{ private_key_path }"
    end

    def generate!
      create_key_dir!
      remove_existing_key_files!
      create_key_files!
      read_key_file_data
      save!
    end

    def key_dir
      "#{ Rails.root }/tmp/app/archives/#{ archive.id }"
    end

    def name
      "archive-#{ archive.id }-deploy-key"
    end

    def private_key_path
      "#{ key_dir }/deploy.key"
    end

    def public_key_path
      "#{ private_key_path }.pub"
    end

    def read_key_file_data
      self.private_key = File.read private_key_path
      self.public_key  = File.read public_key_path
    end

    def remove_existing_key_files!
      File.delete private_key_path if File.exists? private_key_path
      File.delete public_key_path  if File.exists? public_key_path
    end
  end
end
