// taper.fs
extern float taper_intensity; // 0.0 is normal, 0.5 is narrow top, -0.5 is wide top

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // 1. Center the X coordinate (shift 0.0->1.0 to -0.5->0.5)
    float x = texture_coords.x - 0.5;
    float y = texture_coords.y;

    // 2. Calculate the taper factor based on height
    // (1.0 - y) makes the top (y=0) affected most, and bottom (y=1) stay still
    float taper = 1.0 + (y * taper_intensity);

    // 3. Apply the scale to the centered X
    x /= taper;

    // 4. Shift X back to 0.0->1.0 range
    vec2 warped_coords = vec2(x + 0.5, y);

    // 5. Bounds check: If we're outside the screen (0-1), return transparent/black
    if (warped_coords.x < 0.0 || warped_coords.x > 1.0) {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }

    return Texel(texture, warped_coords) * color;
}