?-
	G_Robot := 50,
	window(title("Galvanic line"), size(1200, 500), paint_indirectly).

win_func(init) :-
	Timer := set_timer(_, 0.1, time_func).

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
	wait(0.1),
	fail.

time_func(end) :-
	G_Robot := G_Robot + 1,
	update_window(_).
	

vana(bayts, 2, 50, rgb(100, 50, 50)).
vana(miene, 3, 30, rgb(0, 255, 255)).