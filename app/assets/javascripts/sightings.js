if(!window.thylacine){
    window.thylacine = {};
}

$( document ).ready(function() {
    window.thylacine.mapView = undefined;

    thylacine.initMap = function () {
        window.thylacine.mapView = new google.maps.Map($('#map')[0], {
            center: {lat: 0, lng: 0},
            zoom: 2,
            streetViewControl: false,
            styles: [{
                featureType: 'poi.business',
                stylers: [{visibility: 'off'}]
            }]
        });
    };

    thylacine.initMap();
} );




