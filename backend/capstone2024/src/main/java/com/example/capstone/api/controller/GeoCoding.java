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
    public Coordinate testGPS(@RequestParam(value = "address") String address){
        Coordinate coordinate;
        coordinate = geoCodingService.requestGeoCoding(address).getCoordinateInfo().getCoordinate().getFirst();
        return coordinate;
    }

    @GetMapping("/find-way")
    public TmapPedestrianResponseDto testPede(@RequestParam("startLat") String startLat
                           , @RequestParam("startLon") String startLon
            , @RequestParam(value = "endAddress") String endAddress) throws Exception {
        System.out.println("startLat = " + startLat);
        System.out.println("startLon = " + startLon);
        System.out.println("endAddress = " + endAddress);
        return pedestrianService.requestPedestrian(startLat,startLon,endAddress);
    }

    @GetMapping("/test-poi")
    public Poi poiTest(@RequestParam(value = "address") String address){
        Poi testBody;
        testBody = poiService.requestPoi(address).getSearchPoiInfo().getPois().getPoi().getFirst();
        return testBody;
    }

}
