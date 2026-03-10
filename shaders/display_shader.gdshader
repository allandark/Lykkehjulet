shader_type canvas_item;

// Base color (use TEXTURE for Sprite2D or COLOR for ColorRect)
uniform vec4 base_color : source_color = vec4(1.0);
uniform float glossiness : hint_range(0.0, 1.0) = 0.8;
uniform float specular_strength : hint_range(0.0, 1.0) = 0.5;
// Light position (normalized 0-1)
uniform vec2 light_pos = vec2(0.3, 0.3);

void fragment() {
    // Use texture color if available, otherwise use base_color
    vec4 color = texture(TEXTURE, UV) * base_color;

    // Calculate distance from light position
    float light_dist = distance(UV, light_pos);

    // Create a specular highlight (closer to light = brighter)
    float spec = pow(1.0 - light_dist, glossiness * 10.0);
    spec *= specular_strength;

    // Add highlight to color (preserve base color)
    color.rgb += spec;

    // Clamp to avoid overbrightening
    color.rgb = min(color.rgb, 1.0);

    COLOR = color;
}
