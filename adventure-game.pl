%declare as dynamic, so it can change.
:- dynamic current_location/1, in_hand/1, in_bag/1, is_at/2, monster/2, game_over/2, check_danger/1.
:-retractall([current_location(_), monster([_,_],_)]).
	
%in bag
	in_bag(bread).
	in_bag(canteen).

%in hand
	in_hand(shortsword).

%walls limit how far the player can move
	limit([_,0], s).
	limit([7,_], e).
	limit([_,7], n).
	limit([0,_], w).

%people.
	person(sellsword).
	person(blacksmith).

%locations with no danger.
	check_danger([X,Y]):-
		not(monster([X,Y],_));
		assert(game_over(X,Y)).

%game over!
	game_over(X,Y):-
		write('Oh no! you were defeated at position: '), write(X), write(','), write(Y).
	
%experimenting with different forms of specifying that a location is occupied by something, and moving a monster around the map.
setup_world:-
	assert(current_location([1,1])), % start at grid position 0,0
	assert(monster([4, 5], nelarth)).	 % spawn nelarth the monster.

%this will update the monsters and check if the player has died	
%update_world:-

%move the monster in the I direction
monster_update([X,Y],Z):-
	monster([OX,OY],Z),
	retract(monster([OX,OY],Z)),
	assert(monster([X,Y],Z)).

%the heuristic for pathfinding will be placed here.
	%monster_decide:-
		%I is 'e',
		%monster_update(I).

%give back story and observe initial location.
start:-
	write('You are an adventurer who has travelled far, you journey to defeat the largest dragon in the land, Nelarth, Eater of Sheep, has brought you here.'), nl, setup_world, observe.

%observe current surroundings.
observe:-
	current_location([X,Y]),
	write('i am at grid position '),
	write([X,Y]), nl,
	list_things, !.
	
%list all things where the player currently is.
list_stuff:-
	current_location([X,Y]),
	(monster([X,Y],Z),write('you notice '),write(Z), write(' is nearby.'), nl, !).
list_stuff:-
	write('theres nothing here.').

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

%check bag
check_bag:-
	list_my_stuff, !.

%list stuff in the players bag
list_my_stuff:-
	in_bag(X),
	write('i have a '), write(X), nl, fail,
	in_bag(X).


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
	write('you have travelled '), write(I), write(' and arrived safely.'), nl, pathme, observe, !.

%pull out an object in the players inventory or pick it up from the floor
equip(Z):-
	current_location([X,Y]),
	in_bag(Z), (in_bag(Z);is_at(Z,X)),
	\+person(X),
	in_hand(E),
	retract(in_hand(E)),
	in_bag(Z), (retract(in_bag(Z));retract(object_at(Z,[X,Y]))),
	assert(in_bag(E)),
	assert(in_hand(Z)), !.

%find the shortest path
pathme:-
	monster([X,Y],Z),
	current_location([PX,PY]),
	distance([X,Y],[PX,PY],[DX,DY]),
	adjacent([X,Y],[TX,TY]),
	distance([TX,TY],[PX,PY],[TDX,TDY]),
	(TDX<DX;TDY<DY),
	NX is TX, NY is TY,
	monster_update([NX,NY], Z).


%distance between two points
distance([X,Y],[PX,PY],[DX,DY]):-
	DX is X - PX,
	DY is Y - PY.	

%find adjacent squares
adjacent([X,Y],[X,NY]):-
	Y < 6,
	NY is Y + 1.

adjacent([X,Y],[X,NY]):-
	Y > 1,
	NY is Y + (-1).

adjacent([X,Y],[NX,Y]):-
	X < 6,
	NX is X + 1.

adjacent([X,Y],[NX,Y]):-
	X > 1,
	NX is X + (-1).
