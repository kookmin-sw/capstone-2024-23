package com.example.capstone.api.service;

import com.example.capstone.api.dto.*;
import com.example.capstone.api.model.Route;
import com.example.capstone.api.repository.RouteRepository;
import com.example.capstone.member.model.Member;
import com.example.capstone.member.repository.MemberRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;


@Service
@RequiredArgsConstructor
public class PedestrianService {
    private final RestTemplate restTemplate;
    private final UriBuilderService uriBuilderService;
    private final PoiService poiService;
    private final ObjectMapper objectMapper;
    private final RouteRepository routeRepository;
    private final MemberRepository memberRepository;

    private static final String APPKEY = "qnMdq4E5hK6Jiying7vO84rBBYBMqE0L8JibODZN";

    public TmapPedestrianResponseDto requestPedestrian(String startLat, String startLon, String endAddress) throws Exception {

        if (ObjectUtils.isEmpty(startLat) || ObjectUtils.isEmpty(startLon) || ObjectUtils.isEmpty(endAddress))
            return null;
        //lon 경도 X
        //lat 위도 Y
        TmapPoiResponseDto tmapPoiResponseDto = poiService.requestPoi(endAddress);

        String endLat = tmapPoiResponseDto.getSearchPoiInfo().getPois().getPoi().getFirst().getFrontLat();
        String endLon = tmapPoiResponseDto.getSearchPoiInfo().getPois().getPoi().getFirst().getFrontLon();


        System.out.println("변환 완료");
        System.out.println("startLat = " + startLat);
        System.out.println("startLon = " + startLon);
        System.out.println("endLat = " + endLat);
        System.out.println("endLon = " + endLon);
        URI uri = uriBuilderService.buildUriPedestrianByCoord();

        HttpHeaders headers = new HttpHeaders();
        headers.add("appKey", APPKEY);

        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("startX", startLon);
        requestBody.put("startY", startLat);
        requestBody.put("endX", endLon);
        requestBody.put("endY", endLat);
        requestBody.put("reqCoordType", "WGS84GEO");
        requestBody.put("startName", "출발지");
        requestBody.put("endName", endAddress);
        HttpEntity<Map<String, String>> entity = new HttpEntity<>(requestBody, headers);
//
        String jsonBody = objectMapper.writeValueAsString(requestBody);
        // 콘솔에 출력
        System.out.println("Request JSON Body: " + jsonBody);

        //api 호출

        // API 호출 및 응답 받기 (String 형태로)
        String rawResponse = restTemplate.exchange(uri, HttpMethod.POST, entity, String.class).getBody();

        // 불법 문자 전처리 (예제: Null 문자 제거)
        String cleanedResponse = rawResponse.replace("\u0000", "");

        // 전처리된 응답을 DTO로 변환
        TmapPedestrianResponseDto responseDto = objectMapper.readValue(
                cleanedResponse, TmapPedestrianResponseDto.class
        );




        return responseDto;
    }


    public TmapPedestrianResponseDto startPedestrianNavi(String startLat, String startLon, String endAddress, String uuid) throws Exception {
        if (ObjectUtils.isEmpty(startLat) || ObjectUtils.isEmpty(startLon) || ObjectUtils.isEmpty(endAddress) || ObjectUtils.isEmpty(uuid))
            return null;
        //lon 경도 X
        //lat 위도 Y
        TmapPoiResponseDto tmapPoiResponseDto = poiService.requestPoi(endAddress);

        String endLat = tmapPoiResponseDto.getSearchPoiInfo().getPois().getPoi().getFirst().getFrontLat();
        String endLon = tmapPoiResponseDto.getSearchPoiInfo().getPois().getPoi().getFirst().getFrontLon();


        System.out.println("변환 완료");
        System.out.println("startLat = " + startLat);
        System.out.println("startLon = " + startLon);
        System.out.println("endLat = " + endLat);
        System.out.println("endLon = " + endLon);
        URI uri = uriBuilderService.buildUriPedestrianByCoord();

        HttpHeaders headers = new HttpHeaders();
        headers.add("appKey", APPKEY);

        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("startX", startLon);
        requestBody.put("startY", startLat);
        requestBody.put("endX", endLon);
        requestBody.put("endY", endLat);
        requestBody.put("reqCoordType", "WGS84GEO");
        requestBody.put("startName", "출발지");
        requestBody.put("endName", endAddress);
        HttpEntity<Map<String, String>> entity = new HttpEntity<>(requestBody, headers);
//
        // 콘솔에 출력
        String jsonBody = objectMapper.writeValueAsString(requestBody);
        System.out.println("Request JSON Body: " + jsonBody);


        // API 호출 및 응답 받기 (String 형태로)
        String rawResponse = restTemplate.exchange(uri, HttpMethod.POST, entity, String.class).getBody();

        // 불법 문자 전처리 (예제: Null 문자 제거)
        String cleanedResponse = rawResponse.replace("\u0000", "");

        // 전처리된 응답을 DTO로 변환
        TmapPedestrianResponseDto responseDto = objectMapper.readValue(cleanedResponse, TmapPedestrianResponseDto.class)
                .filteredPoint();
        System.out.println();
        List<Route> entities = responseDto.toEntities();

        Member member = memberRepository.findByUuid(uuid).getFirst();
        for (Route e : entities) {
            e.setMember(member);
        }
        routeRepository.saveAll(entities);
        return responseDto;
    }

    public DistanceInfo currentLocationCheck(String curLat, String curLon,
                                                    String uuid, int pointIndex){

        List<Route> path = routeRepository.findByMemberUuid(uuid);
        String nextLon = path.get(pointIndex).getLon();
        String nextLat = path.get(pointIndex).getLat();

        URI uri = uriBuilderService.buildUriDistanceInfo(curLon, curLat, nextLon, nextLat);
        HttpHeaders headers = new HttpHeaders();
        headers.set("appKey", APPKEY);

        HttpEntity<Object> httpEntity = new HttpEntity<>(headers);

        //api 호출
        DistanceResponseDTO body = restTemplate.exchange(uri, HttpMethod.GET, httpEntity, DistanceResponseDTO.class).getBody();

        DistanceInfo info = new DistanceInfo();
        int dist = Integer.parseInt(body.getDistanceInfo().getDistance());
        if (dist <= 3){
            info.setDistance(String.valueOf(dist));
            info.setPointIndex(pointIndex+1);
            info.setDescription(path.get(pointIndex).getDescription());
            info.setLat(nextLat);
            info.setLon(nextLon);
            return info;
        }
        else {
            info.setDistance(String.valueOf(dist));
            info.setPointIndex(pointIndex);
            info.setDescription("이동중");
            info.setLat(nextLat);
            info.setLon(nextLon);
            return info;
        }

    }
    public void cancelNavi(String uuid){
        routeRepository.deleteAllByMemberUuid(uuid);
        System.out.println("uuid = " + uuid + "삭제 중");
    }

}
