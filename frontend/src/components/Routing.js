//import "leaflet-routing-machine/dist/leaflet-routing-machine.css";
//import "leaflet-routing-machine";
import {Marker, Popup, useMap} from "react-leaflet";
import React, {useEffect} from "react";
import L from "leaflet";


export default function Routing({source, destination}) {
    const map = useMap();

    useEffect(() => {
        if (!map) return;

        const routingControl = L.Routing.control({
            waypoints: [L.latLng(source), L.latLng(destination)], //[L.latLng(source), L.latLng(destination)],
            routeWhileDragging: true
        }).addTo(map);

        return () => map.removeControl(routingControl);
    }, [map]);

    return null;
}