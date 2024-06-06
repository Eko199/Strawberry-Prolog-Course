?-
	G_Identation := 50,
	G_InGame := true,
	G_Turn := o,
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

win_func(paint) :-
	for(I, 1, 2),
		pen(10, rgb(0, 0, 0)),
		line(G_Identation + 200 * I, G_Identation, G_Identation + 200 * I, G_Identation + 600),
		line(G_Identation, G_Identation + 200 * I, G_Identation + 600, G_Identation + 200 * I),
		fail;
	for(X1, 0, 2),
		for(Y1, 0, 2),
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
					fail.


win_func(mouse_click(X, Y)) :-
	G_InGame,
	X >= G_Identation,
	X =< G_Identation + 600,
	Y >= G_Identation,
	Y =< G_Identation + 600,
	Big_X := (X - G_Identation) // 200,	
	Big_Y := (Y - G_Identation) // 200,
	Small_X := (X - G_Identation - 200 * Big_X) // 66,
	Small_X < 3,
	Small_Y := (Y - G_Identation - 200 * Big_Y) // 66,
	Small_Y < 3,
	get_cell(Value, Big_X, Big_Y, Small_X, Small_Y),
write(Value),
	Value = e,
	set_cell(G_Turn, Big_X, Big_Y, Small_X, Small_Y),
	(G_Turn = o ->
		G_Turn := x
	else
		G_Turn := o
	),
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
