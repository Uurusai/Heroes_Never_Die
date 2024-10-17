extends Node


@export var crow_damage:int = 10
var player_body : CharacterBody2D 
var taking_damage: bool  = false 
var crow : CharacterBody2D
var enemy_attack : CharacterBody2D
var bat_bod :CharacterBody2D
var bat_damage : float = 5 
var player_damage : float = 10
@export var player_health:float = 30.0
@export var player_max_health : float = 30.0
@export var coin_max : float = 2.0
@export var coin_count : float = 0
