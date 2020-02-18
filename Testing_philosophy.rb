require "selenium-webdriver"
require "rspec"
require "rubygems"
require "nokogiri"
require "mechanize"
require "open-uri"
require "uri"


link_to_wiki = "https://en.wikipedia.org/wiki/Philosophy_(disambiguation)"
Base_of_wiki_link = "https://en.wikipedia.org"


describe "Checking path to Philosophy" do
    it "testing how fun it is" do
        driver = Selenium::WebDriver.for(:remote, :url => 'http://localhost:9515', :desired_capabilities => :chrome)
        agent = Mechanize.new
        document = Nokogiri::HTML.parse(open(link_to_wiki)) #parsing the website
        link_to_click = ''

        
        driver.navigate.to link_to_wiki #going to the page
            
        i = 0   
        loop do 
                i +=1 
                if i == 100 # assuring that the code runs only i times (avoidig neverending loop among websites)
                    puts "I wasn't able to find the path to Philosophy in #{i} steps"
                    break
                end

                page_name = driver.find_element(id: "firstHeading")
                if page_name.text == "Philosophy" #checking if philosophy was reached
                    puts "You found your Philosophy in #{i} steps"
                    driver.quit 
                    next
                    puts "Whaaat? I should not get here :-o " #testing if it quits the test once it finds philosophy
                else  
                    if link_to_click != ''
                        document = Nokogiri::HTML.parse(open(link_to_click)) #parsing the website
                        link_to_click = ''
                    end
                        
                    document.class

                    tags = document.css("//a")
                    
                    tags.each do |tag|
                        link = "#{tag[:href]}"  #looking for hyperlink
                        if link.start_with? "/wiki/"     #checking if it is wikilink
                            if !link.include? "#"           #verifying that # is not a pat of the link
                                if !link.include? ":"       #verifying that the lin doesn§t contain : 
                                    #these checks could be done in more elegant way :) 
                                    if !link.include? "disambiguation" 
                                        if link_to_click == '' 
                                            #one of the further checks included would be to remove repeated websites
                                            link_to_click = Base_of_wiki_link + link
                                        end
                                    end
                                end
                            end
                        end                
                    end
                    driver.navigate.to link_to_click  
                end
        end   #ending check if we have found philosophy (+ move to next link if not)
     
        driver.quit
        next
        puts "Something went wrong. Please review the code. " # verifying if the test continues after finding the philosophy in if statement
    end
end

