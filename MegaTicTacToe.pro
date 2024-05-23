?-
	window(title("Mega Tic-Tac-Toe"), size(800, 800)).

win_func(paint) :-
	Identation := 50,
	for(I, 1, 2),
		pen(10, rgb(0, 0, 0)),
		line(Identation + 200 * I, Identation, Identation + 200 * I, Identation + 600),
		line(Identation, Identation + 200 * I, Identation + 600, Identation + 200 * I),
		fail;
	for(X1, 0, 2),
		for(Y1, 0, 2),
			for(X2, 1, 2),
				for(Y2, 1, 2),
					pen(5),
					Vertical_Line_X := Identation + 10 + 200 * X1 + 60 * X2,
					line(Vertical_Line_X, Identation + 10 + 200 * Y1, Vertical_Line_X, Identation + 190 + 200 * Y1),
					Horizontal_Line_Y := Identation + 10 + 200 * Y1 + 60 * Y2,
					line(Identation + 10 + 200 * X1, Horizontal_Line_Y, Identation + 190 + 200 * X1, Horizontal_Line_Y),
					fail.
