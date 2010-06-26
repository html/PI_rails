require 'test_helper'

class LinksControllerTest < ActionController::TestCase
  watir_test do
    should "add link" do
      browser.goto "http://links.#{APPLICATION_HOST}"
      browser.link(:class, 'jqm link').click
      browser.text_field(:id, 'link_description').set 'Test link'
      browser.text_field(:id, 'link_value').set 'test test test'
      browser.link(:class, 'save link').click

      while true
        begin
          puts "Trying to locate message"
          browser.span(:class, 'message')
          assert_not_nil browser.span(:class, 'message').text
          break
        rescue
          sleep 1
        end
      end
    end
  end
end
