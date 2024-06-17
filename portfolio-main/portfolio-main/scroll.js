$.scrollify({
  section: ".scrollify",
  scrollSpeed: 1500,
  standardScrollElements: '.normal-scroll-item'
});

function landpage() {
  document.getElementById("landpage-nav").className = "nav__list-item active-nav";
  document.getElementById("portfolio-nav").className = "nav__list-item";
  document.getElementById("skills-nav").className = "nav__list-item";
  document.getElementById("social-nav").className = "nav__list-item";
  document.getElementById("contact-nav").className = "nav__list-item";
}

function portfolio() {
  document.getElementById("landpage-nav").className = "nav__list-item";
  document.getElementById("portfolio-nav").className = "nav__list-item active-nav";
  document.getElementById("skills-nav").className = "nav__list-item";
  document.getElementById("social-nav").className = "nav__list-item";
  document.getElementById("contact-nav").className = "nav__list-item";
}

function skills() {
  document.getElementById("landpage-nav").className = "nav__list-item";
  document.getElementById("portfolio-nav").className = "nav__list-item";
  document.getElementById("skills-nav").className = "nav__list-item active-nav";
  document.getElementById("social-nav").className = "nav__list-item";
  document.getElementById("contact-nav").className = "nav__list-item";
}

function social() {
  document.getElementById("landpage-nav").className = "nav__list-item";
  document.getElementById("portfolio-nav").className = "nav__list-item";
  document.getElementById("skills-nav").className = "nav__list-item";
  document.getElementById("social-nav").className = "nav__list-item active-nav";
  document.getElementById("contact-nav").className = "nav__list-item";
}

function contact() {
  document.getElementById("landpage-nav").className = "nav__list-item";
  document.getElementById("portfolio-nav").className = "nav__list-item";
  document.getElementById("skills-nav").className = "nav__list-item";
  document.getElementById("social-nav").className = "nav__list-item";
  document.getElementById("contact-nav").className = "nav__list-item active-nav";
}

// Create a lightbox
(function() {
  var $lightbox = $("<div class='lightbox'></div>");
  var $img = $("<img>");
  var $caption = $("<p class='caption'></p>");

  // Add image and caption to lightbox

  $lightbox
    .append($img)
    .append($caption);

  // Add lighbox to document

  $('body').append($lightbox);

  $('.lightbox-gallery img').click(function(e) {
    e.preventDefault();

    // Get image link and description
    var src = $(this).attr("data-image-hd");
    var cap = $(this).attr("alt");

    // Add data to lighbox

    $img.attr('src', src);
    $caption.text(cap);

    // Show lightbox

    $lightbox.fadeIn('fast');

    $lightbox.click(function() {
      $lightbox.fadeOut('fast');
    });
  });

}());

;(function($) {
  "use strict";
  
  $(".bar").each(function() {
    
    var $bar = $(this),
        $pct = $bar.find(".pct"),
        data = $bar.data("bar");
    
    setTimeout(function() {
      
      $bar
        .css("background-color", data.color)
        .animate({
          "width": $pct.html()
      }, data.speed || 2000, function() {
        
        $pct.css({
          "color": data.color,
          "opacity": 1
        });
        
      });
      
    }, data.delay || 0);
    
  });
  
})(jQuery);