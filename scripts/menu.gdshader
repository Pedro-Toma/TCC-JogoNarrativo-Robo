shader_type canvas_item;

uniform vec2 speed = vec2(0.01, 0.0); 

void fragment() {
    COLOR = texture(TEXTURE, fract(UV + speed * TIME));
}
