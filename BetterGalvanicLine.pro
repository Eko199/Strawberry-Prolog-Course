program([
	vhod(1),
	sklad(0),
	degrease(2 * 60),
	miene(10),
	bayts(14 * 60),
	ikonom(10),
	miene(10),
	miene(10),
	reduktor(2 * 60),
	miene(10),
	miene(10),
	aktivator(4 * 60),
	ikonom(10),
	miene(10),
	miene(10),
	link_Cu(5 * 60),
	miene(10),
	miene(10),
	elektro_Cu(27 * 60),
	ikonom(10),
	miene(10),
	miene(10),
	end(1)
]).

vana(vhod, 2, 30, rgb(255, 255, 0)).
vana(sklad, 8, 30, rgb(255, 255, 255)).
vana(degrease, 1, 50, rgb(255, 200, 200)).
vana(miene, 1, 40, rgb(0, 255, 255)).
vana(bayts, 2, 50, rgb(100, 50, 50)).
vana(ikonom, 1, 40, rgb(0, 255, 255)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(reduktor, 1, 40, rgb(0, 255, 0)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(aktivator, 1, 40, rgb(80, 40, 0)).
vana(ikonom, 1, 40, rgb(0, 255, 255)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(link_Cu, 1, 40, rgb(0, 128, 0)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(elektro_Cu, 4, 40, rgb(0, 0, 255)).
vana(ikonom, 1, 40, rgb(0, 255, 255)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(end, 1, 40, rgb(255, 255, 0)).

?-
	G_Multiplier := 10,
	G_Speed := 10,
	G_Robot := 50,
	G_Hanger := 0,
	G_Time := 0,
	G_Plan_Br := 0,

	array(vana_pos, 100, 0),

	array(vana_hanger, 100, 0),
	init_array(vana_hanger, 1, [1, 2, 3]),

	array(vana_name, 100, ""),
	init_vana,

	array(hanger_where, 1000, 0),
	array(hanger_time, 1000, 0),	
	array(hanger_operation, 1000, 0),
	init_array(hanger_operation, 1, [0, 0, 1]),

	array(program_name, 50, ""),
	array(program_stay, 50, 0),
	program(Commands),
	init_program(0, Commands),

	array(plan, 20, 0),
	init_array(plan, 0, [3, 11, 2, 1, 3]),

	window(title("Galvanic line"), size(1500, 500), paint_indirectly).

win_func(init) :-
	Timer := set_timer(_, 0.04, time_func).

%Paint the baths
win_func(paint) :-
	Pos := 50,
	vana(Name, Num, Size, Color),

	brush(Color),
	rect(Pos, 50, Pos + Num * Size, 200),

	Pos := Pos + Num * Size,
	fail.

%Paint the robot
win_func(paint) :-
	brush(rgb(255, 255, 0)),
	fill_polygon(G_Robot, 50, G_Robot + 30, 10, G_Robot - 30, 10),

	(G_Hanger > 0 -> 
		text_out(G_Hanger, pos(G_Robot - 2, 15))
	),
	fail.

%Paint the bath and hanger enumerations
win_func(paint) :-
	for(I, 1, G_N),
		text_out(I, pos(vana_pos(I) - 10, 70)),
		(vana_hanger(I) > 0 ->
			text_out(vana_hanger(I), pos(vana_pos(I) - 10, 120))
		),
		fail.

%Operate the robot
time_func(end) :-
	Elapsed_Time := chronometer() * G_Multiplier,
	G_Time := G_Time + Elapsed_Time,
	make_operations(Elapsed_Time),
	set_window_text,
	update_window(_).

make_operations(Elapsed_Time) :-
	Vana := plan(G_Plan_Br),
	(Vana > 0 -> 
		Hanger := vana_hanger(Vana),
		(Hanger > 0 -> 
			take(Vana, Hanger, Elapsed_Time)
		else
			bring(Vana, Elapsed_Time)
		)
	).

take(Vana, Hanger, Elapsed_Time) :-
	Time_to_go := abs(vana_pos(Vana) - G_Robot) / G_Speed,
	Wait_time := max(0, hanger_time(Hanger) - Time_to_go),
	Remainder := Elapsed_Time - (Wait_time + Time_to_go),
	(Remainder < 0 -> 
		G_Robot := G_Robot + max(0, Elapsed_Time - Wait_time) * G_Speed,
		hanger_time(Hanger) := hanger_time(Hanger) - Elapsed_Time
	else
		hanger_operation(Hanger) := hanger_operation(Hanger) + 1,
		G_Robot := vana_pos(Vana),
		G_Hanger := vana_hanger(Vana),
		vana_hanger(Vana) := 0,
		bring(Vana, Remainder)
	).

bring(Vana, Remainder) :-
	Operation := hanger_operation(G_Hanger),
	Name := program_name(Operation),
	find_vana(New, Vana, Name),
	write(New + ", ").

find_vana(New, Vana, Name) :-
	Next := Vana + 1,
	(vana_name(Next) =:= Name, vana_hanger(Next) =:= 0 -> 
		New := Next
	else
		find_vana(New, Next, Name)
	).

%Initialize the array of bath enumerations
init_vana :-
	Pos := 50,
	G_N := 0,
	vana(Name, Num, Size, Color),
	for(I, 1, Num),		
		G_N := G_N + 1,
		vana_pos(G_N) := Pos + Size / 2,
		vana_name(G_N) := Name,
		Pos := Pos + Size,
		fail.
	init_vana.

%Initialize array with recursion

init_array(Array, Pos, [Head | Tail]) :-
	Array(Pos) := Head,
	init_array(Array, Pos + 1, Tail).

%Recursion bottom
init_array(_, _, []).

%Initialize programs with name and stay duration in seconds
init_program(N, [Head | Tail]) :- 
	Head = Name(Stay),
	program_name(N) := Name,
	program_stay(N) := Stay,
	init_program(N + 1, Tail).

init_program(_, []).

set_window_text :-
	set_text("Galvanic Line " + integer(G_Time) + " x " + G_Multiplier, _).