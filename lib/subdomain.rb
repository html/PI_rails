require 'actionpack'

module ActionController
  module Routing
    class SubdomainRoute < Route 
      def generate(options, hash, expire_on = {})
        path, hash = generate_raw(options, hash, expire_on)
        append_query_string(path, hash, extra_keys(options))
      end

      def matches_controller_and_action?(controller, action)
        prepare_matching!
        (@controller_requirement.nil? || @controller_requirement.to_s === controller.to_s) &&
        (@action_requirement.nil? || @action_requirement.to_s === action.to_s)
      end
    end

    class RouteSet
      class ActionController::Routing::RouteSet::Mapper
        def subdomain_builder
          @subdomain_builder ||= ActionController::Routing::SubdomainRouteBuilder.new
        end

        def subdomain_connect(path, options = {})
          route = subdomain_builder.build(path, options)
          @set.routes << route
        end
      end

      def recognize(request)
        params = recognize_path(request.url, extract_request_environment(request))
        request.path_parameters = params.with_indifferent_access
        "#{params[:controller].to_s.camelize}Controller".constantize
      end
    end

    Routes.class_eval do
      attr_accessor :request
      
      def call(env)
        request = Request.new(env)
        @request = request
        app = Routing::Routes.recognize(request)
        app.call(env).to_a
      end
    end

    class ProtocolSegment < Segment
      def build_pattern(pattern)
        "(http(?:s)?://)#{pattern}"
      end

      def value
        'http://'
      end

      def interpolation_chunk
        'http://'
      end

      def number_of_captures
        1
      end

      def regexp_chunk
        /^/#/(http(?:s)?:\/\/)/
      end

      def to_s
        'http://'
      end
    end

    class SubdomainSegment < Segment
      def build_pattern(pattern)
        #puts "subdomain" + pattern.to_s
        "([^\.]+)#{pattern}"
      end
    end

    class SubdomainDividerSegment < DividerSegment
      def value
        '.'
      end

      def number_of_captures
        1
      end

      def build_pattern(pattern)
        #puts ["divider", pattern, super(pattern.to_s)].join " *** "
        "(\\.)#{pattern}"
      end
    end

    class HostSegment < StaticSegment
      class HostNotAssignedError < StandardError
      end

      cattr_accessor :host

      def interpolation_chunk
        raise HostNotAssignedError if host.nil?
        host
      end

      def interpolation_statement(arg)
        #puts "test2"
        super(arg)
      end

      def extract_value
        #'puts hash.to_yaml'
      end

      def extraction_code
        ''
      end

      def match_extraction(a1)
        #"puts match.to_yaml, params.to_yaml, '::))'"
      end

      def number_of_captures
        1
      end

      def build_pattern(pattern)
        "([^/]+)#{pattern}"
      end
    end

    class SubdomainRouteBuilder < ActionController::Routing::RouteBuilder
      @protocol_assigned = false
      @host_found = false

      def segment_for(string)
        segment =
          if @protocol_assigned
            case string
              when /\A(:host)/
                @host_found = true
                HostSegment.new($1)
              when /\A(\.)/
                if(@host_found)
                  DividerSegment.new($1)
                else
                  SubdomainDividerSegment.new
                end
              else
                return super(string)
            end
          else
            @protocol_assigned = true
            /^/.match(string)

            ProtocolSegment.new
          end

        [segment, $~.post_match]
      end

      def build(path, options)
        @protocol_assigned = false
        @host_found = false
        # Wrap the path with slashes
        #path = "/#{path}" unless path[0] == ?/
        path = "#{path}/" unless path[-1] == ?/

        #prefix = options[:path_prefix].to_s.gsub(/^\//,'')
        #path = "/#{prefix}#{path}" unless prefix.blank?

        segments = segments_for_route_path(path)
        defaults, requirements, conditions = divide_route_options(segments, options)
        requirements = assign_route_options(segments, defaults, requirements)

        # TODO: Segments should be frozen on initialize
        segments.each { |segment| segment.freeze }

        #puts segments.to_yaml
        route = SubdomainRoute.new(segments, requirements, conditions)

        if !route.significant_keys.include?(:controller)
          raise ArgumentError, "Illegal route: the :controller must be specified!"
        end

        route.freeze
      end
    end
  end
end

