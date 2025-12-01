//
//  HKWorkoutActivityType+Mapping.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 01/12/25.
//

import Foundation
import HealthKit

extension HKWorkoutActivityType {

    var displayName: String {
        switch self {
        case .americanFootball: return "American Football"
        case .archery: return "Archery"
        case .australianFootball: return "Australian Football"
        case .badminton: return "Badminton"
        case .baseball: return "Baseball"
        case .basketball: return "Basketball"
        case .bowling: return "Bowling"
        case .boxing: return "Boxing"
        case .climbing: return "Climbing"
        case .cricket: return "Cricket"
        case .crossTraining: return "Cross Training"
        case .curling: return "Curling"
        case .cycling: return "Cycling"
        case .dance: return "Dance"
        case .danceInspiredTraining: return "Dance Training"
        case .elliptical: return "Elliptical"
        case .equestrianSports: return "Equestrian"
        case .fencing: return "Fencing"
        case .fishing: return "Fishing"
        case .functionalStrengthTraining: return "Functional Strength"
        case .golf: return "Golf"
        case .gymnastics: return "Gymnastics"
        case .handball: return "Handball"
        case .hiking: return "Hiking"
        case .hockey: return "Hockey"
        case .hunting: return "Hunting"
        case .jumpRope: return "Jump Rope"
        case .kickboxing: return "Kickboxing"
        case .lacrosse: return "Lacrosse"
        case .martialArts: return "Martial Arts"
        case .mindAndBody: return "Mind & Body"
        case .mixedMetabolicCardioTraining: return "Metabolic Cardio"
        case .paddleSports: return "Paddle Sports"
        case .pilates: return "Pilates"
        case .play: return "Play"
        case .preparationAndRecovery: return "Prep & Recovery"
        case .racquetball: return "Racquetball"
        case .rowing: return "Rowing"
        case .rugby: return "Rugby"
        case .running: return "Running"
        case .sailing: return "Sailing"
        case .skatingSports: return "Skating"
        case .snowboarding: return "Snowboarding"
        case .soccer: return "Soccer"
        case .softball: return "Softball"
        case .squash: return "Squash"
        case .stairClimbing: return "Stair Climbing"
        case .surfingSports: return "Surfing"
        case .swimming: return "Swimming"
        case .tableTennis: return "Table Tennis"
        case .tennis: return "Tennis"
        case .trackAndField: return "Track & Field"
        case .traditionalStrengthTraining: return "Strength Training"
        case .volleyball: return "Volleyball"
        case .walking: return "Walking"
        case .waterFitness: return "Water Fitness"
        case .wheelchairWalkPace: return "Wheelchair (Walk Pace)"
        case .wheelchairRunPace: return "Wheelchair (Run Pace)"
        case .yoga: return "Yoga"
        case .crossCountrySkiing: return "Cross-country Skiing"
        case .highIntensityIntervalTraining: return "HIIT"
        default:
            return "Workout"
        }
    }

    var sfSymbolName: String {
        switch self {
        case .running: return "figure.run"
        case .walking: return "figure.walk"
        case .cycling: return "bicycle"
        case .traditionalStrengthTraining, .functionalStrengthTraining: return "dumbbell"
        case .swimming: return "drop.fill"
        case .yoga, .mindAndBody: return "figure.cooldown"
        case .hiking: return "figure.hiking"
        case .rowing: return "figure.rower"
        case .elliptical: return "bolt.heart"
        case .dance, .danceInspiredTraining: return "music.note"
        case .highIntensityIntervalTraining: return "flame.fill"
        case .soccer: return "soccerball"
        case .basketball: return "basketball"
        case .tennis: return "tennisracket"
        case .golf: return "flag"
        case .boxing, .kickboxing, .martialArts: return "figure.martial.arts"
        default:
            return "figure.walk"
        }
    }
}

