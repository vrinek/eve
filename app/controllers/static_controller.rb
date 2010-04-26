class StaticController < ApplicationController
  def faq
    @q_and_as = [
      {
        :q => "What is this?",
        :a => "Something I wrote in my spare time to refresh my Rails skills."
      },
      {
        :q => "What's its purpose?",
        :a => "To help capsuleers (aka EVE online players) with some advanced tools."
      },
      {
        :q => "It does not work/it is broken.",
        :a => "The website is meant to be accessed by the in-game browser. It is possible that your browser is just not compatible enough."
      },
      {
        :q => "What browsers do you support?",
        :a => "The ones that are based around WebKit. A sort list is Apple Safari, Google Chrome and Moondoggie (the EVE in-game browser)."
      },
      {
        :q => "Will you add support for XYZ browser?",
        :a => "No."
      },
      {
        :q => "Will you add XYZ feature?",
        :a => "If it is possible, why not? Contact me and I'll consider it."
      }
    ]
    
    @title = "F.A.Q."
  end
end
