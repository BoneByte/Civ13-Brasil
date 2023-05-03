// Language flags.
#define WHITELISTED  1   // Language is available if the speaker is whitelisted.
#define RESTRICTED   2   // Language can only be acquired by spawning or an admin.
#define NONVERBAL	4   // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG	 8   // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND	 16  // Broadcast to all mobs with this language.
#define NONGLOBAL	32  // Do not add to general languages list.
#define INNATE	   64  // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG  128 // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER   256 // No stuttering, slurring, or other speech problems
#define COMMON_VERBS 512