// Plugin to operate with google maps plugin
;(function ( $ ) {

    var latlng;
    var geocoder;
    var map;
    var recordCount=0;
    var originKey='';
    var currentUserPoint='';
    var bounds = new google.maps.LatLngBounds();
    var isCachedGeocoding = false;
    var destinationsMap = {};
    var inputDataHash={};


       //TODO: Let's refactor internal data by passing data via javascript
    function populateInternalData(){
        var addresses=[];
        var titles=[];
        var descriptions=[];
        var lats=[];
        var lngs=[];
        inputDataHash={};

        $(this.window.document).find('*[data=location]').each(function(key, value) {
            //We are inside.Let's search for inner elements and add them to array
            var hasNodeSetOrigin=false;
            $(this).find('*[data=origin]').each(function (key, value) {
                hasNodeSetOrigin = true;

            });


            $(this).find('*[data=address]').each(function (key, value) {
                addresses.push(value.innerHTML);
                //Set origin key if
                if (hasNodeSetOrigin == true) {
                    originKey = value.innerHTML;
                }
            });


            $(this).find('*[data=title]').each(function(key, value) {
                titles.push(value.innerHTML);
            });

            $(this).find('*[data=description]').each(function(key, value) {
                descriptions.push(value.innerHTML);
            });

            $(this).find('*[data=lat]').each(function(key, value) {
                lats.push(parseFloat(value.innerHTML));
            });

            $(this).find('*[data=lng]').each(function(key, value) {
                lngs.push(parseFloat(value.innerHTML));
            });
        });
        recordCount = addresses.length;
        //Create external hash of data
        for (var i = 0; i < addresses.length; i++) {
            if (lats.length == 0 || lngs.length == 0) {
                inputDataHash[addresses[i]] = [titles[i], descriptions[i]];
            }
            else {
                inputDataHash[addresses[i]] = [titles[i], descriptions[i], lats[i], lngs[i]];
                isCachedGeocoding=true;
            }
        }
    }

    $.fn.showRoutes = function(cashedGeocoding, data) {

        //Let's build the addresses and geocode them if necessary
        //populateInternalData();


       //Populate internal module variables with data
        var addresses = data.addresses;
        var titles = data.titles;
        var descriptions = data.descriptions;
        var lats = data.lats;
        var lngs = data.lngs;
        recordCount = addresses.length;
        inputDataHash={};
        //Create external hash of data
        for (var i = 0; i < addresses.length; i++) {
            if (lats.length == 0 || lngs.length == 0) {
                inputDataHash[addresses[i]] = [titles[i], descriptions[i]];
            }
            else {
                inputDataHash[addresses[i]] = [titles[i], descriptions[i], lats[i], lngs[i]];
                isCachedGeocoding=true;
            }
        }
        //First item of array is a origin address
        originKey=addresses[0];

        geocoder = new google.maps.Geocoder();

        var index = 0;
        isCachedGeocoding=cashedGeocoding;

        if (geocoder) {
            for (var addr in inputDataHash) {
                //TODO.We don't need to geocode if latitude/longtidute is set up.Otherwise let's got it from google
                //Check whether we don't provide cached long/att
                if (!isCachedGeocoding) {
                    (function (address, ind) {
                        geocoder.geocode({'address': address}, function (results, status) {
                            if (status == google.maps.GeocoderStatus.OK) {

                                //Populate external structure with request result.So value[2] is a response.

                                var hashValue = inputDataHash[address];
                                hashValue.push(results[0]);
                                inputDataHash[address] = hashValue;

                                //If last request is processed then let's show it on the map.
                                if (ind == recordCount - 1) {
                                    visualizeMap(inputDataHash);

                                }

                            } else {
                                alert("Geocode was not successful for the following reason: " + status);
                            }
                        });
                    })(addr, index);
                }
                //Populate found data with hash
                else {
                    (function (address) {
                        var value = inputDataHash[address];

                        var result = {"formatted_address": address,
                            "geometry": {
                                "location": {
                                    "lat":  value[2],
                                    "lng": value[3]
                                },

                                "location_type": "ROOFTOP",
                                "viewport": {
                                    "northeast": {
                                        "lat": value[2],
                                        "lng": value[3]
                                    },
                                    "southwest": {
                                        "lat": value[2],
                                        "lng": value[3]
                                    }
                                }
                            },
                            "types": [ "street_address" ]
                        };
                        value.push(result);
                        inputDataHash[address] = value;

                    })(addr);

                }
                index = index + 1;
            }
        }

        //Visualize map at the end of function when we have cache, otherwise last request will do it instead of us.
        if (isCachedGeocoding) {
            visualizeMap(inputDataHash);
        }
    }

// START: Set of wrappers to simplify refactoring
    function getLocationLat(item) {
        return item.geometry.location.lat();
    }


    function getLocationLng(item) {
        return  item.geometry.location.lng();
    }

    function getLocation(item) {
        return item.geometry.location;
    }
// END: Set of wrappers to simplify refactoring


//Addresses were generated.Let's show them on the map
    function getMapCenter(inputDataHash) {
        var avgLat = 0;
        var avgLng = 0;
        for (var key in inputDataHash) {
            avgLat += getLocationLat(inputDataHash[key][4]);
            avgLng += getLocationLng(inputDataHash[key][4]);
        }
        avgLat = avgLat / inputDataHash.length;
        avgLng = avgLng / inputDataHash.length;

        // center of the map (compute the mean value between the two locations)

        return new google.maps.LatLng(avgLat, avgLng);
    }

    function visualizeMap(inputDataHash) {

        latlng = getMapCenter(inputDataHash);
        // set map options
        // set zoom level
        // set center
        // map type
        var mapOptions =
        {
            zoom: 6,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };



        // create a new map object
        // set the div id where it will be shown
        // set the map options
        map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

        // generate routes between map points
        directionsService = new google.maps.DirectionsService();
        directionsDisplay = new google.maps.DirectionsRenderer(
            {
                suppressMarkers: true,
                suppressInfoWindows: true
            });
        directionsDisplay.setMap(map);
        distance = '';
        var index = 0;

        for (var key in inputDataHash) {
            (function (key, index) {

                var request = {
                    origin: getLocation(inputDataHash[originKey][4]),
                    destination: getLocation(inputDataHash[key][4]),
                    travelMode: google.maps.DirectionsTravelMode.DRIVING
                };
                directionsService.route(request, function (response, status) {
                    if (status == google.maps.DirectionsStatus.OK) {

                        //Add to result cache the destination structure
                        var value = inputDataHash[key];
                        value.push(response);
                        inputDataHash[key] = value;

                        //Populate destination map. We can use the same hash to associate
                        destinationsMap[response.routes[0].legs[0].end_address] = response;
                        //We need to add a condition to check whether array of responses is received
                        directionsDisplay.setDirections(response);

                        if (index == recordCount-1) {
                            drawSign(inputDataHash);

                        }
                    }
                });
            })(key, index);
            index = index + 1;
        }

        google.maps.event.trigger(map, 'resize');



    }


    function drawSign(inputDataHash) {
        var index = 0;
        for (var key in inputDataHash) {
            drawMarker(getLocation(inputDataHash[key][4]), inputDataHash[key][0], inputDataHash[key][1]);
            showSteps(inputDataHash[key][5]);
            index = index + 1;
        }
     }

//For each step we need to draw polyline
    function showSteps(directionResult) {
        var myRoute = directionResult.routes[0];
        var locationArray = []
        for (var j = 0; j < myRoute.legs.length; j++) {
            for (var i = 0; i < myRoute.legs[j].steps.length; i++) {
                if (i > 0) {
                    locationArray = [myRoute.legs[j].steps[i - 1].start_point, myRoute.legs[j].steps[i].start_point];
                }
                //Connect last step of previous leg with first step of current leg
                if (i == 0 && j > 0) {
                    locationArray = [myRoute.legs[j - 1].steps[myRoute.legs[j].steps.length - 1].start_point, myRoute.legs[j].steps[i].start_point];
                }
                //write line
                var polyline = new google.maps.Polyline({
                    map: map,
                    path: locationArray,
                    strokeWeight: 7,
                    strokeOpacity: 0.8,
                    strokeColor: "#FFFF00",
                    geodesic: true
                });
                google.maps.event.addListener(polyline, 'click', function () {
                    var infowindow = new google.maps.InfoWindow({content: "test"});
                    infowindow.open(map, this);
                });
            }
        }
    }

    function getRouteDistance(route) {

        var distance = 0;
        for (var j = 0; j < route.legs.length; j++) {
            distance += route.legs[j].distance;
        }
        distance /= 1000;
        return distance;
    }

//Responsible for generating marker window content
    function getMarkerInfoWindowContent(index, title, description){
        var content='<div style="width:200px;height:150px;font-color:green"><h3>' + title + '</h3><div></div>'+description+'</div></div>';
        return content;
    }

    function drawMarker(location, title, description, isOrigin) {
        var index = 0;
        for (var key in inputDataHash) {

            //Draw markers
            var marker = new google.maps.Marker({
                map: map,
                position: location,
                title: title
            });

            //Set specific marker color for user location
            if (isOrigin == true) {
                marker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');
            }

            // add action events so the info windows will be shown when the marker is clicked
            google.maps.event.addListener(marker, 'click', function (i) {
                var infowindow = new google.maps.InfoWindow({content: "loading..."});
                infowindow.setContent(getMarkerInfoWindowContent(title, description))
            });

            bounds.extend(getLocation(inputDataHash[key][4]));

        }
    }

    //Get shortest distance and returns hash
    $.fn.calculateShortestDistanceLocationName = function (inputDataHash) {
        var minDistance = 0;
        var minDestinationName = '';

        //Let's iterate over ready points
        for (var k in inputDataHash) {
            var distance = getRouteDistance(inputDataHash[k][5].routes[0]);
            if (minDistance == 0 || minDistance > 0 && distance < minDistance) {
                minDistance = distance;
                minDestinationName = k;
            }
        }
        return {'location': minDestinationName, 'distance': minDistance};
    }
}(jQuery));