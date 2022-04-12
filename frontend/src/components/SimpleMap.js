import React, {useEffect, useState} from 'react'
import {GoogleMap, Marker, useJsApiLoader} from '@react-google-maps/api';

const containerStyle = {
    width: '1500px',
    height: '650px'
};

const center = {
    lat: 39.933365,
    lng: 32.859741
};


function SimpleMap({long, lat}) {
    const { isLoaded } = useJsApiLoader({
        id: 'google-map-script',
        googleMapsApiKey: "AIzaSyBzTyHFB3HRvb_CpekdzK9Y4htx6nxF0w0"
    })

    useEffect(() => {
        setMarkers( current => [...current, {
            lat: parseFloat(lat),
            lng: parseFloat(long),
            time: new Date()
        }])
    }, []); // eslint-disable-line react-hooks/exhaustive-deps


    const [map, setMap] = React.useState(null)
    const [markers, setMarkers] = useState([]);

    const onLoad = React.useCallback(function callback(map) {
        const bounds = new window.google.maps.LatLngBounds();
        map.fitBounds(bounds);
        setMap(map)
    }, [])

    const onUnmount = React.useCallback(function callback(map) {
        setMap(null)
    }, [])

    console.log(markers);

    return isLoaded ? (
        <GoogleMap
            mapContainerStyle={containerStyle}
            center={center}
            zoom={10}
            onLoad={onLoad}
            onUnmount={onUnmount}
            onClick={(event) => {
                setMarkers( current => [...current, {
                    lat: event.latLng.lat(),
                    lng: event.latLng.lng(),
                    time: new Date()
                }])
            }}
        >

            {
                markers.map((marker) => (
                    <Marker
                        key={marker.time.toISOString()}
                        position={{lat: marker.lat, lng: marker.lng}}
                    />
                ))
            }
            <></>
        </GoogleMap>
    ) : <></>
}

export default SimpleMap;