%declare current_location as dynamic, so it can change.
:- dynamic current_location/1.

%initial world setup.
	current_location(hamlet). %gridpos00
	is_at(hamlet, sellsword).
	is_at(hamlet, blacksmith).
	coord(hamlet, '0,0').
%define people.
	person(sellsword).
	person(blacksmith).

%responses from NPCs
	response(sellsword, 'So you''re the one looking for ol'' Mesanth aye? well, i too have quested to defeat the Beast, but i could not find him, all i found was what remains of the places it has visited. Do not make the same mistake i did.').

%give back story and observe initial location.
start:-
	write('You are an adventurer who has travelled far, you journey to defeat the largest dragon in the land, Mesanth Eater of Sheep, has brought you here.'), nl,
	observe.
%observe current surroundings.
observe:-
	current_location(X),
	coord(X, Y),
	write('i am at the '),
	write(X), nl,
	write('grid position '),
	write(Y), nl,
	list_stuff(X).

%list all things where the player currently is.
list_stuff(X):-
	is_at(X, THING),
	write('you notice a '), write(THING), write(' is located here.'), nl, fail.
list_stuff(X).

%talk to X, X must be a person and be where the player is.
talk_to(X):-
	current_location(Z),
	person(X),
	is_at(Z, X),
	response(X, T),
	write(T), nl.
