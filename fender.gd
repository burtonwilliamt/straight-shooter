@tool
extends StaticBody2D

@export var length: int = 100:
    set(new):
        length = new
        %Shape.shape.height = new