package com.example.capstone.api.service;

import com.example.capstone.api.dto.Feature;
import com.example.capstone.api.dto.TmapGeoCodingResponseDto;
import com.example.capstone.api.dto.TmapPedestrianResponseDto;
import com.example.capstone.api.dto.TmapPoiResponseDto;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.ObjectUtils;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PedestrianService {
    private final RestTemplate restTemplate;
    private final UriBuilderService uriBuilderService;
    private final PoiService poiService;
    private final ObjectMapper objectMapper;
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
        TmapPedestrianResponseDto responseDto = objectMapper.readValue(cleanedResponse, TmapPedestrianResponseDto.class);

        return responseDto;
    }


}
