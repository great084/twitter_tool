$(document).on('turbolinks:load', function() {
  function readURL(input, i) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('.img-preview').eq(i).attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
  $(".tweet-img-file").on('change', function(){
      var i = $(".tweet-img-file").index(this);
      readURL(this, i);
  });
});