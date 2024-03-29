package com.example.capstone.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Setter
@ToString
public class TmapPedestrianResponseDto {
    @JsonProperty("type")
    private String type;
    @JsonProperty("features")
    private List<Feature> features;

    public TmapPedestrianResponseDto filteredPoint() {
        final List<Feature> features = new ArrayList<>();
        for (Feature feature : this.features) {
            if (feature.getGeometry().getType().equalsIgnoreCase("point")) {
                features.add(feature);
            }
        }
        return new TmapPedestrianResponseDto(
                this.type,
                features
        );
    }
}

