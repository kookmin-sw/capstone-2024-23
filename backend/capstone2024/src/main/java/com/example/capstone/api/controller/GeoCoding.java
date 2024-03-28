package com.example.capstone.api.controller;

import com.example.capstone.api.dto.*;
import com.example.capstone.api.service.GeoCodingService;
import com.example.capstone.api.service.PedestrianService;
import com.example.capstone.api.service.PoiService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class GeoCoding {

    private final GeoCodingService geoCodingService;
    private final PedestrianService pedestrianService;
    private final PoiService poiService;
    @GetMapping("/address-to-coord")
    public Coordinate testGPS(@RequestParam("address") String address){
        Coordinate coordinate;
        coordinate = geoCodingService.requestGeoCoding(address).getCoordinateInfo().getCoordinate().get(0);
        return coordinate;
    }

    @GetMapping("/find-way")
    public TmapPedestrianResponseDto checkPede(@RequestParam("startLat") String startLat
                           , @RequestParam("startLon") String startLon
            , @RequestParam(value = "endAddress") String endAddress) throws Exception {
        System.out.println("startLat = " + startLat);
        System.out.println("startLon = " + startLon);
        System.out.println("endAddress = " + endAddress);
        return pedestrianService.requestPedestrian(startLat,startLon,endAddress);
    }

    @GetMapping("/start-navi")
    public TmapPedestrianResponseDto confirmPede(@RequestParam("startLat") String startLat
            , @RequestParam("startLon") String startLon
            , @RequestParam("endAddress") String endAddress
            ,@RequestParam("uuid") String uuid) throws Exception {
        System.out.println("startLat = " + startLat);
        System.out.println("startLon = " + startLon);
        System.out.println("endAddress = " + endAddress);
        return pedestrianService.requestPedestrian(startLat,startLon,endAddress);
    }

    @GetMapping("/poi")
    public Poi poiTest(@RequestParam("address") String address){
        Poi testBody;
        testBody = poiService.requestPoi(address).getSearchPoiInfo().getPois().getPoi().get(0);
        return testBody;
    }

    @GetMapping("/current-location")
    public Poi currentLocation(@RequestParam("curLat") String curLat,
                       @RequestParam("curLon") String curLon,
                       @RequestParam("uuid") String uuid,
                       @RequestParam("nodeIndex") int nodeIndex){

        return null;
    }

    @GetMapping("/cancel-navi")
    public void cancelNavi(){


    }


}
