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
    public Properties checkPede(@RequestParam("startLat") String startLat
                           , @RequestParam("startLon") String startLon
            , @RequestParam(value = "endAddress") String endAddress) throws Exception {
        System.out.println("startLat = " + startLat);
        System.out.println("startLon = " + startLon);
        System.out.println("endAddress = " + endAddress);
        Properties properties = new Properties();
        TmapPedestrianResponseDto tmapPedestrianResponseDto = pedestrianService.requestPedestrian(startLat, startLon, endAddress);
        properties.setTotalDistance(tmapPedestrianResponseDto.getFeatures().getFirst().getProperties().getTotalDistance());
        properties.setTotalTime(tmapPedestrianResponseDto.getFeatures().getFirst().getProperties().getTotalTime());
        return properties;
    }

    @GetMapping("/start-navi")
    public Properties confirmPede(@RequestParam("startLat") String startLat
            , @RequestParam("startLon") String startLon
            , @RequestParam("endAddress") String endAddress
            ,@RequestParam("uuid") String uuid) throws Exception {
        System.out.println("startLat = " + startLat);
        System.out.println("startLon = " + startLon);
        System.out.println("endAddress = " + endAddress);
        System.out.println("uuid = " + uuid);
        TmapPedestrianResponseDto tmapPedestrianResponseDto = pedestrianService.startPedestrianNavi(startLat, startLon, endAddress, uuid);
        Properties properties = new Properties();
        properties.setPointIndex(1);
        properties.setDescription("경로 안내를 시작 합니다."+tmapPedestrianResponseDto.getFeatures().getFirst().getProperties().getDescription());
        return properties;
    }

    @GetMapping("/poi")
    public Poi poiTest(@RequestParam("address") String address){
        Poi testBody;
        testBody = poiService.requestPoi(address).getSearchPoiInfo().getPois().getPoi().get(0);
        return testBody;
    }

    @GetMapping("/current-location")
    public DistanceInfo currentLocation(@RequestParam("curLat") String curLat,
                       @RequestParam("curLon") String curLon,
                       @RequestParam("uuid") String uuid,
                       @RequestParam("pointIndex") int pointIndex){

        return pedestrianService.currentLocationCheck(curLat, curLon, uuid, pointIndex);
    }


    @GetMapping("/cancel-navi")
    public String cancelNavi(@RequestParam("uuid") String uuid){
        pedestrianService.cancelNavi(uuid);

        return uuid + " 관련 모든 경로 삭제 완료";
    }


}
