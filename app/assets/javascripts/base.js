$(function() {

  window.geo_render = function(latt,lngt, el){
     var addresspickerMap = $("#event_address").addresspicker({
      elements: {
        map:      el,
        lat:      "#event_latt",
        lng:      "#event_long",
        locality: '#event_locality',
        country:  '#event_country',
        myLatt: latt,
        myLong: lngt
      }
    });
    var gmarker = addresspickerMap.addresspicker( "marker");
    gmarker.setVisible(true);
    addresspickerMap.addresspicker( "updatePosition");
  };

  $('#bg_button').click(function(e){
    e.preventDefault();
    $('.custom-bg').slideToggle();
  });

});