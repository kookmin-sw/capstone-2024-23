package com.example.capstone.api.dto;

import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class TmapPedestrianResponseDtoTest {

    @Test
    @DisplayName("filteredPoint()를 호출하면 geometryType이 Point인 객체만 반환된다.")
    void test01() {
        Feature point1 = new Feature();
        point1.setGeometry(new Geometry("Point", null));
        Feature point2 = new Feature();
        point2.setGeometry(new Geometry("LineString", null));
        Feature point3 = new Feature();
        point3.setGeometry(new Geometry("아무 의미도 없는 값", null));
        Feature point4 = new Feature();
        point4.setGeometry(new Geometry("point", null));
        List<Feature> points = List.of(point1, point2, point3, point4);

        TmapPedestrianResponseDto temp = new TmapPedestrianResponseDto("temp", points);
        TmapPedestrianResponseDto result = temp.filteredPoint();
        Assertions.assertThat(result.getFeatures()).hasSize(2);
    }
}