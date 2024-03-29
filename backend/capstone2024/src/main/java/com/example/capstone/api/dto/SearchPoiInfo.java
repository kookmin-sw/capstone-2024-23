package com.example.capstone.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
public class SearchPoiInfo {
    private int totalCount;
    @JsonProperty("pois")
    private Pois pois;
}
