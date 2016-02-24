var indexShow = (function() {
  
  function imagesLoaded() {
    $container.imagesLoaded(function(){
      $container.masonry({
        columnWidth: 10,
        itemSelector: '.box',
        gutter: 20
      });
    });
  }
  function infinitescroll() {
    $container.infinitescroll({
      state: {
        isDuringAjax: false,
        isInvalidPage: false,
        isDone: false, // For when it goes all the way through the archive.
        isPaused: false,
        currPage: 1
      },
      navSelector : "#npage",
      nextSelector : "#npage a",
      itemSelector : ".box",
      pixelsFromNavToBottom: 100,
      loading: {
          finishedMsg: 'No more pages to load.',
          msgText: "loading...."
      },
      animate: true
    },
    function(newElements) {
      console.log('---------------load time--------------');
      var $newElems = $(newElements).css({opacity: 0});
      $newElems.imagesLoaded(function(){
        $container.masonry({
          columnWidth: 10,
          itemSelector: '.box',
          gutter: 20
        });
        $newElems.animate({opacity: 1});
        $container.masonry('appended', $newElems, true);
      });
    });
  }
  function fancybox() {
    $(".fancybox").fancybox({
      // API options 
      openEffect  : 'elastic',
      closeEffect : 'elastic',
      autoScale: false,
      type: 'iframe',
      padding: 0,
      autoSize: false,
      width: "55%",
      height: "auto",
      helpers : {
        overlay : {
          css : {
              'background' : 'rgba(0, 0, 0, .8)'
          }
        }
      }
    });
  }
  return {
    initialize: function(){
      $container = $('#masonry');
      imagesLoaded();
      infinitescroll();
      fancybox();
    },
    scroll: function(){
      $(window).unbind('.infscr');
    }
  };
}());