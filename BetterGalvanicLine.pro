?-
	G_Multiplier := 10,
	G_Speed := 10,
	G_Robot := 50,
	array(vana_pos, 100, 0),
	array(vana_hanger, 100, 0),
	init_vana,
	window(title("Galvanic line"), size(1200, 500), paint_indirectly).

win_func(init) :-
	Timer := set_timer(_, 0.04, time_func).

win_func(paint) :-
	Pos := 50,
	vana(Name, Num, Size, Color),
	brush(Color),
	rect(Pos, 50, Pos + Num * Size, 200),
	Pos := Pos + Num * Size,
	fail.

win_func(paint) :-
	brush(rgb(255, 255, 0)),
	fill_polygon(G_Robot, 50, G_Robot + 30, 10, G_Robot - 30, 10),
	fail.

win_func(paint) :-
	for(I, 1, G_N),
		text_out(I, pos(vana_pos(I), 70)),
		(vana_hanger(I) > 0 ->
			text_out(vana_hanger(I), pos(vana_pos(I), 120))
		),
		fail.

time_func(end) :-
	Elapsed_Time := chronometer() * G_Multiplier,
	G_Robot := G_Robot + Elapsed_Time * G_Speed,
	update_window(_).

init_vana :-
	Pos := 50,
	G_N := 0,
	vana(Name, Num, Size, Color),
	for(I, 1, Num),		
		G_N := G_N + 1,
		vana_pos(G_N) := Pos + Size / 2,
		Pos := Pos + Size,
		fail.
	init_vana.

vana(bayts, 2, 50, rgb(100, 50, 50)).
vana(miene, 3, 30, rgb(0, 255, 255)).