# PuppetX::Cisco::AutoGen - automatically generate getter/setter methods
#
# April 2015
#
# Copyright (c) 2015 Cisco and/or its affiliates.
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

module PuppetX
  module Cisco
    class AutoGen
      def AutoGen.mk_puppet_methods(mtype, klass, rlbname, props)
        case mtype
        when :non_bool
          mk_puppet_getters_non_bool(klass, rlbname, props)
          mk_puppet_setters_non_bool(klass, rlbname, props)
        when :bool
          mk_puppet_getters_bool(klass, rlbname, props)
          mk_puppet_setters_bool(klass, rlbname, props)
        end
      end

      # Auto-generator for puppet non-boolean-based GETTER methods
      def AutoGen.mk_puppet_getters_non_bool(klass, rlbname, props)
        props.each do |prop|
          klass.instance_eval {
            # Generate GETTER method; e.g.
            # def foo
            #   return :default if
            #     @resource[foo] == :default and
            #     @property_hash[foo] == @rlb.default_foo
            #   @property_hash[foo]
            # end
            define_method(prop) do
              return :default if
                @resource[prop] == :default and
                @property_hash[prop] == self.instance_variable_get(rlbname).send("default_#{prop}")
              @property_hash[prop]
            end
          }
        end
      end

      # Auto-generator for puppet non-boolean-based SETTER methods
      def AutoGen.mk_puppet_setters_non_bool(klass, rlbname, props)
        props.each do |prop|
          klass.instance_eval {
            # Generate SETTER method; e.g.
            # def foo=
            #   if val == :default
            #     val = @rlb.default_foo
            #   end
            #   @property_flush[foo] = val
            # end
            define_method("#{prop}=") do |val|
              raise "@property_flush not defined" if
                self.instance_variable_get(:@property_flush).nil?
              if val == :default
                val = self.instance_variable_get(rlbname).send("default_#{prop}")
              end
              @property_flush[prop] = val
            end
          }
        end
      end

      # Auto-generator for puppet boolean-based GETTER methods
      def AutoGen.mk_puppet_getters_bool(klass, rlbname, props)
        props.each do |prop|
          klass.instance_eval {
            # Generate GETTER method; e.g.
            # def foo
            #   val = @rlb.foo
            #   return :default if
            #     @resource[foo] == :default and
            #     val == @rlb.default_foo
            #   @property_hash[foo] = val.nil? ? nil : (val ? :true : :false)
            # end
            define_method(prop) do
              val = self.instance_variable_get(rlbname).send(prop)
              return :default if
                @resource[prop] == :default and
                val == self.instance_variable_get(rlbname).send("default_#{prop}")
              @property_hash[prop] = val.nil? ? nil : (val ? :true : :false)
            end
          }
        end
      end

      # Auto-generator for puppet boolean-based SETTER methods
      def AutoGen.mk_puppet_setters_bool(klass, rlbname, props)
        props.each do |prop|
          klass.instance_eval {
            # Generate SETTER method; e.g.
            # def foo=
            #   @property_flush[foo] =
            #     (val == :default) ?
            #       @rlb.foo :
            #       (val == :true)
            # end
            define_method("#{prop}=") do |val|
              raise "@property_flush not defined" if
                self.instance_variable_get(:@property_flush).nil?
              @property_flush[prop] =
                (val == :default) ?
              self.instance_variable_get(rlbname).send("default_#{prop}") :
                (val == :true)
            end
          }
        end
      end
    end
  end
end
