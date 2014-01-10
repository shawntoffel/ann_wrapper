# ann_wrapper


[![Gem Version](https://badge.fury.io/rb/ann_wrapper.png)](http://badge.fury.io/rb/ann_wrapper)
[![Build Status](https://travis-ci.org/Getkura/ann_wrapper.png?branch=dev)](https://travis-ci.org/Getkura/ann_wrapper)
[![Code Climate](https://codeclimate.com/github/Getkura/ann_wrapper.png)](https://codeclimate.com/github/Getkura/ann_wrapper)


A simple ruby wrapper/abstraction for the [Anime News Network API](http://www.animenewsnetwork.com/encyclopedia/api.php)

## Installation

Add this line to your application's Gemfile:

    gem 'ann_wrapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ann_wrapper

## Usage

Fetch an anime:

    steins_gate = ANN_Wrapper.fetch_anime 11770

Info:
    
    steins_gate.title
     => ["Steins;Gate"]
    steins_gate.alt_titles
     => {"PT"=>["Steins-Gate e a Teoria do Caos"], "JA"=>["シュタインズ・ゲート"], "ZH-TW"=>["命運石之門"], "KO"=>["슈타인즈 게이트"]}

    steins_gate.synopsis
     => ["Rintaro Okabe is a self-proclaimed "mad scientist" ... "]
    steins_gate.num_episodes
     => ["24"]
    steins_gate.vintage
     => ["2011-04-03 (Advanced screening)", "2011-04-05 to 2011-09-13"]
    steins_gate.genres
     => ["adventure", "comedy", "drama", "mystery", "psychological", "romance", "science fiction", "thriller"]
    steins_gate.themes
     => ["butterfly effect", "conspiracy", "technology", "Time travel"]
    steins_gate.op_theme
     => ["\"Hacking to the Gate\" by Kanako Ito"]
    steins_gate.ed_theme
     => ["\"Tokitsukasadoru Jūni no Meiyaku\" (刻司ル十二ノ盟約) by Yui Sakakibara", "#2: \"Sukai Kuraddo no Kansokusha\" (スカイクラッドの観測者) by Kanako Ito (ep 23)", "#3: \"Another Heaven\" by Kanako Itou (ep 24)"]


Cast and Staff:
    
    steins_gate.cast.find_all {|c| c.name.include? "Hanazawa"}
     => [#<struct ANN_Cast id="53741", role="Mayuri Shiina", name="Kana Hanazawa", lang="JA">]
     
    steins_gate.staff.find_all {|s| s.task.eql? "Director"}
     => [
            #<struct ANN_Staff id="593", task="Director", name="Takuya Satō">, 
            #<struct ANN_Staff id="9693", task="Director", name="Hiroshi Hamasaki">, 
            #<struct ANN_Staff id="35713", task="Director", name="Tomoki Kobayashi">
        ]


Episodes:

    steins_gate.episodes.first
     => #<struct ANN_Episode number="1", title="Prologue of the Beginning and End", lang="EN">

    steins_gate.episodes.find_all {|e| e.title.include? "Prologue"}
     => [
            #<struct ANN_Episode number="1", title="Prologue of the Beginning and End", lang="EN">, 
            #<struct ANN_Episode number="24", title="The Prologue Begins With the End", lang="EN">
        ]
        
Images:

    steins_gate.images
     => [
            #<struct ANN_Image src="http://cdn.animenewsnetwork.com/thumbnails/fit200x200/encyc/A11770-1864351140.1370764886.jpg", width="200", height="125">, 
            #<struct ANN_Image src="http://cdn.animenewsnetwork.com/thumbnails/fit200x200/encyc/A11770-8.jpg", width="200", height="200">
        ]





## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
