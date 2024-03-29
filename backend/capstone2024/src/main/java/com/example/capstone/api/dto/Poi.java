package com.example.capstone.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class Poi {
    @JsonProperty("frontLat")
    private String frontLat;
    @JsonProperty("frontLon")
    private String frontLon;
}
