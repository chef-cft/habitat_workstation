# # encoding: utf-8

# Inspec test for recipe habitat_workstation::install_hab

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe command('hab') do
  it { should exist }
end

describe command('diff /home/chef/new-plan.sh /home/chef/sample-node-app/habitat/plan.sh') do
  its(:stdout) { should match /< pkg_origin=chef/ }
end
