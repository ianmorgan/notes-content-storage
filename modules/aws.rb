module AWSIntegration
  aws_credentials = YAML::load( File.open( ENV['HOME'] + '/.notes/' + ENV['RACK_ENV'] + '/aws/credentials.yaml' ) )

  s3 = AWS::S3.new(
    :access_key_id => aws_credentials["access_key_id"],
    :secret_access_key => aws_credentials['secret_access_key'])
  
  #s3.buckets.each do |bucket|
  #  puts bucket.name
  #end
  
  # TODO - should be able to figure this out dynamically 
  @@buckets = Hash.new 
  @@buckets['design'] = s3.buckets['notes-storage-design'] 
  @@buckets['functional-programming'] = s3.buckets['notes-storage-functional-programming'] 
  @@buckets['html'] = s3.buckets['notes-storage-html'] 
  @@buckets['java'] = s3.buckets['notes-storage-java'] 
  @@buckets['ruby'] = s3.buckets['notes-storage-ruby']
  @@buckets['scala'] = s3.buckets['notes-storage-scala'] 
  @@buckets['unix'] = s3.buckets['notes-storage-unix']

  def store_content_in_S3(content_hash)
    topic = content_hash[:topic]
    content = content_hash[:content]
    key = content_hash[:slug]  
    @@buckets[topic].objects[key].write(content)
    
    metadata = Hash.new
    metadata[:title] = content_hash[:title]
    metadata[:keywords] = content_hash[:keywords]
    metadata[:creation] = {:author => 'Ian', :datetime =>  DateTime.now.iso8601}
    @@buckets[topic].objects["#{key}-metadata"].write( metadata.to_json)
    
    #puts meta_data.to_json
  end

end