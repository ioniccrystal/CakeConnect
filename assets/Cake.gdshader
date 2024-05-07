shader_type canvas_item;

void fragment() {
	float outline_size = 0.02; // 轮廓的厚度
	vec4 outline_color = vec4(0.0, 1.0, 0.0, 1.0); // 轮廓颜色，红色

	vec2 offsets[8] = vec2[](
		vec2(-outline_size, outline_size), // 上左
		vec2(0, outline_size), // 上
		vec2(outline_size, outline_size), // 上右
		vec2(-outline_size, 0), // 左
		vec2(outline_size, 0), // 右
		vec2(-outline_size, -outline_size), // 下左
		vec2(0, -outline_size), // 下
		vec2(outline_size, -outline_size) // 下右
	);

	 float alpha = texture(TEXTURE, UV).a;
    float max_alpha = 0.0;

    // 检查周围像素的透明度
    for (int i = 0; i < 8; i++) {
        max_alpha = max(max_alpha, texture(TEXTURE, UV + offsets[i]).a);
    }

    if (alpha < 0.01 && max_alpha > 0.01) {
        COLOR = outline_color;
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}
