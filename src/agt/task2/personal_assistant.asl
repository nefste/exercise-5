// personal assistant agent 

/* Task 2 Start of your solution */


// Plan when the belief about the lights state is added or deleted
+lights(State) : true <-
    .print("The lights are now ", State).
-lights(State) : true <-
    .print("The lights were ", State).

// Plan when the belief about the blinds state is added or deleted
+blinds(State) : true <-
    .print("The blinds are now ", State).
-blinds(State) : true <-
    .print("The blinds were ", State).

// Plan when the belief about the mattress state is added or deleted
+mattress(State) : true <-
    .print("The mattress is now ", State).
-mattress(State) : true <-
    .print("The mattress was ", State).

// Plan when the belief about the owner's state is added or deleted
+owner_state(State) : true <-
    .print("The owner is now ", State).
-owner_state(State) : true <-
    .print("The owner was ", State).


// Plan to wake up the user for an upcoming event
+upcoming_event("now") : owner_state("asleep") <-
    // See implementation below with plan to wake up the user based on the best option
    !wake_up_user.
    // ?lights("off"); // Check if lights are off
    // turnOnLights; // Action to turn on the lights
    // .print("Turning on the lights to wake up the owner for an upcoming event.").

    // ?blinds("lowered"); // Check if blinds are lowered
    // raiseBlinds; // Action to raise the blinds
    // .print("Raising the blinds to let sunlight in and wake up the owner.").

    // ?mattress("idle"); // Check if the mattress is in idle mode
    // setVibrationsMode; // Action to set the mattress to vibrations mode
    // .print("Setting the mattress to vibrations mode to wake up the owner.").



// Plan to wake up the user based on the best option
+!wake_up_user : best_option(vibrations) & owner_state("asleep") <-
    setVibrationsMode;
    .print("Setting the mattress to vibrations mode to wake up the owner.").
    
+!wake_up_user : best_option(artificial_light) & owner_state("asleep") <-
    turnOnLights;
    .print("Turning on the artificial lights to wake up the owner.").
    
+!wake_up_user : best_option(natural_light) & owner_state("asleep") <-
    raiseBlinds;
    .print("Raising the blinds to use natural light to wake up the owner.").

// Reasserting the goal if the user is still asleep
+!wake_up_user : owner_state("asleep") <-
    .wait(1000); // Wait for a bit before trying again
    !wake_up_user.

// Plan when the user becomes awake
+owner_state("awake") : true <-
    .print("The user is now awake. Design objective has been achieved.").


// Plan when user is awake
+upcoming_event("now") : owner_state("awake") <-
    .print("Enjoy your event").

// Plan when user is asleep
+upcoming_event("now") : owner_state("asleep") <-
    .print("Starting wake-up routine").



// Rule to determine the best wake-up option based on rankings, not really sure if correct (?)
+!find_best_option : true <-
    .findall(Rank-Method, wake_up_preference(Method, Rank) & not used_method(Method), Options);
    .sort(Options, SortedOptions);
    // takes the first (lowest-ranked) option from the sorted list as the best method using .nth.
    .nth(0, SortedOptions, BestRank-BestMethod);
    +best_option(BestMethod).

// Initial beliefs about wake-up preferences
wake_up_preference(artificial_light, 2).
wake_up_preference(natural_light, 1).
wake_up_preference(vibrations, 0).


/* Task 2 End of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }