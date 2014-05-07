start:-
	write('You are an adventurer who has travelled far, you journey to defeat the largest dragon in the land, Mesanth Eater of Sheep, has brought you here.'), nl.

:- dynamic current_location/1.

	current_location(hamlet). %gridpos00
	is_at(hamlet, sellsword).
	coord(hamlet, '0,0').
observe:-
	current_location(X),
	coord(X, Y),
	write('i am at the '),
	write(X), nl,
	write('grid position '),
	write(Y), nl,
	list_stuff(X).

list_stuff(X):-
	is_at(X, THING),
	write('you notice a '), write(THING), write(' is located here.'), nl.
