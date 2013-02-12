#

task :default => :compile

file 'lib/revo/parser.tab.rb' => 'lib/revo/grammar.y' do |t|
  racc_bin = ENV['RACC'] || 'racc'
  debug = ENV['DEBUG'] || true
  profiling = ENV['PROFILING'] || false

  options = ['-v']
  options << '-t' if debug
  options << '-P' if profiling

  options << '-o' << 'lib/revo/parser.tab.rb'

  sh([racc_bin, options << 'lib/revo/grammar.y'].flatten.join(' '))
end

desc "Compile syntax specification"
file :compile => 'lib/revo/parser.tab.rb'
