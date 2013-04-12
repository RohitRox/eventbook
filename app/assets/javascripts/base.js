$(function() {
  var addresspickerMap = $( "#event_address" ).addresspicker({
    elements: {
      map:      "#map",
      lat:      "#event_latt",
      lng:      "#event_long",
      locality: '#event_locality',
      country:  '#event_country'
    }
  });
  var gmarker = addresspickerMap.addresspicker( "marker");
  gmarker.setVisible(true);
  addresspickerMap.addresspicker( "updatePosition");

});