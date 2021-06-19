require_relative 'scanner'

class FingerprintScanner < Scanner

    def initialize(target_uri, opts)
        super(target_uri, opts)

        @cached_index_results = {}
    end


    def common_resp_headers
        [
          'Access-Control-Allow-Origin',
          'Accept-Patch',
          'Accept-Ranges',
          'Age',
          'Allow',
          'Cache-Control',
          'Connection',
          'Content-Disposition',
          'Content-Encoding',
          'Content-Language',
          'Content-Length',
          'Content-Location',
          'Content-MD5',
          'Content-Range',
          'Content-Type',
          'Date',
          'ETag',
          'Expires',
          'Last-Modified',
          'Link',
          'Location',
          'P3P',
          'Pragma',
          'Proxy-Authenticate',
          'Public-Key-Pins',
          'Refresh',
          'Retry-After',
          'Set-Cookie',
          'Status',
          'Strict-Transport-Security',
          'Trailer',
          'Transfer-Encoding',
          'Upgrade',
          'Vary',
          'Via',
          'Warning',
          'WWW-Authenticate',
          'X-Frame-Options',
          'X-UA-Compatible',
          'X-Content-Duration',
          'X-Content-Type-Options'
        ]
    end

    def registration_uri
        '/index.php?option=com_users&view=registration'
    end

    def directory_listing_enabled(uri)
        return @cached_index_results[uri] if @cached_index_results.has_key?(uri)
    
        req = create_request(uri)
        @cached_index_results[uri] = false
        req.on_complete do |resp|
          if resp.code == 200 && resp.body[%r{<title>Index of}]
            @cached_index_results[uri] = true
          end
        end
    
        req.run
        @cached_index_results[uri]
    end

    def administrator_components_listing_enabled
        directory_listing_enabled('/administrator/components/')
      end
    
      def components_listing_enabled
        directory_listing_enabled('/components/')
      end
    
      def administrator_modules_listing_enabled
        directory_listing_enabled('/administrator/modules/')
      end
    
      def modules_listing_enabled
        directory_listing_enabled('/modules/')
      end
    
      def administrator_templates_listing_enabled
        directory_listing_enabled('/administrator/templates/')
      end
    
      def templates_listing_enabled
        directory_listing_enabled('/templates/')
      end

      
    def user_registration_enabled
        req = create_request(registration_uri)
        req.options['followlocation'] = false

        enabled = true
        req.on_complete do |resp|
            enabled = resp.code == 200
        end

        req.run
        enabled
    end
    