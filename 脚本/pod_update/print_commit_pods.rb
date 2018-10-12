podfile = ARGV[0]

$hash_value = {}

def source(url)
end

def target(target)
  if block_given?
    yield
  end
end

def platform(platform, version)
end

def pod(pod, *params)
  pods = $hash_value['pods']
  pods = [] if pods == nil
  params.each { |param| pods << pod if (param.is_a? Hash and (param[:commit] != nil or param[:branch] != nil)) }
  $hash_value['pods'] = pods
end

def post_install
end

def install!(pod, *params)
end

content = File.read podfile
eval content
puts $hash_value['pods'].join(" ")

