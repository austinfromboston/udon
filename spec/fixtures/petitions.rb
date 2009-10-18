Udon::Account.configure do |config|
  config.database ='airdrop_petitions'
  config.collection :petitions do
    text :title, :required => true
    wysiwyg :body
    use_name :title

    many :signers
  end

  config.collection :signers do
    text :name, :required => true
    text :email, :required => true
    text :zip

    belongs_to :petition, :include_blank => 'Select Petition'
  end
end
