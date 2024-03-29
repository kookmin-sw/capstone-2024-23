package com.example.capstone.api.service;

import com.example.capstone.api.dto.TmapGeoCodingResponseDto;
import com.example.capstone.api.dto.TmapPoiResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;
import org.springframework.web.client.RestTemplate;

import java.net.URI;

@Service
@RequiredArgsConstructor
public class PoiService {

    private final RestTemplate restTemplate;
    private final UriBuilderService uriBuilderService;

    private static final String APPKEY = "qnMdq4E5hK6Jiying7vO84rBBYBMqE0L8JibODZN";

    public TmapPoiResponseDto requestPoi(String address) {
        if (ObjectUtils.isEmpty(address)) return null;

        URI uri = uriBuilderService.buildUriPoiByCoord(address);

        HttpHeaders headers = new HttpHeaders();
        headers.set("appKey", APPKEY);

        HttpEntity<Object> httpEntity = new HttpEntity<>(headers);

        //api 호출

        TmapPoiResponseDto body2 = restTemplate.exchange(uri, HttpMethod.GET, httpEntity, TmapPoiResponseDto.class).getBody();
        return body2;
    }

}
