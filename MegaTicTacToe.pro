?-
	G_Identation := 50,
	G_InGame := true,
	G_Turn := o,
	G_Next_X := -1,
	G_Next_Y := -1,
	window(title("Mega Tic-Tac-Toe"), size(800, 800)).

table([[[[e, e, e], [e, e, e], [e, e, e]], [[e, e, e], [e, e, e], [e, e, e]], [[e, e, e], [e, e, e], [e, e, e]]],
	[[[e, e, e], [e, e, e], [e, e, e]], [[e, e, e], [e, e, e], [e, e, e]], [[e, e, e], [e, e, e], [e, e, e]]],
	[[[e, e, e], [e, e, e], [e, e, e]], [[e, e, e], [e, e, e], [e, e, e]], [[e, e, e], [e, e, e], [e, e, e]]]]).

cell(Value, [Value, _, _], 0).
cell(Value, [_, Value, _], 1).
cell(Value, [_, _, Value], 2).

place([Value, X, Y], [_, X, Y], Value, 0).
place([X, Value, Y], [X, _, Y], Value, 1).
place([X, Y, Value], [X, Y, _], Value, 2).

win([[X, X, X],
	[_, _, _],
	[_, _, _]], X).
win([[_, _, _],
	[X, X, X],
	[_, _, _]], X).
win([[_, _, _],
	[_, _, _],
	[X, X, X]], X).

win([[X, _, _],
	[X, _, _],
	[X, _, _]], X).
win([[_, X, _],
	[_, X, _],
	[_, X, _]], X).
win([[_, _, X],
	[_, _, X],
	[_, _, X]], X).

win([[X, _, _],
	[_, X, _],
	[_, _, X]], X).
win([[_, _, X],
	[_, X, _],
	[X, _, _]], X).

win_func(paint) :-
	Window_Title := "Mega Tic-Tac-Toe: " + (G_Turn = o -> "O's turn." else "X's turn."),
	(G_Next_X > -1, G_Next_Y > -1 ->
		pen(0),
		brush(rgb(194, 255, 198)),
		Draw_X := G_Identation + 200 * G_Next_X,
		Draw_Y := G_Identation + 200 * G_Next_Y,
		rect(Draw_X, Draw_Y, Draw_X + 200, Draw_Y + 200),
		brush(rgb(255, 255, 255))
	else (G_Next_X =:= -1, G_Next_Y =:= -1 ->
		Window_Title := Window_Title + " You can play anywhere!")
	),
	set_text(Window_Title, _),
	for(I, 1, 2),
		pen(10, rgb(0, 0, 0)),
		line(G_Identation + 200 * I, G_Identation, G_Identation + 200 * I, G_Identation + 600),
		line(G_Identation, G_Identation + 200 * I, G_Identation + 600, G_Identation + 200 * I),
		fail;
	for(X1, 0, 2),
		for(Y1, 0, 2),
			get_cell(Value, X1, Y1, 0, 0),
			Value \= owin, 
			Value \= xwin,
			for(X2, 1, 2),
				for(Y2, 1, 2),
					pen(5),
					Vertical_Line_X := G_Identation + 10 + 200 * X1 + 60 * X2,
					line(Vertical_Line_X, G_Identation + 10 + 200 * Y1, Vertical_Line_X, G_Identation + 190 + 200 * Y1),
					Horizontal_Line_Y := G_Identation + 10 + 200 * Y1 + 60 * Y2,
					line(G_Identation + 10 + 200 * X1, Horizontal_Line_Y, G_Identation + 190 + 200 * X1, Horizontal_Line_Y),
					fail;
	for(X1, 0, 2),
		for(Y1, 0, 2),
			get_cell(Win_Value, X1, Y1, 0, 0),
			(Win_Value\= owin, Win_Value \= xwin ->
				for(X2, 0, 2),
					for(Y2, 0, 2),
						get_cell(Value, X1, Y1, X2, Y2),
						Value \= e,
						Draw_X := G_Identation + 15 + 200 * X1 + 60 * X2,
						Draw_Y := G_Identation + 15 + 200 * Y1 + 60 * Y2,
						(Value = o ->
							pen(5, rgb(255, 0, 0)),
							ellipse(Draw_X, Draw_Y, Draw_X + 50, Draw_Y + 50)
						else
							pen(5, rgb(0, 0, 255)),
							line(Draw_X + 5, Draw_Y + 5, Draw_X + 45, Draw_Y + 45),
							line(Draw_X + 5, Draw_Y + 45, Draw_X + 45, Draw_Y + 5)
						),
						fail
			else
				Draw_X := G_Identation + 25 + 200 * X1,
				Draw_Y := G_Identation + 25 + 200 * Y1,
				(Win_Value = owin ->
					pen(10, rgb(255, 0, 0)),
					ellipse(Draw_X, Draw_Y, Draw_X + 150, Draw_Y + 150)
				else
					pen(10, rgb(0, 0, 255)),
					line(Draw_X + 5, Draw_Y + 5, Draw_X + 145, Draw_Y + 145),
					line(Draw_X + 5, Draw_Y + 145, Draw_X + 145, Draw_Y + 5)
				)
			),
			fail.


win_func(mouse_click(X, Y)) :-
	%check if move is legal
	G_InGame,
	X >= G_Identation,
	X =< G_Identation + 600,
	Y >= G_Identation,
	Y =< G_Identation + 600,
	Big_X := (X - G_Identation) // 200,	
	Big_Y := (Y - G_Identation) // 200,
	(G_Next_X =:= -1; G_Next_X =:= Big_X),
	(G_Next_Y =:= -1; G_Next_Y =:= Big_Y),
	Small_X := (X - G_Identation - 200 * Big_X) // 66,
	Small_X < 3,
	Small_Y := (Y - G_Identation - 200 * Big_Y) // 66,
	Small_Y < 3,
	get_cell(Value, Big_X, Big_Y, Small_X, Small_Y),
	Value = e,
	%apply move
	set_cell(G_Turn, Big_X, Big_Y, Small_X, Small_Y),
	check_small_win(Big_X, Big_Y),
	no_draw,
	set_next_destination(Small_X, Small_Y),
	G_Turn := (G_Turn = o -> x else o),
	update_window(_).

get_cell(Value, Big_X, Big_Y, Small_X, Small_Y) :-
	table(Table),
	cell(Big_Row, Table, Big_Y),
	cell(Small_Table, Big_Row, Big_X),
	cell(Small_Row, Small_Table, Small_Y),
	cell(Value, Small_Row, Small_X).

set_cell(Value, Big_X, Big_Y, Small_X, Small_Y) :-
	table(Table),
	cell(Big_Row, Table, Big_Y),
	cell(Small_Table, Big_Row, Big_X),
	cell(Small_Row, Small_Table, Small_Y),
	place(New_Small_Row, Small_Row, Value, Small_X),
	place(New_Small_Table, Small_Table, New_Small_Row, Small_Y),
	place(New_Big_Row, Big_Row, New_Small_Table, Big_X),
	place(New_Table, Table, New_Big_Row, Big_Y),
	set(table(New_Table)).

check_small_win(Big_X, Big_Y) :-
	table(Table),
	cell(Big_Row, Table, Big_Y),
	cell(Small_Table, Big_Row, Big_X),
	(win(Small_Table, G_Turn) ->
		Win_Mark := (G_Turn = o -> owin else xwin),
		(for(Small_X, 0, 2),
			for(Small_Y, 0, 2),
				set_cell(Win_Mark, Big_X, Big_Y, Small_X, Small_Y),
				fail;
		not(check_big_win))
	).

set_next_destination(Big_X, Big_Y) :-
	G_Next_X := -1,
	G_Next_Y := -1,
	for(Small_X, 0, 2),
		for(Small_Y, 0, 2),
			get_cell(e, Big_X, Big_Y, Small_X, Small_Y),
	G_Next_X := Big_X,
	G_Next_Y := Big_Y.

set_next_destination(Big_X, Big_Y).

check_big_win :-
	table(Table),
	win(Table, Winner_Table),
	cell(Row, Winner_Table, 0),
	cell(Winner, Row, 0),
	Winner \= e,
	G_InGame := false,
	G_Next_X := -2,
	G_Next_Y := -2,
	update_window(_),
	(Winner = owin ->
		message("Game over", "O wins!", !)
	else
		message("Game over", "X wins!", !)
	).

no_draw :-
	for(Big_X, 0, 2),
		for(Big_Y, 0, 2),
			for(Small_X, 0, 2),
				for(Small_Y, 0, 2),
					get_cell(e, Big_X, Big_Y, Small_X, Small_Y);
	G_InGame := false,
	G_Next_X := -2,
	G_Next_Y := -2,
	update_window(_),
	message("Game over", "It's a draw!", !),
	fail.