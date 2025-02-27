shader_type canvas_item;

uniform float hit_opacity = 0;
uniform vec3 color_tint = vec3(1, 1, 1); // Default color is white

void fragment() {
    // Calculate the tinted color
    vec4 tex = texture(TEXTURE, UV);
    COLOR.rgb = tex.rgb * (1.0 - hit_opacity) + color_tint * hit_opacity;
    COLOR.a = tex.a;
}