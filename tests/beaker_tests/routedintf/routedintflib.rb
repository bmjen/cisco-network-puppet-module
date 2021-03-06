###############################################################################
# Copyright (c) 2014-2015 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################
# ROUTEDINTF Utility Library: 
# ---------------------------
# routedintflib.rb
#  
# This is the utility library for the ROUTEDINTF provider Beaker test cases that
# contains the common methods used across the ROUTEDINTF testsuite's cases. The 
# library is implemented as a module with related methods and constants defined
# inside it for use as a namespace. All of the methods are defined as module 
# methods.
#
# Every Beaker ROUTEDINTF test case that runs an instance of Beaker::TestCase 
# requires RoutedIntfLib module.
# 
# The module has a single set of methods:
# A. Methods to create manifests for cisco_interface Puppet provider test cases.
###############################################################################

# Require UtilityLib.rb path.
require File.expand_path("../../lib/utilitylib.rb", __FILE__)

module RoutedIntfLib

  # Group of Constants used in negative tests for ROUTEDINTF provider.
  IPV4ADDRESS_NEGATIVE         = '-1.-1.-1.-1'
  IPV4MASKLEN_NEGATIVE         = '-1'
  IPV4PROXYARP_NEGATIVE        = 'invalid'
  IPV4REDIR_NEGATIVE           = 'invalid'
  SHUTDOWN_NEGATIVE            = 'invalid'
  VRF_NEGATIVE                 = '~'

  # A. Methods to create manifests for cisco_interface Puppet provider test cases.

  # Method to create a manifest for RoutedINTF resource attribute 'ensure' where
  # 'ensure' is set to present and 'switchport_mode' is set to disabled.
  # @param none [None] No input parameters exist. 
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_switchport_disabled()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      description                  => 'default',
      shutdown                     => false,
      switchport_mode              => disabled,
      ipv4_address                 => '192.168.1.1',
      ipv4_netmask_length          => 16,
      ipv4_proxy_arp               => 'default',
      ipv4_redirects               => 'default',
      switchport_autostate_exclude => 'default',
      switchport_vtp               => 'default',
      vrf                          => 'default',
  }
}
EOF"
    return manifest_str
  end

  # Method to create a manifest for RoutedINTF resource attribute 'ensure' where
  # 'ensure' is set to present and 'switchport_mode' is set to access.
  # @param none [None] No input parameters exist. 
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_switchport_access()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      description                  => 'default',
      shutdown                     => false,
      switchport_mode              => access,
    }
}
EOF"
    return manifest_str
  end

  # Method to create a manifest for RoutedINTF resource attributes:
  # description, shutdown, switchport_mode, ipv4_address, 
  # ipv4_netmask_length, ipv4_proxy_arp and ipv4_redirects.  
  # @param none [None] No input parameters exist. 
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_nondefaults()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      description                  => 'Configured with Puppet',
      shutdown                     => true,
      switchport_mode              => disabled,
      ipv4_address                 => '192.168.1.1',
      ipv4_netmask_length          => 16,
      ipv4_proxy_arp               => true,
      ipv4_redirects               => false,
      switchport_autostate_exclude => false,
      switchport_vtp               => false,
      vrf                          => 'test1',
    }
}
EOF"
    return manifest_str
  end

  # Method to create a manifest for RoutedINTF resource attribute 'ipv4_address'.
  # @param none [None] No input parameters exist. 
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_ipv4addr_negative()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      shutdown                     => false,
      switchport_mode              => disabled,
      ipv4_address                 => #{RoutedIntfLib::IPV4ADDRESS_NEGATIVE},
      ipv4_netmask_length          => 16,
    }
}
EOF"
    return manifest_str
  end

  # Method to create a manifest for RoutedINTF resource attribute 'ipv4_netmask_length'.
  # @param none [None] No input parameters exist. 
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_ipv4masklen_negative()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      shutdown                     => false,
      switchport_mode              => disabled,
      ipv4_address                 => '192.168.1.1',
      ipv4_netmask_length          => #{RoutedIntfLib::IPV4MASKLEN_NEGATIVE},
    }
}
EOF"
    return manifest_str
  end

  # Method to create a manifest for RoutedINTF resource attribute 'shutdown'.
  # @param none [None] No input parameters exist. 
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_shutdown_negative()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      shutdown                     => false,
      switchport_mode              => disabled,
      shutdown                     => #{RoutedIntfLib::SHUTDOWN_NEGATIVE},
    }
}
EOF"
    return manifest_str
  end

  # Method to create a manifest for RoutedINTF resource attribute 'ipv4_proxy_arp'.
  # @param none [None] No input parameters exist. 
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_ipv4proxyarp_negative()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      shutdown                     => false,
      switchport_mode              => disabled,
      ipv4_proxy_arp               => #{RoutedIntfLib::IPV4PROXYARP_NEGATIVE},
    }
}
EOF"
    return manifest_str
  end

  # Method to create a manifest for RoutedINTF resource attribute 'ipv4_redirects'.
  # @param none [None] No input parameters exist. 
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_ipv4redir_negative()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      shutdown                     => false,
      switchport_mode              => disabled,
      ipv4_redirects               => #{RoutedIntfLib::IPV4REDIR_NEGATIVE},
    }
}
EOF"
    return manifest_str
  end

  # Method to create a manifest for RoutedINTF resource attribute 'vrf'.
  # @param none [None] No input parameters exist.
  # @result none [None] Returns no object.
  def RoutedIntfLib.create_routedintf_manifest_vrf_negative()
    manifest_str = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
node default {
    cisco_interface { 'ethernet1/4':
      ensure                       => present,
      shutdown                     => false,
      switchport_mode              => disabled,
      vrf                          => #{RoutedIntfLib::VRF_NEGATIVE},
    }
}
EOF"
    return manifest_str
  end
end
