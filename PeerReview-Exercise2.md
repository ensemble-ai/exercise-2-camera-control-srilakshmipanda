# Peer-Review for Programming Exercise 2 #

# Solution Assessment #

## Peer-reviewer Information

* *name:* Ian O'Connell
* *email:* iroconnell@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Implementation for stage 1 satisfies all the requirements. The camera stays focused on the target vessel in the center of the screen. 
The implementation works at different vessel speeds perfectly. 
___
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The stage 2 implementation staisfies all the rqeuirements for this part. The camera is horizontally auto scrolling to the right and the vessel will be dragged along with the camera if it collides with the left edge of the camera. The boundaries on the top, right, and bottom edges prevent the player from leaving the camera. Perfectly functional implementation, the only small thing I would note is the scroll speed vs vessel movement speed could be optimized but this is a gameplay feel rather than implementation point. Well done! 

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The stage 3 implementation is working as expected. There is a difference between the follow_speed and catchup_speed which apply appropriately in the conditions when they should be used. The camera will never be more than leash_distance away from the player as required by the problem specifications. There is some glitching when the player is at that maximum distance which is why I put this as a great implementation.

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The stage 4 camera implementation seems to work appropriately under certain conditions. If the user player in one direction the camera will move out in front of them and then return back to them when they stop moving. All the expected exported fields are used in this implementation. I notived if the player moves in a single direction (either up, down, left, or right) the camera will stay stuck on them before moving out in front of the vessel. There are also ways to move around quickly that get the camera stuck behind the vessel. The basic implementation of stage 4 is there it would just need a little polishing to fix these cases. 

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Stage 5 utilizes the expeted exported fields to implement a camera that behaves similar to how the project specifies it should behave. There is an issue where when the vessel is in the speedup zone their movement becomes very choppy with them appearing to move in short teleports rather than a smooth line. The sppedup zone has a push ratio that is less than one causing it to behave as a slow down zone. When the push ratio is above 1 to give the player accleration they are not able to enter the speedup zone at all. When the player is in the speedup zone and reaches the edge of the push box their movement returns to the smooth movement which is good. The solution is getting towards a fully working solution but without being able to have a functioning speedup zone it still needs some work. 
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

#### Style Guide Exemplars ####
* https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/horizontal_autoscroll.gd#L32 - Good job declaring variables close to where they are used throughout all the stages. 

* Naming conventions are handled well with variables being snake case and class names being camel case
___
#### Put style guide infractures ####

* https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/speed_up_push_zone.gd#L73 - Private functions should appear after public functions. In this case draw_logic is public and so it should be above the private _is_inside_speedup_zone function. 

* https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/speed_up_push_zone.gd#L113 - There are several lines throughout the stages that have more than the style guide's recommendation of 100 characters. Particularly in the draw_logic functions I see some lines that could be stretch across multiple. 

* https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/horizontal_autoscroll.gd#L49 - There are supposed to be two blank lines surrounding funtions and class definitions. 

* https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/push_box.gd#L24 - with comments there should be one space between the # and the comment if it is a true comment, when it is commented out code there should be no space like how you did here https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/lerp_smoothing.gd#L48
___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

* https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/position_lock.gd#L19 - these two lines could be shrunk to just position = target.position because it will transfer all the coordinates. This appears a few times throughout the code. 

#### Best Practices Exemplars ####

* https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/speed_up_push_zone.gd#L34 - breaking up the distance calculation from the comparison to 0 made this far more readable, good call here.

* https://github.com/ensemble-ai/exercise-2-camera-control-srilakshmipanda/blob/363af9ab29faa0bab190ffeb5cc1df8bbf3525c1/Obscura/scripts/camera_controllers/speed_up_push_zone.gd#L73 - having this logic in another function improves readability greatly