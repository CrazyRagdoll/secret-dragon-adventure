%declare current_location as dynamic, so it can change.
:- dynamic current_location/2, in_hand/1, in_bag/1, is_at/2, object_at/2.
:-retractall(current_location(_)).

%initial setup.
	current_location([1,1]). % start at grid position 0,0

%location of stuff
	is_at(hamlet, sellsword).
	is_at(marketplace, blacksmith).
	is_at(keep, mesanth).
	
%in bag
	in_bag(bread).
	in_bag(canteen).

%in hand
	in_hand(shortsword).
%world
%	coord(hamlet, '0,0').
%	coord(cornfield, '0,1').
%	coord(marketplace, '1,0').
%	coord(keep, '1,1').
%	coord(dungeon, '1,2').

%walls limit how far the player can move
	limit([_,0], s).
	limit([7,_], e).
	limit([_,7], n).
	limit([0,_], w).

%world paths
%	path(hamlet, e, cornfield).
%	path(hamlet, n, marketplace).

%	path(cornfield, w, hamlet).
%	path(cornfield, n, keep).

%	path(marketplace, s, hamlet).
%	path(marketplace, e, keep).

%	path(keep, w, marketplace).
%	path(keep, s, cornfield).
%	path(keep, n, dungeon).

%	path(dungeion, s, keep).

%people.
	person(sellsword).
	person(blacksmith).

%experimenting with different forms of specifying that a location is occupied by something.
	monster([X,Y]):-
		assert(object_at([(X + 1),Y], roar)),
		assert(object_at([(X - 1),Y], roar)),
		assert(object_at([X, (Y + 1)], roar)),
		assert(object_at([X, (Y - 1)], roar)).

%responses from NPCs
	response(sellsword, 'So you''re the one looking for ol'' Mesanth aye? well, i too have quested to defeat the Beast, but i could not find him, all i found was what remains of the places it has visited. Do not make the same mistake i did.').

%give back story and observe initial location.
start:-
	write('You are an adventurer who has travelled far, you journey to defeat the largest dragon in the land, Mesanth Eater of Sheep, has brought you here.'), nl, observe.

%observe current surroundings.
observe:-
	current_location([X,Y]),
	write('i am at grid position '),
	write([X,Y]), nl,
	list_things, !.

%list all things where the player currently is.
list_stuff:-
	current_location([X,Y]),
	object_at([X,Y], Z),
	write('you notice a '), write(Z), write(' is located here.'), nl, fail.
list_stuff(_).

%talk to X, X must be a person and be where the player is.
talk_to(Z):-
	current_location([X,Y]),
	person(Z),
	is_at([X,Y], Z),
	response(Z, T),
	write(T), nl, !.

%list items and nearby locations.
list_things:-
	list_stuff.
%DEPRECATED
%	list_locations.

%check bag
check_bag:-
	list_my_stuff, !.

%list stuff in the players bag
list_my_stuff:-
	in_bag(X),
	write('i have a '), write(X), nl, fail,
	in_bag(X).

%check what i can travel to
%DEPRECATED
%list_locations:-
%	current_location([X,Y]),
%	write('i can go '), write(Y), write(' to get to the '), write(Z), nl, fail.
%list_locations(_).

%travel 1 grid position in the direction specified, unless that takes them to a wall.
travel(I):-
	current_location([OX,OY]),(
	(I = n,
		NEWY is OY + 1, not(limit([OX,NEWY], I)), retract(current_location([OX,OY])),assert(current_location([OX,NEWY]))),!;
	(I = e,
		NEWX is OX + 1, not(limit([NEWX,OY], I)), retract(current_location([OX,OY])),assert(current_location([NEWX, OY]))), !;
	(I = s,
		NEWY is OY +(-1), not(limit([OX,NEWY], I)), retract(current_location([OX,OY])),assert(current_location([OX,NEWY]))), !;
	(I = w,
		NEWX is OX +(-1), not(limit([NEWX,OX], I)), retract(current_location([OX,OY])),assert(current_location([NEWX,OY]))), !),
	write('you have travelled '), write(I), write(' and arrived safely.').
%pull out an object in the players inventory.
equip(Z):-
	current_location([X,Y]),
	in_bag(Z), (in_bag(Z);is_at(Z,X)),
	\+person(X),
	in_hand(E),
	retract(in_hand(E)),
	in_bag(Z), (retract(in_bag(Z));retract(object_at(Z,[X,Y]))),
	assert(in_bag(E)),
	assert(in_hand(Z)), !.
