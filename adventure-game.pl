%declare current_location as dynamic, so it can change.
:- dynamic current_location/1, in_hand/1, in_bag/1, is_at/2, monster/1, game_over/2, check_danger/1.
:-retractall(current_location(_)).

%location of stuff
	is_at(hamlet, sellsword).
	is_at(marketplace, blacksmith).
	is_at(keep, mesanth).
	
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
		not(monster([X,Y]));
		assert(game_over(X,Y)).

%game over!
	game_over(X,Y):-
		write('Oh no! you were defeated at position: '), write(X), write(','), write(Y).
	
%experimenting with different forms of specifying that a location is occupied by something, and moving a monster around the map.
setup_world:-
	assert(current_location([1,1])), % start at grid position 0,0
	assert(monster([4, 5])).	 % spawn a monster.
		
%update_world:-
	%monster_decide.

monster_update(I):-
	monster([OX,OY]), (
	(I = n, NEWY is OY + 1, not(limit([OX,NEWY], I)), retract(monster([OX,OY])),assert(monster([OX,NEWY]))),!;
	(I = e, NEWX is OX + 1, not(limit([NEWX,OY], I)), retract(monster([OX,OY])),assert(monster([NEWX, OY]))), !;
	(I = s, NEWY is OY +(-1), not(limit([OX,NEWY], I)), retract(monster([OX,OY])),assert(monster([OX,NEWY]))), !;
	(I = w, NEWX is OX +(-1), not(limit([NEWX,OX], I)), retract(monster([OX,OY])),assert(monster([NEWX,OY]))), !).

	monster_decide:-
		I is 'e',
		monster_update(I).

%give back story and observe initial location.
start:-
	write('You are an adventurer who has travelled far, you journey to defeat the largest dragon in the land, Mesanth Eater of Sheep, has brought you here.'), nl, setup_world, observe.

%observe current surroundings.
observe:-
	current_location([X,Y]),
	write('i am at grid position '),
	write([X,Y]), nl,
	list_things, !.
	
%list all things where the player currently is.
list_stuff:-
	current_location([X,Y]),
	(monster([X,Y]),write('you notice a monster nearby.'), nl, !).
	%roar([X,Y]),write('you hear a nearby roar.'),nl, !).
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
	write('you have travelled '), write(I), write(' and arrived safely.'), observe.

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
