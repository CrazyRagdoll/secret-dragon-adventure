%declare current_location as dynamic, so it can change.
:- dynamic current_location/1.

%initial setup.
	current_location(hamlet). % start at grid position 0,0

%location of stuff
	is_at(hamlet, sellsword).
	is_at(hamlet, blacksmith).
	is_at(keep, mesanth).

%in bag
	in_bag(shortsword).
	in_bag(bread).
	in_bag(canteen).
%world
	coord(hamlet, '0,0').
	coord(cornfield, '0,1').
	coord(gatehouse, '1,0').
	coord(keep, '1,1').

%world paths
	path(hamlet, e, cornfield).
	path(hamlet, n, gatehouse).

	path(cornfield, w, hamlet).
	path(cornfield, n, keep).

	path(gatehouse, s, hamlet).
	path(gatehouse, e, keep).

	path(keep, w, gatehouse).
	path(keep, s, cornfield).

%people.
	person(sellsword).
	person(blacksmith).

%responses from NPCs
	response(sellsword, 'So you''re the one looking for ol'' Mesanth aye? well, i too have quested to defeat the Beast, but i could not find him, all i found was what remains of the places it has visited. Do not make the same mistake i did.').

%give back story and observe initial location.
start:-
	write('You are an adventurer who has travelled far, you journey to defeat the largest dragon in the land, Mesanth Eater of Sheep, has brought you here.'), nl, observe.

%observe current surroundings.
observe:-
	current_location(X),
	coord(X, Y),
	write('i am at the '),
	write(X), nl,
	write('grid position '),
	write(Y), nl,
	list_locations,
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

%check bag
check_bag:-
	list_my_stuff.

%list stuff in the players bag
list_my_stuff:-
	in_bag(X),
	write('i have a '), write(X), nl, fail.

%check what i can travel to
list_locations:-
	current_location(X),
	path(X,Y,Z),
	write('i can go '), write(Y), write(' to get to the '), write(Z), nl, fail.

%travel
travel(X):-
	current_location(Y),
	path(Y,X,Z),
	current_location(Z),
	write('you make your way to the'), write(Z).
