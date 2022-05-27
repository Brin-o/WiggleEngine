shader_type canvas_item;

uniform vec4 c1 : hint_color;
uniform vec4 c2 : hint_color;
uniform vec4 c3 : hint_color;
uniform vec4 c4 : hint_color;
uniform vec4 c5 : hint_color;
uniform vec4 c6 : hint_color;
uniform vec4 c7 : hint_color;
uniform vec4 c8 : hint_color;

void fragment()
{
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	float rgb_avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	if (COLOR.r > 0.94) {
		COLOR = c1;
	} else if (COLOR.r > 0.74){
		COLOR = c2;
	}else if (COLOR.r > 0.61){
		COLOR = c3;
	}else if (COLOR.r > 0.50){
		COLOR = c4;
	}else if (COLOR.r > 0.37){
		COLOR = c5;
	}else if (COLOR.r > 0.23){
		COLOR = c6;
	}else if (COLOR.r > 0.12){
		COLOR = c7;
	}else {
		COLOR = c8;
	}
	COLOR.a = texture(SCREEN_TEXTURE, SCREEN_UV).a;
}