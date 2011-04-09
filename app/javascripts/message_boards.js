$(function() {
  $('[data-starred]').
    bind('updateStarStatus', function() {
      var post = $(this);

      post.find('[data-toggle-star]').hide();

      if (post.data('starred')) {
        post.find('[data-toggle-star=unstar]').show();
      } else {
        post.find('[data-toggle-star=star]').show();
      }
    }).
    trigger('updateStarStatus');

  $(this).delegate('[data-toggle-star]', 'ajax:success', function(e, data) {
    var link = $(this);
    var post = link.closest('[data-starred]');

    post.
      data('starred', data.starred).
      trigger('updateStarStatus');
  });
});
