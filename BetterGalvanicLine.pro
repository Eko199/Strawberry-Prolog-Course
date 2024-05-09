program([
	vhod(1),
	sklad(0),
	degrease(2 * 60),
	miene1(10),
	bayts(14 * 60),
	ikonom1(10),
	miene2(10),
	miene3(10),
	reduktor(2 * 60),
	miene4(10),
	miene5(10),
	aktivator(4 * 60),
	ikonom2(10),
	miene6(10),
	miene7(10),
	link_Cu(5 * 60),
	miene8(10),
	miene9(10),
	elektro_Cu(27 * 60),
	ikonom3(10),
	miene10(10),
	miene11(10),
	end(1)
]).

vana(vhod, 2, 30, rgb(255, 255, 0)).
vana(sklad, 8, 30, rgb(255, 255, 255)).
vana(degrease, 1, 50, rgb(255, 200, 200)).
vana(miene, 1, 40, rgb(0, 255, 255)).
vana(bayts, 2, 50, rgb(100, 50, 50)).
vana(ikonom1, 1, 40, rgb(0, 255, 255)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(reduktor, 1, 40, rgb(0, 255, 0)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(aktivator, 1, 40, rgb(80, 40, 0)).
vana(ikonom2, 1, 40, rgb(0, 255, 255)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(link_Cu, 1, 40, rgb(0, 128, 0)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(elektro_Cu, 4, 40, rgb(0, 0, 255)).
vana(ikonom3, 1, 40, rgb(0, 255, 255)).
vana(miene, 2, 40, rgb(0, 255, 255)).
vana(end, 1, 40, rgb(255, 255, 0)).

important(degrease, 3).
important(bayts, 5).
important(reduktor, 1).

?-
	G_Multiplier := 20,
	G_Speed := 10,
	G_Robot := 50,
	G_Hanger := 0,
	G_Time := 0,
	G_Plan_Br := 0,
	G_MaxResult := min_integer,
	G_Stop_Time := 1200,

	array(vana_pos, 100, 0),

	array(vana_hanger, 100, 0),

	array(vana_name, 100, ""),
	init_vana,

	array(hanger_where, 1000, 0),
	array(hanger_when, 1000, 0),	
	array(hanger_operation, 1000, 0),
	init_array(vana_hanger, 3, [1, 2, 3, 4]),
	init_array(hanger_operation, 1, [1, 1, 1, 1]),

	array(program_name, 50, ""),
	array(program_stay, 50, 0),
	array(program_important, 50, 0),
	program(Commands),
	init_program(0, Commands),

	array(plan, 120, 0),
	%init_array(plan, 0, [3, 11, 2, 1, 3, 12, 11, 12, 13, 4, 15, 11, 12, 14]),
	array(first_plan, 120, 0),
	Result := 0,
	(make_plan(G_Time, G_Stop_Time, Result); true),
	chronometer(),

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
	make_operations(G_Time, Elapsed_Time),
	set_window_text,
	update_window(_).

make_operations(Current_Time, Elapsed_Time) :-
	Vana := plan(G_Plan_Br),
	(Vana > 0 -> 
		Hanger := vana_hanger(Vana),
		(Hanger > 0 -> 
			take(Vana, Hanger, Current_Time, Elapsed_Time)
		else
			bring(Vana, Current_Time, Elapsed_Time)
		)
	).

take(Vana, Hanger, Current_Time, Elapsed_Time) :-
	Time_to_go := abs(vana_pos(Vana) - G_Robot) / G_Speed,
	Wait_time := max(0, hanger_when(Hanger) - Current_Time - Time_to_go),
	Remainder := Elapsed_Time - (Wait_time + Time_to_go),
	(Remainder < 0 -> 
		G_Robot := G_Robot + max(0, Elapsed_Time - Wait_time) * G_Speed 
			* sign(vana_pos(Vana) - G_Robot)
	else
		hanger_operation(Hanger) := hanger_operation(Hanger) + 1,
		G_Robot := vana_pos(Vana),
		G_Hanger := Hanger,
		vana_hanger(Vana) := 0,
		New_Current_Time := Current_Time + Wait_time + Time_to_go,
		bring(Vana, New_Current_Time, Remainder)
	).

bring(Vana, Current_Time, Elapsed_Time) :-
	Operation := hanger_operation(G_Hanger),
	Name := program_name(Operation),
	find_vana(New, Vana, Name),
	Time_to_go := (vana_pos(New) - G_Robot) / G_Speed,
	Remainder := Elapsed_Time - Time_to_go,
	(Remainder < 0 -> 
		G_Robot := G_Robot + Elapsed_Time * G_Speed
	else
		G_Robot := vana_pos(New),
		vana_hanger(New) := G_Hanger,
		New_Current_Time := Current_Time + Time_to_go,
		hanger_when(G_Hanger) := New_Current_Time + program_stay(Operation),
		G_Hanger := 0,
		G_Plan_Br := G_Plan_Br + 1,
		make_operations(New_Current_Time, Remainder)
	).

find_vana(New, Vana, Name) :-
	Vana < G_N,
	Next := Vana + 1,
	(vana_name(Next) =:= Name, vana_hanger(Next) =:= 0 -> 
		New := Next
	else
		find_vana(New, Next, Name)
	).

%Choose the best plan by simulating all options
make_plan(Current_Time, Elapsed_Time, Result) :-
	(find_occupied_vana(_) ->
		find_occupied_vana(Vana),
		first_plan(G_Plan_Br) := Vana,
		Hanger := vana_hanger(Vana),
		fake_take(Vana, Hanger, Current_Time, Elapsed_Time, Result)
	else
		save_result(Result)
	).

save_result(Result) :-
	(G_MaxResult < Result ->
		G_MaxResult := Result,
		save_plan,
		write(Result + " - "),
		print_plan
	),
	fail.

find_occupied_vana(Vana) :-
	for(Vana, 1, 34),
		vana_hanger(Vana) > 0.

fake_take(Vana, Hanger, Current_Time, Elapsed_Time, Result) :-
	Time_to_go := abs(vana_pos(Vana) - G_Robot) / G_Speed,
	Wait_time := max(0, hanger_when(Hanger) - Current_Time - Time_to_go),
	Remainder := Elapsed_Time - (Wait_time + Time_to_go),
	Operation := hanger_operation(Hanger),
	(Remainder < 0 -> 
		Name := program_name(Operation + 1),
		find_vana(_, Vana, Name),
		save_result(Result + Remainder)
	else
		hanger_operation(Hanger) has_to hanger_operation(Hanger) + 1,
		vana_hanger(Vana) has_to 0,
		New_Current_Time := Current_Time + Wait_time + Time_to_go,
		Burnout := -1 * program_important(Operation),
		New_Result := Result - Burnout * Remainder,
		fake_bring(Vana, Hanger, New_Current_Time, Remainder, New_Result)
	).

fake_bring(Vana, Hanger, Current_Time, Elapsed_Time, Result) :-
	Operation := hanger_operation(Hanger),
	Name := program_name(Operation),
	find_vana(New, Vana, Name),
	Time_to_go := (vana_pos(New) - G_Robot) / G_Speed,
	Remainder := Elapsed_Time - Time_to_go,
	(Remainder < 0 -> 
		save_result(Result + Remainder)
	else
		G_Robot has_to vana_pos(New),
		vana_hanger(New) has_to Hanger,
		New_Current_Time := Current_Time + Time_to_go,
		hanger_when(Hanger) has_to New_Current_Time + program_stay(Operation),
		G_Plan_Br has_to G_Plan_Br + 1,
		Important := program_important(Operation),
		Burnout := -1 * Important,
		(Remainder > program_stay(Operation) ->
			New_Result := Result + Important * program_stay(Operation) 
						- Burnout * (Remainder - program_stay(Operation))
		else
			New_Result := Result + Important * Remainder
		),
		make_plan(New_Current_Time, Remainder, New_Result)
	).

print_plan :-
	for(I, 0, G_Plan_Br),
		write(plan(I) + ", "),
		fail.

print_plan :- nl.

save_plan :-
	for(I, 0, G_Plan_Br),
		plan(I) := first_plan(I),
		fail.

save_plan.

%Initialize the array of bath enumerations
init_vana :-
	Pos := 50,
	G_N := 0,
	Miene := 0,
	vana(Name, Num, Size, Color),
	for(I, 1, Num),		
		G_N := G_N + 1,
		vana_pos(G_N) := Pos + Size / 2,
		(Name = miene -> 
			Miene := Miene + 1,
			vana_name(G_N) := "miene" + Miene
		else
			vana_name(G_N) := Name
		),
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
	(important(Name, Val) ->
		program_important(N) := Val
	),
	init_program(N + 1, Tail).

init_program(_, []).

set_window_text :-
	set_text("Galvanic Line " + integer(G_Time) + " x " + G_Multiplier, _).