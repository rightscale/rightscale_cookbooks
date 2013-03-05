#
# Cookbook Name:: app
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# This recipe will disable firewall rules on the app server that allowed
# loadbalancers to connect to the correct port.

rightscale_marker :begin

# Setup attributes
# If we are using public IP/interface, use the corresponding IP on the LB
if node[:app][:backend_ip_type] == "Public"
  rule_ip = node[:app][:lb_public_ip]
else
  rule_ip = node[:app][:lb_private_ip]
end
port = node[:app][:port]

log "  Removing firewall rules used to allow loadbalancer to connect"
# See cookbooks/sys_firewall/providers/default.rb for the "update" action.
sys_firewall port do
  ip_addr rule_ip
  protocol "tcp"
  enable false
  action :update
end

rightscale_marker :end
