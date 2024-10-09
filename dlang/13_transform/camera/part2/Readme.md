# Invaders!

> "Or rather a minimal space invaders game"

# Resources to help

Provided below are a list of curated resources to help you complete the task(s) below. Consult them (read them, or do ctrl+f for keywords) if you get stuck.

| D Programming Related Links                         | Description                       |
| --------------------------------------------------  | --------------------------------- |
| [My D Youtube Series](https://www.youtube.com/playlist?list=PLvv0ScY6vfd9Fso-3cB4CGnSlW0E4btJV) | My video series playlist for learning D Lang. |
| [DLang Phobos Standard Library Index](https://dlang.org/phobos/index.html)  | The Phobos Runtime Library (i.e. standard library of code.)
| [D Language Tour](https://tour.dlang.org/)           | Nice introduction to the D Language with samples you can run in the browser. |
| [Programming in D](https://ddili.org/ders/d.en/)     | Freely available D language programming book |
| [My SDL Playlist](https://www.youtube.com/playlist?list=PLvv0ScY6vfd-p1gSnbQhY7vMe2rng0IL0)     | My SDL Playlist |

## Description

I know folks have been [chomping on the bit](https://www.merriam-webster.com/dictionary/champing%20at%20the%20bit) to write a game -- so now is your chance. Or rather, to at least start putting pieces together.

## Task 1

## How to compile and run your program

1. You can use simply run `dub` file to build and run the project.
   - In order to provide arguments to our executable (and not otherwise dub) -- use:
     	- `dub -- "./assets/images/test.bmp" "./assets/images/test.json"`
     	- `dub -- "./assets/images/walk.bmp" "./assets/images/walk.json"`
   - Note: `dub` by default does a debug build.
   - Don't forget to use [gdb](https://www.youtube.com/watch?v=NWsZrN7gXYg) or [lldb](https://www.youtube.com/watch?v=drzvDkU-H54) if you run into errors!

# Submission/Deliverables

### Submission

- Commit all of your files to github, including any additional files you create.
- Do not commit any binary files unless told to do so.
- Do not commit any 'data' files generated when executing a binary.

### Deliverables

- An animation that matches the above animations for both the test and walk file.
  - Both sprite sheets (test and walk) should work (i.e. frames not skipped)
  - The character should change states as they hit each wall corner.

# Going Further

An optional task(if any) that will reinforce your learning throughout the semester--this is not graded.

1. Try implementing a state machine.

# F.A.Q. (Instructor Anticipated Questions)

1. Q: Can I add my own sprite sheets?
	- A: Yes! Go for it! However, I'll just be grading the above two as 'unit tests' for this assignment. If you add other assets, please let me know so I can try them out!
