module AWSIntegration

  aws_credentials = YAML::load( File.open( ENV['HOME'] + '/.notes-storage/aws/credentials.yaml' ) )
   #puts aws_credentials.class
   #puts aws_credentials["access_key_id"]

   s3 = AWS::S3.new(
  :access_key_id => aws_credentials["access_key_id"],
  :secret_access_key => aws_credentials['secret_access_key'])
  
  #s3.buckets.each do |bucket|
  #  puts bucket.name
  #end
  
  @@bucket = s3.buckets['notes-storage'] 

  def add_content(name, content)
    @@bucket.objects[name].write(content)
  end

end