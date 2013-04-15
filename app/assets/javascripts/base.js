$(function() {
  if( $('#map').length > 0){
   map_init(27.699944, 85.333385);
  }
  function map_init(latt,lngt){
     var addresspickerMap = $( "#event_address" ).addresspicker({
      elements: {
        map:      "#map",
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
  }
  function render_map(latt, lngt){
    map_init(latt,lngt);
  }
});