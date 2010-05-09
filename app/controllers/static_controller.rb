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
      },
      {
        :q => "The \"Ore value\" tool seems awfully familiar...",
        :a => "That's cause it's almost a copy from http://eve.grismar.net/ore/ except mine is javascript and can also save the prices to a cookie"
      },
      {
        :q => "Why can't I save my prices from the in-game browser?",
        :a => "The in-game browser does not support cookies the same way that other browsers do (at least not at the time I'm writing this)"
      }
    ]
    
    @title = "F.A.Q."
  end
  
  def copyright
    @title = "Copyright Notice"
  end
end
